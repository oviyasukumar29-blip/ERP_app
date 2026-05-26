from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import create_access_token, verify_password
from app.models import ErpRecord, Role, User
from app.schemas import ErpRecordCreate, ErpRecordRead, LoginRequest, RoleRead, TokenResponse

router = APIRouter()


@router.post("/auth/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)) -> TokenResponse:
    user = db.query(User).filter(User.email == payload.email).first()
    if user is None or not verify_password(payload.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    return TokenResponse(
        access_token=create_access_token(user.email, user.role_id),
        role=user.role_id,
        full_name=user.full_name,
    )


@router.get("/roles", response_model=list[RoleRead])
def list_roles(db: Session = Depends(get_db)) -> list[dict]:
    roles = db.query(Role).order_by(Role.name).all()
    return [
        {
            "id": role.id,
            "name": role.name,
            "description": role.description,
            "modules": [
                {
                    "id": module.id,
                    "title": module.title,
                    "phase": module.phase,
                    "features": [item for item in module.features.split("|") if item],
                }
                for module in role.modules
            ],
        }
        for role in roles
    ]


@router.post("/records", response_model=ErpRecordRead)
def create_record(payload: ErpRecordCreate, db: Session = Depends(get_db)) -> ErpRecord:
    record = ErpRecord(**payload.model_dump())
    db.add(record)
    db.commit()
    db.refresh(record)
    return record


@router.get("/records", response_model=list[ErpRecordRead])
def list_records(
    owner_role: str | None = None,
    module: str | None = None,
    feature: str | None = None,
    db: Session = Depends(get_db),
) -> list[ErpRecord]:
    query = db.query(ErpRecord).order_by(ErpRecord.created_at.desc())
    if owner_role:
        query = query.filter(ErpRecord.owner_role == owner_role)
    if module:
        query = query.filter(ErpRecord.module == module)
    if feature:
        query = query.filter(ErpRecord.feature == feature)
    return query.limit(200).all()
