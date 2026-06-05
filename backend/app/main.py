from fastapi import FastAPI

from app.core.database import Base
from app.core.database import engine

from app.shared.models.user import User

from app.modules.student.models.student import Student
from app.modules.student.models.course import Course
from app.modules.student.models.enrollment import Enrollment
from app.modules.student.models.assignment import Assignment
from app.modules.student.models.assignment_submission import AssignmentSubmission
from app.modules.student.models.attendance import Attendance

from app.modules.student.routers.dashboard_router import router as dashboard_router
from app.modules.student.routers.assignment_router import router as assignment_router
from app.modules.student.routers.course_router import router as course_router
from app.modules.admin.routers.dashboard_router import router as admin_dashboard_router
from app.modules.trainer.routers.dashboard_router import router as trainer_dashboard_router
from app.modules.parent.routers.dashboard_router import router as parent_dashboard_router





Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(assignment_router)

app.include_router(dashboard_router)

app.include_router(course_router)

app.include_router(admin_dashboard_router)

app.include_router(trainer_dashboard_router)

app.include_router(parent_dashboard_router)


@app.get("/")
def root():
    return {
        "message": "ERP Backend Running"
    }
