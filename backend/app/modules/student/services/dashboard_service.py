from datetime import date, timedelta

from sqlalchemy.orm import Session

from app.shared.models.user import User
from app.modules.student.models.attendance import Attendance
from app.modules.student.models.student import Student
from app.modules.student.models.enrollment import Enrollment
from app.modules.student.models.assignment import Assignment, AssignmentSubmission
from app.modules.student.routers.study_time_router import StudyTimeLog


def get_dashboard_data(db: Session):

    student = db.query(User).filter(User.role == "student").first()
    student_profile = None
    enrollment = None

    if student:
        student_profile = db.query(Student).filter(Student.user_id == student.id).first()
        if student_profile:
            enrollment = (
                db.query(Enrollment)
                .filter(Enrollment.student_id == student_profile.id)
                .order_by(Enrollment.created_at.desc())
                .first()
            )

    attendance_status = "Present"
    if student_profile:
        today_attendance = (
            db.query(Attendance)
            .filter(
                Attendance.student_id == student_profile.id,
                Attendance.attendance_date == date.today(),
            )
            .first()
        )

        if today_attendance is None:
            db.add(
                Attendance(
                    student_id=student_profile.id,
                    attendance_date=date.today(),
                    status="Present",
                )
            )
            db.commit()
        else:
            attendance_status = today_attendance.status or "Present"

    # Study hours for today
    today_hours = 0.0
    if student:
        today_log = (
            db.query(StudyTimeLog)
            .filter(
                StudyTimeLog.student_id == student.id,
                StudyTimeLog.log_date == date.today(),
            )
            .first()
        )
        if today_log:
            today_hours = float(today_log.hours or 0.0)

    # Assignments and progress
    total_assignments = db.query(Assignment).filter(Assignment.status == "Open").count()
    done_assignments = 0
    if student:
        done_assignments = db.query(AssignmentSubmission).filter(
            AssignmentSubmission.student_id == student.id
        ).count()

    progress = 0
    if enrollment is not None:
        progress = int(enrollment.progress or 0)

    if total_assignments > 0:
        assignment_progress = int((done_assignments / total_assignments) * 100)
        progress = max(progress, min(assignment_progress, 100))

    if progress < 0:
        progress = 0
    if progress > 100:
        progress = 100

    assignment_list = []
    open_assignments = db.query(Assignment).filter(Assignment.status == "Open").order_by(Assignment.due_date).all()
    for assignment in open_assignments:
        assignment_list.append({
            "title": assignment.title,
            "due": assignment.due_date or "Pending",
        })

    continue_course = "Keep Learning"
    if progress >= 100:
        continue_course = "All done! Great work"
    elif done_assignments > 0:
        continue_course = "Finish your next task"

    return {
        "student_name": student.name if student else "Student",
        "weekly_streak": student.streak if student else 0,
        "xp": student.total_xp if student else 0,
        "courses": 4,
        "continue_course": continue_course,
        "course_progress": progress,
        "course_progress_text": f"{progress}% Completed",
        "study_hours": f"{today_hours:.1f}",
        "assignments_done": f"{done_assignments}/{total_assignments}",
        "attendance": attendance_status,
        "assignments": assignment_list,
        "notifications": [
            {"title": "No pending assignment data"}
        ]
    }
