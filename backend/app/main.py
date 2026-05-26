from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import router
from app.core.database import Base, SessionLocal, engine
from app.seed import seed_database

app = FastAPI(title="Pinesphere ERP API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed_database(db)
    finally:
        db.close()


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


app.include_router(router, prefix="/api")
