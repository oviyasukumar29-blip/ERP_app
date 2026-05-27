from fastapi import FastAPI

from app.db.database import engine
from app.models.models import Base

app = FastAPI()

Base.metadata.create_all(bind=engine)


@app.get("/")
def root():
    return {"message": "Pinesphere Backend Running"}