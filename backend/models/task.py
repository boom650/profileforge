"""
Task Models
"""

from pydantic import BaseModel
from typing import Optional
from enum import Enum


class TaskStatus(str, Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"


class TaskCreate(BaseModel):
    user_id: str
    title: str
    description: Optional[str] = None
    category: Optional[str] = None
    pillar: Optional[str] = None
    difficulty: int = 1
    xp_reward: int = 10
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
