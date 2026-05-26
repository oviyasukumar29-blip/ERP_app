from datetime import datetime
from uuid import uuid4

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Role(Base):
    __tablename__ = "pinesphere_roles"

    id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str] = mapped_column(String(120), unique=True, index=True)
    description: Mapped[str] = mapped_column(Text, default="")
    users: Mapped[list["User"]] = relationship(back_populates="role")
    modules: Mapped[list["Module"]] = relationship(back_populates="role", cascade="all, delete-orphan")


class User(Base):
    __tablename__ = "pinesphere_users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid4()))
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    full_name: Mapped[str] = mapped_column(String(160))
    hashed_password: Mapped[str] = mapped_column(String(255))
    role_id: Mapped[str] = mapped_column(ForeignKey("pinesphere_roles.id"))
    branch_id: Mapped[str] = mapped_column(String(36), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    role: Mapped[Role] = relationship(back_populates="users")


class Module(Base):
    __tablename__ = "pinesphere_modules"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid4()))
    role_id: Mapped[str] = mapped_column(
        ForeignKey("pinesphere_roles.id"), index=True
    )
    title: Mapped[str] = mapped_column(String(160), index=True)
    phase: Mapped[int] = mapped_column(Integer, default=1)
    features: Mapped[str] = mapped_column(Text, default="")
    role: Mapped[Role] = relationship(back_populates="modules")


class ErpRecord(Base):
    __tablename__ = "pinesphere_erp_records"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid4()))
    module: Mapped[str] = mapped_column(String(160), index=True)
    feature: Mapped[str] = mapped_column(String(160), index=True)
    title: Mapped[str] = mapped_column(String(255))
    status: Mapped[str] = mapped_column(String(40), default="Active")
    notes: Mapped[str] = mapped_column(Text, default="")
    owner_role: Mapped[str] = mapped_column(String(64), index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
