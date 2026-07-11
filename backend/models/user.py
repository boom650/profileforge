"""User Models"""
from pydantic import BaseModel, Field, EmailStr
from typing import Optional, List

class UserLocation(BaseModel):
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)

class UserGoals(BaseModel):
    career_aspirations: Optional[List[str]] = Field(default_factory=list)
    target_universities: Optional[List[str]] = Field(default_factory=list)
    skill_development: Optional[List[str]] = Field(default_factory=list)

class UserCreate(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=100)
    password: str = Field(..., min_length=8, max_length=128)
    grade: int = Field(..., ge=1, le=12)
    board: str = Field(..., min_length=2, max_length=50)
    stream: str = Field(..., min_length=2, max_length=50)

class User(BaseModel):
    user_id: str
    email: EmailStr
    name: str
    grade: int
    board: str
    stream: str
    location: Optional[UserLocation] = None
    goals: Optional[UserGoals] = None
    created_at: Optional[str] = None
    last_login: Optional[str] = None

class UserUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    grade: Optional[int] = Field(None, ge=1, le=12)
    board: Optional[str] = Field(None, min_length=2, max_length=50)
    stream: Optional[str] = Field(None, min_length=2, max_length=50)
    location: Optional[UserLocation] = None
    goals: Optional[UserGoals] = None