"""Response Models for ProfileForge API"""
from pydantic import BaseModel
from typing import List, Optional, Any


class ErrorResponse(BaseModel):
    """Standard error response format"""
    detail: str
    code: Optional[str] = None
    context: Optional[dict] = None


class PaginatedResponse(BaseModel):
    """Generic paginated response"""
    items: List[Any]
    total: int
    page: int
    page_size: int
    has_more: bool


class SuccessResponse(BaseModel):
    """Standard success response for operations without body"""
    status: str = "success"
    message: Optional[str] = None


class LocationResponse(BaseModel):
    """Location update response"""
    status: str = "success"
    location: Any


class CityResponse(BaseModel):
    """City update response"""
    status: str = "success"
    city: str


class TaskCompleteResponse(BaseModel):
    """Task completion response"""
    status: str = "completed"
    xp_awarded: Any


class TargetStatusResponse(BaseModel):
    """Weekly target status update response"""
    status: str = "success"
    target: Any


class SkinUnlockResponse(BaseModel):
    """Skin unlock response"""
    status: str = "success"
    skin: Any