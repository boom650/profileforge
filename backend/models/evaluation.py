"""
Evaluation Models
"""

from pydantic import BaseModel
from typing import Optional


class EvaluationRequest(BaseModel):
    user_id: str
    task_id: str
    file_content: Optional[bytes] = None
    text_content: Optional[str] = None
    file_type: str = "unknown"
    filename: str = "unknown"


class EvaluationResult(BaseModel):
    status: str  # "approved" or "rejected"
    feedback: str
    score: Optional[float] = None
    improvements: Optional[list] = None
    file_type: Optional[str] = None
    filename: Optional[str] = None
