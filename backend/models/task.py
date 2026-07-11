"""Task Models"""

from pydantic import BaseModel, Field
from typing import Optional
from enum import Enum


class TaskStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"


class TaskCreate(BaseModel):
    user_id: str = Field(..., min_length=1, max_length=100)
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = Field(None, max_length=1000)
    category: Optional[str] = Field(None, max_length=50)
    pillar: Optional[str] = Field(None, pattern="^(academic|research|leadership|creativity|community|evidence|consistency)$")
    difficulty: int = Field(default=1, ge=1, le=5)
    xp_reward: int = Field(default=10, ge=0, le=10000)
    due_date: Optional[str] = None


class Task(BaseModel):
    id: str
    user_id: str
    title: str
    description: Optional[str] = None
    category: Optional[str] = None
    pillar: Optional[str] = None
    difficulty: int = 1
    xp_reward: int = 10
    status: str = "pending"
    due_date: Optional[str] = None
    created_at: Optional[str] = None
    completed_at: Optional[str] = None