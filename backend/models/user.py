"""
User Models
"""

from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class UserCreate(BaseModel):
    name: str
    email: Optional[str] = None
    grade: Optional[int] = None
    board: Optional[str] = None
    stream: Optional[str] = None


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
    city: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
