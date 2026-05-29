from sqlalchemy.orm import Session

from app.shared.models.user import User
from app.modules.student.models.assignment import Assignment


def get_dashboard_data(db: Session):

    student = db.query(User).first()

    assignments = db.query(Assignment).all()

    assignment_list = []

    for assignment in assignments:
        assignment_list.append({
            "title": assignment.title,
            "due": "Today"
        })

    return {

        "student_name": student.name,

        "weekly_streak": student.streak,

        "courses": 4,

        "study_hours": "12.5h",

        "assignments_done": "8/11",

        "attendance": "92%",

        "assignments": assignment_list,

        "notifications": [
            {
                "title": "Assignment due today"
            }
        ]
    }