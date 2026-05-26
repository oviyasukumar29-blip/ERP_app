from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Pinesphere ERP"
    database_url: str = "postgresql+psycopg://postgres:postgres@localhost:5432/ai_erp"
    secret_key: str = "change-this-before-production"
    access_token_expire_minutes: int = 1440

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")


settings = Settings()
