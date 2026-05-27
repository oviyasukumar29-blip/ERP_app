from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.schemas.schemas import SignupSchema
from app.models.models import User
from app.core.database import get_db
from app.core.security import hash_password

router = APIRouter()


@router.post("/signup")
def signup(data: SignupSchema, db: Session = Depends(get_db)):

    hashed_password = hash_password(data.password)

    user = User(
        name=data.name,
        email=data.email,
        password_hash=hashed_password
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return {
        "message": "User created successfully"
    }