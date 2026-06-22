# backend/app/modules/parent/routers/parent_router.py
# ─────────────────────────────────────────────────────────────
# Parent-specific endpoints.
# Mount this in main.py:
#   from app.modules.parent.routers.parent_router import router as parent_router
#   app.include_router(parent_router)
# ─────────────────────────────────────────────────────────────

import logging
from typing import List, Optional

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.core.database import get_db

router = APIRouter(prefix="/parent", tags=["parent"])
logger = logging.getLogger("parent")


# ── Response Models ───────────────────────────────────────────

class ChildResponse(BaseModel):
    id: str
    name: str
    username: str
    course: str
    batch: str
    branch: str
    attendance_percent: int
    fee_status: str
    progress_percent: int
    xp: int


class CourseProgressResponse(BaseModel):
    course_id: str
    course_title: str
    progress: int
    status: str
    total_assignments: int
    submitted_assignments: int
    total_quizzes: int
    submitted_quizzes: int


# ── GET /parent/{parent_id}/children ─────────────────────────

@router.get("/{parent_id}/children", response_model=List[ChildResponse])
def get_children(parent_id: str, db: Session = Depends(get_db)):
    """
    Returns all students linked to the given parent.
    progress_percent = average of enrollments.progress across all
    enrolled courses for that student.
    course = title of the first enrolled course.
    """
    logger.info("get_children: parent_id=%s", parent_id)

    rows = db.execute(text("""
        SELECT
            u.id                            AS student_id,
            u.name                          AS student_name,
            u.username                      AS student_username,
            COALESCE(AVG(e.progress), 0)    AS avg_progress,
            MAX(c.title)                    AS course_title
        FROM parent_student_links psl
        JOIN users u ON u.id = psl.student_user_id
        LEFT JOIN enrollments e ON e.student_id = u.id
        LEFT JOIN courses c ON c.id = e.course_id
        WHERE psl.parent_user_id = :parent_id
        GROUP BY u.id, u.name, u.username
        ORDER BY u.name
    """), {"parent_id": parent_id}).fetchall()

    if not rows:
        return []

    children = []
    for row in rows:
        children.append(ChildResponse(
            id=str(row.student_id),
            name=row.student_name or row.student_username,
            username=row.student_username,
            course=row.course_title or "",
            batch="",
            branch="",
            attendance_percent=0,
            fee_status="pending",
            progress_percent=int(row.avg_progress),
            xp=0,
        ))

    logger.info("get_children: found %d children", len(children))
    return children


# ── GET /parent/{parent_id}/children/{child_id}/progress ─────

@router.get("/{parent_id}/children/{child_id}/progress", response_model=List[CourseProgressResponse])
def get_child_progress(parent_id: str, child_id: str, db: Session = Depends(get_db)):
    """
    Returns per-course progress for a specific child.
    Shows each enrolled course with assignment + quiz completion counts.
    Progress is calculated from actual submissions if enrollment.progress = 0.
    """
    logger.info("get_child_progress: parent_id=%s child_id=%s", parent_id, child_id)

    # Verify parent-child link
    link = db.execute(text("""
        SELECT 1 FROM parent_student_links
        WHERE parent_user_id = :parent_id AND student_user_id = :child_id
    """), {"parent_id": parent_id, "child_id": child_id}).fetchone()

    if not link:
        raise HTTPException(status_code=403, detail="Not authorized to view this child")

    rows = db.execute(text("""
        SELECT
            e.course_id,
            c.title                         AS course_title,
            e.progress,
            e.status,
            COUNT(DISTINCT a.id)            AS total_assignments,
            COUNT(DISTINCT asub.id)         AS submitted_assignments,
            COUNT(DISTINCT q.id)            AS total_quizzes,
            COUNT(DISTINCT qs.id)           AS submitted_quizzes
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        LEFT JOIN assignments a ON a.course_id = e.course_id
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = e.student_id
        LEFT JOIN quizzes q ON q.course_id = e.course_id
        LEFT JOIN quiz_submissions qs
               ON qs.quiz_id = q.id AND qs.student_id = e.student_id
        WHERE e.student_id = :child_id
        GROUP BY e.course_id, c.title, e.progress, e.status
        ORDER BY c.title
    """), {"child_id": child_id}).fetchall()

    results = []
    for row in rows:
        total = (row.total_assignments or 0) + (row.total_quizzes or 0)
        submitted = (row.submitted_assignments or 0) + (row.submitted_quizzes or 0)

        # Use submission ratio if enrollment progress is 0
        calculated_progress = (
            int((submitted / total) * 100) if total > 0 else int(row.progress or 0)
        )

        results.append(CourseProgressResponse(
            course_id=str(row.course_id),
            course_title=row.course_title,
            progress=calculated_progress,
            status=row.status or "active",
            total_assignments=row.total_assignments or 0,
            submitted_assignments=row.submitted_assignments or 0,
            total_quizzes=row.total_quizzes or 0,
            submitted_quizzes=row.submitted_quizzes or 0,
        ))

    return results