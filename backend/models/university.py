"""
University Database & Matcher Models
Real data for US/UK/Canada/Australia/EU universities
"""

from pydantic import BaseModel
from typing import Optional, List


class University(BaseModel):
    id: str
    name: str
    country: str
    city: str
    acceptance_rate: float  # 0.0 - 1.0
    ranking_us_news: Optional[int] = None
    ranking_qs: Optional[int] = None
    tuition_usd: Optional[int] = None
    has_need_based_aid: bool = False
    has_merit_scholarships: bool = False
    strengths: List[str] = []
    typical_gpa: Optional[float] = None
    typical_sat: Optional[int] = None
    website: str = ""
    deadline_early: Optional[str] = None
    deadline_regular: Optional[str] = None


class UniversityMatch(BaseModel):
    university: University
    fit_score: float  # 0-100
    classification: str  # "safety", "target", "reach", "dream"
    reasons: List[str] = []


class UniversityMatchRequest(BaseModel):
    user_id: str
    interests: Optional[str] = None
    country_preference: Optional[str] = None
    budget_max_usd: Optional[int] = None
    gpa: Optional[float] = None
    sat_score: Optional[int] = None
