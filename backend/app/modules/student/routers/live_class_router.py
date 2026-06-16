import uuid
from datetime import datetime
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.modules.student.models.live_class import LiveClass

router = APIRouter(prefix="/student", tags=["Student Live Classes"])


class LiveClassOut(BaseModel):
    id: str
    title: str
    teacher_name: str
    meeting_link: Optional[str]
    start_time: Optional[str]
    end_time: Optional[str]
    is_live: bool


class LiveClassSchedule(BaseModel):
    start_time: datetime
    end_time: datetime




class LiveClassCreate(BaseModel):
    title: str
    teacher_name: Optional[str] = "Trainer"

@router.post("/live-classes/create", response_model=LiveClassOut)
def create_live_class(payload: LiveClassCreate, db: Session = Depends(get_db)):
    live_class = LiveClass(
        id=uuid.uuid4(),
        course_id=uuid.UUID('47287d49-8a3e-4066-83ab-42ad116792a3'),
        title=payload.title,
        teacher_name=payload.teacher_name or "Trainer",
        is_live=False,
        meeting_link=None,
        created_at=datetime.utcnow(),
    )
    db.add(live_class)
    db.commit()
    db.refresh(live_class)

    return LiveClassOut(
        id=str(live_class.id),
        title=live_class.title,
        teacher_name=live_class.teacher_name,
        meeting_link=live_class.meeting_link,
        start_time=live_class.start_time.isoformat() if live_class.start_time else None,
        end_time=live_class.end_time.isoformat() if live_class.end_time else None,
        is_live=live_class.is_live,
    )
@router.get("/live-classes", response_model=List[LiveClassOut])
def get_live_classes(db: Session = Depends(get_db)):
    classes = (
        db.query(LiveClass)
        .order_by(LiveClass.start_time.asc())
        .all()
    )
    return [
        LiveClassOut(
            id=str(lc.id),
            title=lc.title,
            teacher_name=lc.teacher_name,
            meeting_link=lc.meeting_link,
            start_time=lc.start_time.isoformat() if lc.start_time else None,
            end_time=lc.end_time.isoformat() if lc.end_time else None,
            is_live=lc.is_live,
        )
        for lc in classes
    ]


@router.post("/live-classes/{class_id}/host", response_model=LiveClassOut)
def host_live_class(class_id: str, db: Session = Depends(get_db)):
    try:
        class_uuid = uuid.UUID(class_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid class_id")

    live_class = db.query(LiveClass).filter(LiveClass.id == class_uuid).first()
    if not live_class:
        raise HTTPException(status_code=404, detail="Live class not found")

    live_class.is_live = True
    live_class.meeting_link = live_class.meeting_link or \
        f"https://studio.pinesphere.live/{class_uuid.hex[:8]}"
    db.commit()
    db.refresh(live_class)

    return LiveClassOut(
        id=str(live_class.id),
        title=live_class.title,
        teacher_name=live_class.teacher_name,
        meeting_link=live_class.meeting_link,
        start_time=live_class.start_time.isoformat() if live_class.start_time else None,
        end_time=live_class.end_time.isoformat() if live_class.end_time else None,
        is_live=live_class.is_live,
    )


@router.post("/live-classes/{class_id}/schedule", response_model=LiveClassOut)
def schedule_live_class(class_id: str, payload: LiveClassSchedule, db: Session = Depends(get_db)):
    try:
        class_uuid = uuid.UUID(class_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid class_id")

    live_class = db.query(LiveClass).filter(LiveClass.id == class_uuid).first()
    if not live_class:
        raise HTTPException(status_code=404, detail="Live class not found")

    live_class.start_time = payload.start_time
    live_class.end_time = payload.end_time
    db.commit()
    db.refresh(live_class)

    return LiveClassOut(
        id=str(live_class.id),
        title=live_class.title,
        teacher_name=live_class.teacher_name,
        meeting_link=live_class.meeting_link,
        start_time=live_class.start_time.isoformat() if live_class.start_time else None,
        end_time=live_class.end_time.isoformat() if live_class.end_time else None,
        is_live=live_class.is_live,
    )