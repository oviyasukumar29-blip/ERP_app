from datetime import date

from sqlalchemy.orm import Session

from app.shared.models.user import User
from app.modules.student.models.attendance import Attendance
from app.modules.student.models.student import Student


def get_dashboard_data(db: Session):

    student = db.query(User).first()
    student_profile = None

    if student:
        student_profile = db.query(Student).filter(Student.user_id == student.id).first()

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

    assignment_list = []

    return {

        "student_name": student.name if student else "Student",

        "weekly_streak": student.streak if student else 0,

        "xp": student.total_xp if student else 0,

        "courses": 4,

        "continue_course": "Start Learning",

        "course_progress": 0,

        "course_progress_text": "0% Completed",

        "study_hours": "0",

        "assignments_done": "0/0",

        "attendance": attendance_status,

        "assignments": assignment_list,

        "notifications": [
            {
                "title": "No pending assignment data"
            }
        ]
    }
