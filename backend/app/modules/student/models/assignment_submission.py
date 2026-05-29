import uuid

from sqlalchemy import Column, Text, Integer, TIMESTAMP, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func

from app.core.database import Base


class AssignmentSubmission(Base):

    __tablename__ = "assignment_submissions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    assignment_id = Column(
        UUID(as_uuid=True),
        ForeignKey("assignments.id")
    )

    student_id = Column(
        UUID(as_uuid=True),
        ForeignKey("students.id")
    )

    submission_text = Column(Text)

    file_url = Column(Text)

    submitted_at = Column(
        TIMESTAMP,
        server_default=func.now()
    )

    marks = Column(Integer)

    feedback = Column(Text)