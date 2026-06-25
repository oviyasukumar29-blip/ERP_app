# app/modules/student/routers/attendance_router.py
# ─────────────────────────────────────────────────────────────
# Trainer marks attendance, student views their own.
#
# Endpoints:
#   POST /trainer/attendance/mark          → mark one student
#   POST /trainer/attendance/mark-bulk     → mark multiple students at once
#   GET  /trainer/attendance/{course_id}   → view all attendance for a course
#   GET  /student/attendance/{student_id}  → student views own attendance
#   GET  /student/attendance/{student_id}/summary → summary % for student
# ─────────────────────────────────────────────────────────────

import uuid
from datetime import date, datetime
from typing import List, Optional

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.core.database import get_db

router = APIRouter(tags=["attendance"])


# ── Schemas ───────────────────────────────────────────────────

class MarkAttendanceRequest(BaseModel):
    student_id: str
    attendance_date: str          # "YYYY-MM-DD"
    status: str                   # "present" | "absent" | "leave"


class BulkAttendanceEntry(BaseModel):
    student_id: str
    status: str                   # "present" | "absent" | "leave"


class BulkMarkAttendanceRequest(BaseModel):
    course_id: str
    attendance_date: str          # "YYYY-MM-DD"
    entries: List[BulkAttendanceEntry]


class AttendanceRecordOut(BaseModel):
    id: str
    student_id: str
    attendance_date: str
    status: str
    created_at: str


class AttendanceSummaryOut(BaseModel):
    present: int
    absent: int
    leave: int
    total: int
    percent: int


# ── Trainer: Mark single student attendance ───────────────────

@router.post("/trainer/attendance/mark")
def mark_attendance(
    payload: MarkAttendanceRequest,
    db: Session = Depends(get_db),
):
    """
    Mark or update attendance for a single student on a given date.
    If a record already exists for that student+date, it is updated.
    """
    try:
        sid  = uuid.UUID(payload.student_id)
        adate = date.fromisoformat(payload.attendance_date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id or date format")

    valid_statuses = {"present", "absent", "leave"}
    if payload.status.lower() not in valid_statuses:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid status. Must be one of: {valid_statuses}",
        )

    # Upsert — update if exists, insert if not
    db.execute(text("""
        INSERT INTO attendance (id, student_id, attendance_date, status, created_at)
        VALUES (gen_random_uuid(), :sid, :adate, :status, NOW())
        ON CONFLICT (student_id, attendance_date)
        DO UPDATE SET status = EXCLUDED.status
    """), {"sid": sid, "adate": adate, "status": payload.status.lower()})

    db.commit()

    return {
        "message":         "Attendance marked successfully",
        "student_id":      str(sid),
        "attendance_date": str(adate),
        "status":          payload.status.lower(),
    }


# ── Trainer: Bulk mark attendance for a class ─────────────────

@router.post("/trainer/attendance/mark-bulk")
def mark_attendance_bulk(
    payload: BulkMarkAttendanceRequest,
    db: Session = Depends(get_db),
):
    """
    Mark attendance for multiple students at once (whole class in one call).
    Useful for the trainer's class attendance screen.
    """
    try:
        adate = date.fromisoformat(payload.attendance_date)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD")

    valid_statuses = {"present", "absent", "leave"}
    marked = 0

    for entry in payload.entries:
        try:
            sid = uuid.UUID(entry.student_id)
        except ValueError:
            continue  # skip invalid UUIDs silently

        if entry.status.lower() not in valid_statuses:
            continue

        db.execute(text("""
            INSERT INTO attendance (id, student_id, attendance_date, status, created_at)
            VALUES (gen_random_uuid(), :sid, :adate, :status, NOW())
            ON CONFLICT (student_id, attendance_date)
            DO UPDATE SET status = EXCLUDED.status
        """), {"sid": sid, "adate": adate, "status": entry.status.lower()})
        marked += 1

    db.commit()

    return {
        "message": f"Attendance marked for {marked} students",
        "date":    str(adate),
        "count":   marked,
    }


# ── Trainer: View attendance for a course on a date ──────────

@router.get("/trainer/attendance/{course_id}")
def get_course_attendance(
    course_id: str,
    attendance_date: Optional[str] = None,
    db: Session = Depends(get_db),
):
    """
    Returns attendance records for all students enrolled in a course.
    Optionally filter by date (defaults to today).
    """
    try:
        cid   = uuid.UUID(course_id)
        adate = date.fromisoformat(attendance_date) if attendance_date else date.today()
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid course_id or date")

    rows = db.execute(text("""
        SELECT
            u.id           AS student_id,
            u.name         AS student_name,
            u.username,
            COALESCE(a.status, 'not_marked') AS status,
            a.attendance_date
        FROM enrollments e
        JOIN students s ON s.id = e.student_id
        JOIN users u    ON u.id = s.user_id
        LEFT JOIN attendance a
               ON a.student_id = u.id
              AND a.attendance_date = :adate
        WHERE e.course_id = :cid
        ORDER BY u.name
    """), {"cid": cid, "adate": adate}).fetchall()

    return {
        "course_id":       str(cid),
        "attendance_date": str(adate),
        "records": [
            {
                "student_id":   str(row.student_id),
                "student_name": row.student_name or row.username,
                "status":       row.status,
            }
            for row in rows
        ],
    }


# ── Student: View own attendance (monthly) ────────────────────

@router.get("/student/attendance/{student_id}")
def get_student_attendance(
    student_id: str,
    year:  Optional[int] = None,
    month: Optional[int] = None,
    db: Session = Depends(get_db),
):
    """
    Returns all attendance records for the student in a given month.
    Defaults to current month if year/month not provided.
    """
    try:
        sid = uuid.UUID(student_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id")

    now = datetime.now()
    y   = year  or now.year
    m   = month or now.month

    rows = db.execute(text("""
        SELECT attendance_date, status
        FROM attendance
        WHERE student_id = :sid
          AND EXTRACT(YEAR  FROM attendance_date) = :year
          AND EXTRACT(MONTH FROM attendance_date) = :month
        ORDER BY attendance_date
    """), {"sid": sid, "year": y, "month": m}).fetchall()

    records = [
        {"date": row.attendance_date.isoformat(), "status": row.status}
        for row in rows
    ]

    total   = len(records) or 1
    present = sum(1 for r in records if r["status"] == "present")
    absent  = sum(1 for r in records if r["status"] == "absent")
    leave   = sum(1 for r in records if r["status"] == "leave")

    return {
        "records": records,
        "summary": {
            "present": present,
            "absent":  absent,
            "leave":   leave,
            "total":   total,
            "percent": round(present * 100 / total),
        },
    }


# ── Student: Attendance summary (quick rollup) ────────────────

@router.get("/student/attendance/{student_id}/summary")
def get_student_attendance_summary(
    student_id: str,
    db: Session = Depends(get_db),
):
    """
    Returns overall attendance % across all recorded months.
    Used by student dashboard attendance card.
    """
    try:
        sid = uuid.UUID(student_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid student_id")

    row = db.execute(text("""
        SELECT
            COUNT(*) FILTER (WHERE status = 'present') AS present,
            COUNT(*) FILTER (WHERE status = 'absent')  AS absent,
            COUNT(*) FILTER (WHERE status = 'leave')   AS leave,
            COUNT(*)                                    AS total
        FROM attendance
        WHERE student_id = :sid
    """), {"sid": sid}).fetchone()

    total   = row.total or 1
    present = row.present or 0

    return {
        "present": present,
        "absent":  row.absent  or 0,
        "leave":   row.leave   or 0,
        "total":   row.total   or 0,
        "percent": round(present * 100 / total),
    }