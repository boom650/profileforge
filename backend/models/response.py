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
