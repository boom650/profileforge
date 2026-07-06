"""
Course Models
"""

from pydantic import BaseModel
from typing import Optional
from enum import Enum


class CourseStatus(str, Enum):
    AVAILABLE = "available"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"


class CertificateStatus(str, Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"


class Course(BaseModel):
    id: str
    title: str
    description: Optional[str] = None
    provider: Optional[str] = None
    url: Optional[str] = None
    category: Optional[str] = None
    pillar: Optional[str] = "academics"
    difficulty: int = 1
    xp_reward: int = 50
    estimated_hours: Optional[float] = None
    certificate_required: bool = True
    created_at: Optional[str] = None


class CourseCreate(BaseModel):
    title: str
    description: Optional[str] = None
    provider: Optional[str] = None
    url: Optional[str] = None
    category: Optional[str] = None
    pillar: Optional[str] = "academics"
    difficulty: int = 1
    xp_reward: int = 50
    estimated_hours: Optional[float] = None
    certificate_required: bool = True


class CourseEnrollment(BaseModel):
    id: str
    user_id: str
    course_id: str
    status: str = "enrolled"
    certificate_url: Optional[str] = None
    certificate_status: Optional[str] = "pending"
    enrolled_at: Optional[str] = None
    completed_at: Optional[str] = None


class CertificateSubmit(BaseModel):
    certificate_url: str
