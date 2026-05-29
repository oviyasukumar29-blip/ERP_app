from pydantic import BaseModel
from typing import List


class AssignmentItem(BaseModel):
    title: str
    due: str


class NotificationItem(BaseModel):
    title: str


class DashboardResponse(BaseModel):

    student_name: str

    weekly_streak: int

    courses: int

    study_hours: str

    assignments_done: str

    attendance: str

    assignments: List[AssignmentItem]

    notifications: List[NotificationItem]