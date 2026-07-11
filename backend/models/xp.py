"""XP / Gamification Models"""

from pydantic import BaseModel, Field
from typing import Optional


class XPTransaction(BaseModel):
    amount: int = Field(..., ge=0, le=100000)
    source: str = Field(..., min_length=1, max_length=100)
    pillar: str = Field(..., pattern="^(academic|research|leadership|creativity|community|evidence|consistency)$")


class XPResult(BaseModel):
    total_xp: int
    level: int
    pillar_xp: int
    leveled_up: bool
    new_level: Optional[int] = None
    skin_unlocked: Optional[str] = None


class XPState(BaseModel):
    total_xp: int = 0
    level: int = 1
    academics_xp: int = 0
    research_xp: int = 0
    leadership_xp: int = 0
    creativity_xp: int = 0
    community_xp: int = 0
    evidence_xp: int = 0
    consistency_xp: int = 0
    streak_days: int = 0
    last_active: Optional[str] = None