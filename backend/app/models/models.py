from sqlalchemy import Column, String, Integer, Text
from sqlalchemy.dialects.postgresql import UUID
import uuid

from app.db.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    name = Column(String(100), nullable=False)

    email = Column(String(150), unique=True, nullable=False)

    password_hash = Column(Text, nullable=False)

    total_xp = Column(Integer, default=0)

    level = Column(Integer, default=1)

    streak = Column(Integer, default=0)