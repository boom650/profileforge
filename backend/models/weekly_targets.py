"""
Weekly Targets & Research Paper Milestone Models
"""

from pydantic import BaseModel
from typing import Optional, List
from enum import Enum


class MilestoneStatus(str, Enum):
    NOT_STARTED = "not_started"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    SKIPPED = "skipped"


class MilestoneType(str, Enum):
    RESEARCH_PAPER = "research_paper"
    COMPETITION = "competition"
    COURSE_CERT = "course_cert"
    ESSAY_DRAFT = "essay_draft"
    VOLUNTEER_HOURS = "volunteer_hours"
    PROJECT_DELIVERABLE = "project_deliverable"
    STANDARD = "standard"


class ResearchPaperMilestone(BaseModel):
    """A single milestone in the research paper pipeline"""
    id: Optional[str] = None
    user_id: str
    paper_title: str
    step_name: str  # "topic_selection", "literature_review", "draft_v1", etc.
    step_order: int
    description: Optional[str] = None
    status: MilestoneStatus = MilestoneStatus.NOT_STARTED
    due_date: Optional[str] = None
    completed_at: Optional[str] = None
    notes: Optional[str] = None
    xp_reward: int = 10
    target_id: Optional[str] = None  # Links to a WeeklyTarget


class WeeklyTarget(BaseModel):
    """A weekly target with optional milestones"""
    id: Optional[str] = None
    user_id: str
    title: str
    description: Optional[str] = None
    category: Optional[str] = None  # "research", "academics", "extracurricular"
    milestone_type: MilestoneType = MilestoneType.STANDARD
    pillar: Optional[str] = None
    xp_reward: int = 25
    status: MilestoneStatus = MilestoneStatus.NOT_STARTED
    week_number: Optional[int] = None  # ISO week number
    year: Optional[int] = None
    due_date: Optional[str] = None
    completed_at: Optional[str] = None
    progress_pct: int = 0  # 0-100
    milestones: Optional[List[ResearchPaperMilestone]] = None


class WeeklyTargetsResponse(BaseModel):
    """Response containing all targets for a given week"""
    user_id: str
    week_number: int
    year: int
    targets: List[WeeklyTarget]
    total_xp_available: int
    completed_count: int
    total_count: int
    overall_progress_pct: int


class CreateWeeklyTargetRequest(BaseModel):
    """Request to create a new weekly target"""
    user_id: str
    title: str
    description: Optional[str] = None
    category: Optional[str] = None
    milestone_type: MilestoneType = MilestoneType.STANDARD
    pillar: Optional[str] = None
    xp_reward: int = 25
    due_date: Optional[str] = None
    # If research paper, auto-generate milestones
    generate_research_milestones: bool = False
    paper_title: Optional[str] = None


class UpdateMilestoneRequest(BaseModel):
    """Request to update a milestone's status"""
    status: MilestoneStatus
    notes: Optional[str] = None
