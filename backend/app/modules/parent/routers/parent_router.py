# backend/app/modules/parent/routers/parent_router.py
# ─────────────────────────────────────────────────────────────
# All parent-facing endpoints, rewritten to match real schema:
#
#   enrollments          (id, student_id, course_id, progress, status)
#   attendance           (id, student_id, attendance_date, status)
#   assignments          (id, course_id, title, subject, due_date, ...)
#   assignment_submissions (id, assignment_id, student_id, status, grade, marks)
#   quiz_submissions     (id, quiz_id, student_id, score, submitted_at)
#   quizzes              (id, course_id, ...)
#   courses              (id, title, description, duration)
#   students             (id, user_id, student_code, branch_id, course_id)
#   parent_student_links (parent_user_id, student_user_id)
#
# No fee_invoices, course_progress, batches, branches — removed.
#
# NOTE: assignments.due_date is stored as VARCHAR (not TIMESTAMP) in this
# schema, so every comparison/order against NOW() casts it explicitly with
# ::timestamp. If you later migrate the column to a real TIMESTAMP type,
# these casts become harmless no-ops and can be left in place safely.
# ─────────────────────────────────────────────────────────────

import logging
from typing import Optional
from datetime import datetime

from fastapi import APIRouter, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.core.database import get_db
from app.shared.models.user import User

router = APIRouter(prefix="/parent", tags=["parent"])
logger = logging.getLogger("parent")


# ─── helpers ──────────────────────────────────────────────────

def _get_parent_or_404(parent_id: str, db: Session) -> User:
    user = db.query(User).filter(
        User.id == parent_id,
        User.role == "parent",
    ).first()
    if not user:
        raise HTTPException(status_code=404, detail="Parent not found")
    return user


def _get_linked_student_or_403(parent_id: str, student_id: str, db: Session):
    row = db.execute(text("""
        SELECT student_user_id
        FROM parent_student_links
        WHERE parent_user_id = :parent_id
          AND student_user_id = :student_id
    """), {"parent_id": parent_id, "student_id": student_id}).fetchone()

    if not row:
        raise HTTPException(
            status_code=403,
            detail="This student is not linked to your account",
        )
    student = db.query(User).filter(User.id == student_id).first()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")
    return student


# ─── GET /parent/children ─────────────────────────────────────

@router.get("/children")
def get_children(parent_id: str = Query(...), db: Session = Depends(get_db)):
    _get_parent_or_404(parent_id, db)

    rows = db.execute(text("""
        SELECT
            u.id,
            u.name,
            u.username,
            c.title                                         AS course,
            s.student_code,
            COALESCE(att.percent, 0)                        AS attendance_percent,
            COALESCE(enroll.progress, 0)                    AS progress_percent,
            COALESCE(u.total_xp, 0)                         AS xp
        FROM parent_student_links psl
        JOIN users u ON u.id = psl.student_user_id
        LEFT JOIN students s ON s.user_id = u.id
        LEFT JOIN LATERAL (
            SELECT
                AVG(progress)::int AS progress,
                (SELECT course_id FROM enrollments
                 WHERE student_id = u.id
                 ORDER BY created_at DESC LIMIT 1) AS course_id
            FROM enrollments
            WHERE student_id = u.id
        ) enroll ON TRUE
        LEFT JOIN courses c ON c.id = enroll.course_id
        LEFT JOIN LATERAL (
            SELECT
                COUNT(*) FILTER (WHERE status = 'present') * 100
                / NULLIF(COUNT(*), 0) AS percent
            FROM attendance
            WHERE student_id = u.id
              AND DATE_TRUNC('month', attendance_date) = DATE_TRUNC('month', NOW())
        ) att ON TRUE
        WHERE psl.parent_user_id = :parent_id
        ORDER BY u.name
    """), {"parent_id": parent_id}).fetchall()

    return [
        {
            "id":                str(row.id),
            "name":              row.name or row.username,
            "course":            row.course or "Not enrolled",
            "batch":             row.student_code or "",
            "branch":            "",
            "attendancePercent": row.attendance_percent or 0,
            "feeStatus":         "pending",
            "progressPercent":   row.progress_percent or 0,
            "xp":                row.xp or 0,
        }
        for row in rows
    ]


# ─── GET /parent/children/{student_id}/summary ────────────────

@router.get("/children/{student_id}/summary")
def get_dashboard_summary(
    student_id: str,
    parent_id: str = Query(...),
    db: Session = Depends(get_db),
):
    student = _get_linked_student_or_403(parent_id, student_id, db)

    # Attendance this month
    att = db.execute(text("""
        SELECT
            COUNT(*) FILTER (WHERE status = 'present') AS present,
            COUNT(*) FILTER (WHERE status = 'absent')  AS absent,
            COUNT(*)                                    AS total
        FROM attendance
        WHERE student_id = :sid
          AND DATE_TRUNC('month', attendance_date) = DATE_TRUNC('month', NOW())
    """), {"sid": student_id}).fetchone()

    att_total   = att.total or 1
    att_percent = round((att.present or 0) * 100 / att_total)

   # All enrolled courses + progress — aggregate instead of picking one
    course_rows = db.execute(text("""
        SELECT c.title, COALESCE(e.progress, 0)::int AS progress
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        WHERE e.student_id = :sid
        ORDER BY e.created_at DESC
    """), {"sid": student_id}).fetchall()

    course_count = len(course_rows)

    if course_count == 0:
        course_title    = "Not enrolled"
        course_progress = 0
        best_title      = "Not enrolled"
        best_progress   = 0
    else:
        course_progress = round(sum(r.progress for r in course_rows) / course_count)
        course_title    = f"{course_count} Course{'s' if course_count != 1 else ''}"
        best_row        = max(course_rows, key=lambda r: r.progress)
        best_title      = best_row.title
        best_progress   = best_row.progress

    # Homework counts (last 30 days)
    hw = db.execute(text("""
        SELECT
            COUNT(*) FILTER (
                WHERE COALESCE(asub.status, 'pending') = 'pending'
                  AND a.due_date::timestamp >= NOW()
            ) AS pending,
            COUNT(*) FILTER (WHERE asub.status = 'submitted') AS submitted,
            COUNT(*) FILTER (
                WHERE COALESCE(asub.status, 'missed') != 'submitted'
                  AND a.due_date::timestamp < NOW()
            ) AS missed
        FROM assignments a
        JOIN enrollments e ON e.course_id = a.course_id AND e.student_id = :sid
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = :sid
        WHERE a.due_date::timestamp >= NOW() - INTERVAL '30 days'
    """), {"sid": student_id}).fetchone()

    # Skill scores from quiz submissions per course
    skill_rows = db.execute(text("""
        SELECT
            c.title          AS skill,
            AVG(qs.score)::int AS score
        FROM quiz_submissions qs
        JOIN quizzes q ON q.id  = qs.quiz_id
        JOIN courses c ON c.id  = q.course_id
        WHERE qs.student_id = :sid
        GROUP BY c.title
        ORDER BY score DESC
        LIMIT 5
    """), {"sid": student_id}).fetchall()

    skill_scores = {row.skill: row.score for row in skill_rows} if skill_rows else {}

    name = student.name or student.username
    return {
        "child_id":               student_id,
        "course_progress":        course_progress,
        "course_progress_text":   f"{course_progress}% Completed",
        "continue_course":        course_title,
        "attendance_percent":     att_percent,
        "fee_status":             "pending",
        "fee_due_amount":         0,
        "pending_homework_count": hw.pending or 0,
        "unread_messages":        0,
        "ai_summary": (
            f"{name} is enrolled in {course_title} with an average completion of "
            f"{course_progress}%. Strongest progress is in {best_title} at "
            f"{best_progress}%. Attendance this month is {att_percent}%. "
            f"{hw.pending or 0} assignment(s) pending."
        ),
        "skill_scores": skill_scores,
    }


# ─── GET /parent/children/{student_id}/attendance ─────────────

@router.get("/children/{student_id}/attendance")
def get_attendance(
    student_id: str,
    parent_id: str = Query(...),
    year:  Optional[int] = Query(None),
    month: Optional[int] = Query(None),
    db: Session = Depends(get_db),
):
    _get_linked_student_or_403(parent_id, student_id, db)

    now = datetime.now()
    y = year  or now.year
    m = month or now.month

    records = db.execute(text("""
        SELECT attendance_date AS date, status
        FROM attendance
        WHERE student_id = :sid
          AND EXTRACT(YEAR  FROM attendance_date) = :year
          AND EXTRACT(MONTH FROM attendance_date) = :month
        ORDER BY attendance_date
    """), {"sid": student_id, "year": y, "month": m}).fetchall()

    record_list = [
        {"date": row.date.isoformat(), "status": row.status}
        for row in records
    ]
    total   = len(record_list) or 1
    present = sum(1 for r in record_list if r["status"] == "present")
    absent  = sum(1 for r in record_list if r["status"] == "absent")
    leave   = sum(1 for r in record_list if r["status"] == "leave")

    return {
        "records": record_list,
        "summary": {
            "present": present,
            "absent":  absent,
            "leave":   leave,
            "total":   total,
            "percent": round(present * 100 / total),
        },
    }


# ─── GET /parent/children/{student_id}/fees ───────────────────

@router.get("/children/{student_id}/fees")
def get_fees(
    student_id: str,
    parent_id: str = Query(...),
    db: Session = Depends(get_db),
):
    """No fee table yet — returns empty placeholder."""
    _get_linked_student_or_403(parent_id, student_id, db)

    return {
        "invoices": [],
        "summary": {
            "total_due":     0,
            "total_paid":    0,
            "next_due_date": None,
            "status":        "paid",
        },
    }


# ─── GET /parent/children/{student_id}/homework ───────────────

@router.get("/children/{student_id}/homework")
def get_homework(
    student_id: str,
    parent_id: str = Query(...),
    db: Session = Depends(get_db),
):
    _get_linked_student_or_403(parent_id, student_id, db)

    rows = db.execute(text("""
        SELECT
            a.id,
            a.title,
            COALESCE(a.subject, c.title, 'General') AS subject,
            a.due_date,
            COALESCE(
                asub.status,
                CASE WHEN a.due_date::timestamp < NOW() THEN 'missed' ELSE 'pending' END
            ) AS submission_status
        FROM assignments a
        JOIN enrollments e ON e.course_id = a.course_id AND e.student_id = :sid
        JOIN courses c ON c.id = a.course_id
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = :sid
        WHERE a.due_date::timestamp >= NOW() - INTERVAL '30 days'
        ORDER BY a.due_date::timestamp ASC
    """), {"sid": student_id}).fetchall()

    items = [
        {
            "id":      str(row.id),
            "title":   row.title,
            "subject": row.subject,
            "dueDate": row.due_date,  # already a string (e.g. "2026-06-24")
            "status":  row.submission_status,
        }
        for row in rows
    ]

    return {
        "items": items,
        "summary": {
            "pending":   sum(1 for i in items if i["status"] == "pending"),
            "submitted": sum(1 for i in items if i["status"] == "submitted"),
            "missed":    sum(1 for i in items if i["status"] == "missed"),
        },
    }


# ─── GET /parent/{parent_id}/children/{student_id}/progress ───

@router.get("/{parent_id}/children/{student_id}/progress")
def get_progress(
    parent_id: str,
    student_id: str,
    db: Session = Depends(get_db),
):
    """
    Per-course progress. Flutter ProgressService.getCourseProgress() calls this.
    Uses: enrollments + courses + assignments + assignment_submissions
          + quizzes + quiz_submissions
    """
    _get_linked_student_or_403(parent_id, student_id, db)

    rows = db.execute(text("""
        SELECT
            c.id                                             AS course_id,
            c.title                                          AS course_title,
            COALESCE(e.progress, 0)::int                     AS progress,
            COALESCE(e.status, 'in_progress')                AS status,
            COUNT(DISTINCT a.id)                             AS total_assignments,
            COUNT(DISTINCT asub.assignment_id)
                FILTER (WHERE asub.status = 'submitted')     AS submitted_assignments,
            COUNT(DISTINCT q.id)                             AS total_quizzes,
            COUNT(DISTINCT qs.quiz_id)                       AS submitted_quizzes
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        LEFT JOIN assignments a ON a.course_id = c.id
        LEFT JOIN assignment_submissions asub
               ON asub.assignment_id = a.id AND asub.student_id = :sid
        LEFT JOIN quizzes q ON q.course_id = c.id
        LEFT JOIN quiz_submissions qs
               ON qs.quiz_id = q.id AND qs.student_id = :sid
        WHERE e.student_id = :sid
        GROUP BY c.id, c.title, e.progress, e.status, e.created_at
        ORDER BY e.created_at DESC
    """), {"sid": student_id}).fetchall()

    return [
        {
            "course_id":             str(row.course_id),
            "course_title":          row.course_title,
            "progress":              row.progress,
            "status":                row.status,
            "total_assignments":     row.total_assignments     or 0,
            "submitted_assignments": row.submitted_assignments or 0,
            "total_quizzes":         row.total_quizzes         or 0,
            "submitted_quizzes":     row.submitted_quizzes     or 0,
        }
        for row in rows
    ]