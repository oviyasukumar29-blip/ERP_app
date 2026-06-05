from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.modules.student.services.course_service import get_student_courses

router = APIRouter(
    prefix="/student",
    tags=["Student Courses"],
)


@router.get("/courses")
def student_courses(db: Session = Depends(get_db)):
    return get_student_courses(db)
