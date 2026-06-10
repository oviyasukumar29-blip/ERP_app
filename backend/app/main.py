from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import Base
from app.core.database import SessionLocal
from app.core.database import engine
from app.core.seed import seed_demo_data

from app.shared.models.user import User

from app.modules.student.models.student import Student
from app.modules.student.models.course import Course
from app.modules.student.models.enrollment import Enrollment
from app.modules.student.models.attendance import Attendance

from app.modules.student.routers.dashboard_router import router as dashboard_router
from app.modules.student.routers.course_router import router as course_router
from app.modules.admin.routers.dashboard_router import router as admin_dashboard_router
from app.modules.trainer.routers.dashboard_router import router as trainer_dashboard_router
from app.modules.parent.routers.dashboard_router import router as parent_dashboard_router
from app.modules.auth.routers.auth_router import router as auth_router





Base.metadata.create_all(bind=engine)

db = SessionLocal()
try:
    seed_demo_data(db)
finally:
    db.close()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)

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
