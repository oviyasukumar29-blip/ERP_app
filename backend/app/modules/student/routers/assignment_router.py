from fastapi import APIRouter

router = APIRouter(prefix="/student")

@router.post("/submit-assignment/{assignment_id}")
def submit_assignment(assignment_id: int):

    return {
        "success": True,
        "message": f"Assignment {assignment_id} submitted"
    }