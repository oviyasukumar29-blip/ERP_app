# Pinesphere ERP FastAPI Backend

FastAPI backend scaffold for the Pinesphere AI Training Institute ERP.

## Database

Create/use PostgreSQL database:

```text
database: ai_erp
user: postgres
password: postgres
host: localhost
port: 5432
```

The app reads `DATABASE_URL`; if it is missing, it uses:

```text
postgresql+psycopg://postgres:postgres@localhost:5432/ai_erp
```

## Run

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Open `http://127.0.0.1:8000/docs`.

## Flutter API URL

For Chrome/web on the same PC:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

For Android emulator:

```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

For a physical phone, replace the URL with your computer LAN IP, for example:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
```
