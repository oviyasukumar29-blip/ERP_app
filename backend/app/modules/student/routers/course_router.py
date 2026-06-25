# app/modules/student/routers/course_router.py

import uuid
from typing import List, Optional
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.core.database import get_db
from app.modules.student.models.course import Course
from app.modules.student.models.student_course import StudentCourse
from app.modules.student.models.course_video import CourseVideo
from app.modules.student.models.student import Student
from app.modules.student.models.enrollment import Enrollment

router = APIRouter(tags=["courses"])

MIN_COURSES_REQUIRED = 4


# ── Schemas ───────────────────────────────────────────────────

class CourseOut(BaseModel):
    id: str
    title: str
    description: str
    duration: str

    class Config:
        from_attributes = True


class CourseCreate(BaseModel):
    trainer_id: str
    title: str
    description: str = ""
    duration: str = ""


class SelectCoursesRequest(BaseModel):
    student_id: str
    course_ids: List[str]


class VideoOut(BaseModel):
    id: str
    course_id: str
    title: str
    description: str
    video_url: str
    duration_minutes: int
    sequence: int

    class Config:
        from_attributes = True


class VideoCreate(BaseModel):
    trainer_id: str
    title: str
    description: str = ""
    video_url: str
    duration_minutes: int = 0
    sequence: int = 0


class MyCourseOut(BaseModel):
    id: str
    title: str
    description: str
    duration: str
    videos: List[VideoOut]


# ── NEW: Assignment submission schema ─────────────────────────

class SubmitAssignmentRequest(BaseModel):
    student_id: str
    assignment_id: str
    submission_text: Optional[str] = None
    file_url: Optional[str] = None
    notes: Optional[str] = None
    answers: Optional[list] = None


class AssignmentStatusOut(BaseModel):
    assignment_id: str
    status: str
    submitted_at: Optional[str] = None
    grade: Optional[str] = None
    marks: Optional[int] = None
    feedback: Optional[str] = None


# ── Student: List ALL available courses ───────────────────────

@router.get("/student/courses/all", response_model=List[CourseOut])
def list_all_courses(db: Session = Depends(get_db)):
    courses = db.query(Course).order_by(Course.created_at.desc()).all()
    return [_course_out(c) for c in courses]


# ── Student: Check if courses already selected ────────────────

@router.get("/student/courses/selected/{student_id}", response_model=List[str])
def get_selected_course_ids(student_id: str, db: Session = Depends(get_db)):
    try:
        sid = uuid.UUID(student_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id")

    rows = db.query(StudentCourse).filter(StudentCourse.student_id == sid).all()
    return [str(r.course_id) for r in rows]


# ── Student: Select courses (minimum 4) ───────────────────────

@router.post("/student/courses/select")
def select_courses(payload: SelectCoursesRequest, db: Session = Depends(get_db)):
    if len(payload.course_ids) < MIN_COURSES_REQUIRED:
        raise HTTPException(
            status_code=400,
            detail=f"Please select at least {MIN_COURSES_REQUIRED} courses",
        )

    try:
        sid = uuid.UUID(payload.student_id)
        course_uuids = [uuid.UUID(c) for c in payload.course_ids]
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id or course_id")

    print(f"🟡 select_courses called: sid={sid} course_uuids={course_uuids}")

    student_profile = db.query(Student).filter(Student.user_id == sid).first()
    print(f"🟡 student_profile lookup result: {student_profile}")

    if student_profile is None:
        print("🟡 No Student profile found — creating one")
        student_profile = Student(user_id=sid)
        db.add(student_profile)
        db.commit()
        db.refresh(student_profile)
        print(f"🟡 Created student_profile.id={student_profile.id}")

    print(f"🟡 Using student_profile.id={student_profile.id} for Enrollment rows")

    db.query(StudentCourse).filter(StudentCourse.student_id == sid).delete()
    db.query(Enrollment).filter(Enrollment.student_id == student_profile.id).delete()

    for cid in course_uuids:
        db.add(StudentCourse(student_id=sid, course_id=cid))
        db.add(Enrollment(
            student_id=student_profile.id,
            course_id=cid,
            progress=0,
            status="in_progress",
        ))
        print(f"🟡 Added Enrollment: student_profile.id={student_profile.id} course_id={cid}")

    try:
        db.commit()
        print("🟢 select_courses commit SUCCESS")
    except Exception as e:
        print(f"🔴 select_courses commit FAILED: {e}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to save selection: {e}")

    return {"message": "Courses selected successfully", "count": len(course_uuids)}


# ── Student: Get MY enrolled courses with videos ──────────────

@router.get("/student/courses/my/{student_id}", response_model=List[MyCourseOut])
def get_my_courses(student_id: str, db: Session = Depends(get_db)):
    try:
        sid = uuid.UUID(student_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id")

    enrolled = db.query(StudentCourse).filter(StudentCourse.student_id == sid).all()
    course_ids = [e.course_id for e in enrolled]

    if not course_ids:
        return []

    courses = db.query(Course).filter(Course.id.in_(course_ids)).all()

    result = []
    for c in courses:
        videos = (
            db.query(CourseVideo)
            .filter(CourseVideo.course_id == c.id)
            .order_by(CourseVideo.sequence.asc())
            .all()
        )
        result.append(MyCourseOut(
            id=str(c.id),
            title=c.title or "",
            description=c.description or "",
            duration=c.duration or "",
            videos=[_video_out(v) for v in videos],
        ))

    return result


# ── Student: Get assignment statuses for a course ─────────────

@router.get("/student/assignments/{student_id}/{course_id}",
            response_model=List[AssignmentStatusOut])
def get_assignment_statuses(
    student_id: str,
    course_id: str,
    db: Session = Depends(get_db),
):
    """Returns all assignments for a course with this student's submission status."""
    try:
        sid = uuid.UUID(student_id)
        cid = uuid.UUID(course_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid ID")

    rows = db.execute(text("""
        SELECT
            a.id                                AS assignment_id,
            COALESCE(
                asub.status,
                CASE WHEN a.due_date < NOW() THEN 'missed' ELSE 'pending' END
            )                                   AS status,
            asub.submitted_at,
            asub.grade,
            asub.marks,
            asub.feedback
        FROM assignments a
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = :sid
        WHERE a.course_id = :cid
        ORDER BY a.due_date ASC
    """), {"sid": sid, "cid": cid}).fetchall()

    return [
        AssignmentStatusOut(
            assignment_id=str(row.assignment_id),
            status=row.status,
            submitted_at=row.submitted_at.isoformat() if row.submitted_at else None,
            grade=row.grade,
            marks=row.marks,
            feedback=row.feedback,
        )
        for row in rows
    ]


# ── Student: Submit an assignment ─────────────────────────────
# Auto-recalculates enrollments.progress after every submission.

@router.post("/student/assignments/submit")
def submit_assignment(
    payload: SubmitAssignmentRequest,
    db: Session = Depends(get_db),
):
    """
    Submit an assignment and automatically update course progress.

    Progress formula:
        progress % = (submitted assignments / total assignments in course) × 100

    Steps:
        1. Upsert assignment_submissions row
        2. Find the course this assignment belongs to
        3. Recalculate submitted / total for this student in that course
        4. UPDATE enrollments.progress
    """
    try:
        sid = uuid.UUID(payload.student_id)
        aid = uuid.UUID(payload.assignment_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id or assignment_id")

    # 1. Check if already submitted
    existing = db.execute(text("""
        SELECT id FROM assignment_submissions
        WHERE student_id = :sid AND assignment_id = :aid
    """), {"sid": sid, "aid": aid}).fetchone()

    if existing:
        # Update existing submission
        db.execute(text("""
            UPDATE assignment_submissions
            SET submission_text = :text,
                file_url        = :file_url,
                notes           = :notes,
                answers         = :answers,
                status          = 'submitted',
                submitted_at    = NOW()
            WHERE student_id = :sid AND assignment_id = :aid
        """), {
            "sid":      sid,
            "aid":      aid,
            "text":     payload.submission_text,
            "file_url": payload.file_url,
            "notes":    payload.notes,
            "answers":  str(payload.answers or []),
        })
    else:
        # Insert new submission
        db.execute(text("""
            INSERT INTO assignment_submissions
                (id, assignment_id, student_id, submission_text,
                 file_url, notes, answers, status, submitted_at)
            VALUES
                (gen_random_uuid(), :aid, :sid, :text,
                 :file_url, :notes, :answers, 'submitted', NOW())
        """), {
            "sid":      sid,
            "aid":      aid,
            "text":     payload.submission_text,
            "file_url": payload.file_url,
            "notes":    payload.notes,
            "answers":  str(payload.answers or []),
        })

    db.commit()

    # 2. Find the course this assignment belongs to
    course_row = db.execute(text("""
        SELECT course_id FROM assignments WHERE id = :aid
    """), {"aid": aid}).fetchone()

    if not course_row:
        raise HTTPException(status_code=404, detail="Assignment not found")

    course_id = course_row.course_id

    # 3. Recalculate progress:
    #    submitted assignments / total assignments in this course × 100
    counts = db.execute(text("""
        SELECT
            COUNT(a.id)                                              AS total,
            COUNT(asub.id) FILTER (WHERE asub.status = 'submitted') AS submitted
        FROM assignments a
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = :sid
        WHERE a.course_id = :cid
    """), {"sid": sid, "cid": course_id}).fetchone()

    total     = counts.total     or 0
    submitted = counts.submitted or 0
    new_progress = round((submitted / total) * 100) if total > 0 else 0

    # 4. Update enrollments.progress
    # enrollments uses student_profile.id (from students table), not user_id directly
    db.execute(text("""
        UPDATE enrollments e
        SET progress = :progress
        WHERE e.course_id  = :cid
          AND e.student_id = (
              SELECT id FROM students WHERE user_id = :user_id LIMIT 1
          )
    """), {
        "progress": new_progress,
        "cid":      course_id,
        "user_id":  sid,
    })

    db.commit()

    print(f"✅ Assignment submitted: student={sid} course={course_id} "
          f"progress={new_progress}% ({submitted}/{total})")

    return {
        "message":      "Assignment submitted successfully",
        "course_id":    str(course_id),
        "progress":     new_progress,
        "submitted":    submitted,
        "total":        total,
    }


# ── Trainer: Create a course ──────────────────────────────────

@router.post("/trainer/courses", response_model=CourseOut)
def create_course(payload: CourseCreate, db: Session = Depends(get_db)):
    course = Course(
        title=payload.title,
        description=payload.description,
        duration=payload.duration,
    )
    db.add(course)
    db.commit()
    db.refresh(course)
    return _course_out(course)


# ── Trainer: List their courses ───────────────────────────────

@router.get("/trainer/courses", response_model=List[CourseOut])
def list_trainer_courses(db: Session = Depends(get_db)):
    courses = db.query(Course).order_by(Course.created_at.desc()).all()
    return [_course_out(c) for c in courses]


# ── Helpers ───────────────────────────────────────────────────

def _course_out(c: Course) -> CourseOut:
    return CourseOut(
        id=str(c.id),
        title=c.title or "",
        description=c.description or "",
        duration=c.duration or "",
    )


def _video_out(v: CourseVideo) -> VideoOut:
    return VideoOut(
        id=str(v.id),
        course_id=str(v.course_id),
        title=v.title or "",
        description=v.description or "",
        video_url=v.video_url or "",
        duration_minutes=v.duration_minutes or 0,
        sequence=v.sequence or 0,
    )