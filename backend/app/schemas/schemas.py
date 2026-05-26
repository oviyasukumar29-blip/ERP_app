from datetime import datetime

from pydantic import BaseModel


class LoginRequest(BaseModel):
    email: str
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
    full_name: str


class ModuleRead(BaseModel):
    id: str
    title: str
    phase: int
    features: list[str]


class RoleRead(BaseModel):
    id: str
    name: str
    description: str
    modules: list[ModuleRead]


class ErpRecordCreate(BaseModel):
    module: str
    feature: str
    title: str
    status: str = "Active"
    notes: str = ""
    owner_role: str


class ErpRecordRead(ErpRecordCreate):
    id: str
    created_at: datetime

    class Config:
        from_attributes = True
