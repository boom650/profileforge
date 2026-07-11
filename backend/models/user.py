"""
User Models
"""

from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


class UserCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: Optional[EmailStr] = None
    grade: Optional[int] = Field(None, ge=1, le=12)
    board: Optional[str] = Field(None, max_length=50)
    stream: Optional[str] = Field(None, max_length=50)
    password: str = Field(..., min_length=8, max_length=128)


class UserLogin(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=1, max_length=128)


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: Optional[str] = None


class User(BaseModel):
    id: str
    name: str
    email: Optional[str] = None
    grade: Optional[int] = None
    board: Optional[str] = None
    stream: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    created_at: Optional[str] = None
    updated_at: Optional[str] = None


class UserLocation(BaseModel):
    latitude: float
    longitude: float
    city: Optional[str] = Field(None, max_length=100)
    state: Optional[str] = Field(None, max_length=100)
    country: Optional[str] = Field(None, max_length=100)
