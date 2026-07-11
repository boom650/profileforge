"""Course Models"""

from pydantic import BaseModel, Field
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
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = Field(None, max_length=2000)
    provider: Optional[str] = Field(None, max_length=100)
    url: Optional[str] = Field(None, pattern=r"^https?://.*")
    category: Optional[str] = Field(None, max_length=50)
    pillar: Optional[str] = Field(default="academics", pattern="^(academics|research|leadership|creativity|community|evidence|consistency)$")
    difficulty: int = Field(default=1, ge=1, le=5)
    xp_reward: int = Field(default=50, ge=0, le=10000)
    estimated_hours: Optional[float] = Field(None, ge=0, le=1000)
    certificate_required: bool = True
    created_at: Optional[str] = None


class CourseCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=200)
    description: Optional[str] = Field(None, max_length=2000)
    provider: Optional[str] = Field(None, max_length=100)
    url: Optional[str] = Field(None, pattern=r"^https?://.*")
    category: Optional[str] = Field(None, max_length=50)
    pillar: Optional[str] = Field(default="academics", pattern="^(academics|research|leadership|creativity|community|evidence|consistency)$")
    difficulty: int = Field(default=1, ge=1, le=5)
    xp_reward: int = Field(default=50, ge=0, le=10000)
    estimated_hours: Optional[float] = Field(None, ge=0, le=1000)
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
    certificate_url: str = Field(..., pattern=r"^https?://.*")