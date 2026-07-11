"""
ProfileForge Backend Server
FastAPI-based backend for the Flutter app
Handles: Users, Location, Tasks, Document Evaluation, XP/Gamification, Chat, Weekly Targets
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, UploadFile, File, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import os
from dotenv import load_dotenv
load_dotenv()

# Import environment-aware config
try:
    from config import API_BASE_URL, BRIDGE_URL, DATABASE_URL, SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES
except ImportError:
    # Fallback for local execution
    API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8080")
    BRIDGE_URL = os.getenv("BRIDGE_URL", "http://127.0.0.1:8090")
import uvicorn
import os
import json
import uuid
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel
import sqlite3
import logging
import sys

# Configure structured logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(name)s %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("profileforge")

# Import response models
from models.response import (
    ErrorResponse, PaginatedResponse, SuccessResponse,
    LocationResponse, CityResponse, TaskCompleteResponse,
    TargetStatusResponse, SkinUnlockResponse
)

# Local imports
from models.user import User, UserCreate, UserLocation
from models.task import Task, TaskCreate, TaskStatus
from models.evaluation import EvaluationRequest, EvaluationResult
from models.xp import XPTransaction, XPResult
from models.course import CourseCreate, CertificateSubmit
from models.chat import ChatRequest, ChatResponse
from models.weekly_targets import (
    CreateWeeklyTargetRequest, UpdateMilestoneRequest,
    MilestoneStatus, WeeklyTarget,
)
from services.database import Database
from services.evaluation import EvaluationService
from services.tasks import TaskService
from services.xp import XPService
from services.location import LocationService
from services.courses import CourseService
from services.ai_evaluation import AIEvaluationService
from services.gemini_client import get_gemini
from services.chat import chat_service

# Auth dependency stub - replace with real JWT validation
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

security = HTTPBearer(auto_error=False)

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Extract and validate user from JWT token. Stub for now - returns user_id from token."""
    if credentials is None:
        raise HTTPException(status_code=401, detail="Not authenticated")
    # TODO: Validate JWT token and extract user_id
    # For now, assume token is user_id
    return credentials.credentials
from services.weekly_targets import WeeklyTargetsService
from services.university import university_service
from models.university import UniversityMatchRequest
from services.notification_service import notification_service
from services.essay_service import essay_service
from services.scholarship_service import scholarship_service

# Initialize FastAPI app
# ═══════════════════════════════════════════════════════════════════════════
# LIFESPAN (replaces deprecated on_event)
# ═══════════════════════════════════════════════════════════════════════════

@asynccontextmanager
async def lifespan(app):
    """Startup and shutdown lifecycle."""
    await db.initialize()
    await weekly_targets_service.ensure_tables()
    print("✅ ProfileForge API started with Chat + Weekly Targets")
    yield
    await db.close()
    await chat_service.close()
    print("🛑 ProfileForge API stopped")


app = FastAPI(
    title="ProfileForge API",
    description="Backend for ProfileForge - AI CV Builder",
    version="2.0.0",
    lifespan=lifespan,
    # API Versioning
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

# API Version prefix - APPLY to all routes
API_PREFIX = "/api/v1"

# CORS middleware - allow Flutter app
# Restrict to app origin in production
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS", "http://localhost:8080,http://127.0.0.1:8080,capacitor://localhost,http://localhost")
_origins = [o.strip() for o in ALLOWED_ORIGINS.split(",")]
app.add_middleware(
    CORSMiddleware,
    allow_origins=_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
db = Database()
evaluation_service = EvaluationService()
task_service = TaskService(db)
xp_service = XPService(db)
location_service = LocationService(db)
course_service = CourseService(db)
ai_eval = AIEvaluationService()
weekly_targets_service = WeeklyTargetsService(db)


# ═══════════════════════════════════════════════════════════════════════════
# HEALTH CHECK
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}


# ═══════════════════════════════════════════════════════════════════════════
# USER ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/users", response_model=User, status_code=201)
async def create_user(user: UserCreate):
    """Create a new user profile"""
    try:
        return await db.create_user(user)
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=409, detail="User with this email already exists")


@app.get(f"{API_PREFIX}/users/{{user_id}}", response_model=User)
async def get_user(user_id: str):
    """Get user by ID"""
    user = await db.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.put(f"{API_PREFIX}/users/{{user_id}}", response_model=User)
async def update_user(user_id: str, user: User):
    """Update user profile"""
    updated = await db.update_user(user_id, user)
    if not updated:
        raise HTTPException(status_code=404, detail="User not found")
    return updated


# ═══════════════════════════════════════════════════════════════════════════
# LOCATION ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/users/{{user_id}}/location")
async def update_location(user_id: str, location: UserLocation):
    """Update user's GPS coordinates"""
    result = await location_service.update_location(user_id, location)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return {"status": "success", "location": location}


@app.get(f"{API_PREFIX}/users/{{user_id}}/location")
async def get_location(user_id: str):
    """Get user's stored location"""
    location = await location_service.get_location(user_id)
    if not location:
        raise HTTPException(status_code=404, detail="Location not set")
    return location


@app.post(f"{API_PREFIX}/users/{{user_id}}/city")
async def update_city(user_id: str, city: str):
    """Update user's city (manual entry fallback)"""
    result = await location_service.update_city(user_id, city)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return {"status": "success", "city": city}


# ═══════════════════════════════════════════════════════════════════════════
# TASK ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/tasks", response_model=Task, status_code=201)
async def create_task(task: TaskCreate):
    """Create a new task (used by Hermes agent)"""
    return await task_service.create_task(task)


@app.get(f"{API_PREFIX}/tasks/{{user_id}}", response_model=List[Task])
async def get_user_tasks(user_id: str, status: Optional[str] = None):
    """Get all tasks for a user, optionally filtered by status"""
    return await task_service.get_user_tasks(user_id, status)


@app.get(f"{API_PREFIX}/tasks/{{user_id}}/pending", response_model=List[Task])
async def get_pending_tasks(user_id: str):
    """Get pending tasks for a user"""
    return await task_service.get_user_tasks(user_id, "pending")


class TaskStatusUpdate(BaseModel):
    status: TaskStatus

@app.put(f"{API_PREFIX}/tasks/{{task_id}}/status")
async def update_task_status(task_id: str, body: TaskStatusUpdate):
    """Update task status"""
    result = await task_service.update_status(task_id, body.status)
    if not result:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"status": "success"}


@app.post(f"{API_PREFIX}/tasks/{{task_id}}/complete")
async def complete_task(task_id: str):
    """Mark task as completed and award XP"""
    task = await task_service.get_task(task_id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    # Award XP
    xp_result = await xp_service.award_xp(
        user_id=task.user_id,
        amount=task.xp_reward,
        source=f"task:{task_id}",
        pillar=task.pillar or "general"
    )
    
    # Update task status
    await task_service.update_status(task_id, TaskStatus.COMPLETED)
    
    return {"status": "completed", "xp_awarded": xp_result}


# ═══════════════════════════════════════════════════════════════════════════
# DOCUMENT EVALUATION ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/evaluate")
async def evaluate_document(
    user_id: str,
    task_id: str,
    file: UploadFile = File(...)
):
    """
    Evaluate uploaded document against task criteria.
    Uses Hermes vision model for analysis.
    """
    # Read file content
    content = await file.read()
    
    # Create evaluation request
    request = EvaluationRequest(
        user_id=user_id,
        task_id=task_id,
        file_content=content,
        file_type=file.content_type or "unknown",
        filename=file.filename or "unknown"
    )
    
    # Run evaluation
    result = await evaluation_service.evaluate(request)
    
    # If approved, award XP
    if result.status == "approved":
        task = await task_service.get_task(task_id)
        if task:
            await xp_service.award_xp(
                user_id=user_id,
                amount=task.xp_reward,
                source=f"evaluation:{task_id}",
                pillar=task.pillar or "general"
            )
            await task_service.update_status(task_id, TaskStatus.COMPLETED)
    
    return result


@app.post(f"{API_PREFIX}/evaluate/text")
async def evaluate_text(body: dict):
    """Evaluate text content against task criteria."""
    user_id = body.get("user_id", "")
    task_id = body.get("task_id", "")
    text = body.get("content", "")
    request = EvaluationRequest(
        user_id=user_id,
        task_id=task_id,
        text_content=text,
        file_type="text/plain",
        filename="text_input"
    )
    
    result = await evaluation_service.evaluate(request)
    
    if result.status == "approved":
        task = await task_service.get_task(task_id)
        if task:
            await xp_service.award_xp(
                user_id=user_id,
                amount=task.xp_reward,
                source=f"evaluation:{task_id}",
                pillar=task.pillar or "general"
            )
            await task_service.update_status(task_id, TaskStatus.COMPLETED)
    
    return result


# ═══════════════════════════════════════════════════════════════════════════
# XP / GAMIFICATION ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/xp/{{user_id}}")
async def get_xp(user_id: str):
    """Get user's XP state"""
    return await xp_service.get_xp_state(user_id)


import httpx as _httpx

# BRIDGE_URL loaded from config (environment-aware)

@app.post(f"{API_PREFIX}/ai/evaluate")
async def ai_evaluate_via_bridge(body: dict):
    """Submit text for AI evaluation via Hermes bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.post(f"{BRIDGE_URL}/evaluate", json=body)
        return resp.json()


@app.get(f"{API_PREFIX}/ai/results/{{job_id}}")
async def ai_get_result(job_id: str):
    """Get AI evaluation result from bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.get(f"{BRIDGE_URL}/results/{job_id}")
        return resp.json()


@app.post(f"{API_PREFIX}/ai/tasks/generate")
async def ai_generate_tasks_via_bridge(body: dict):
    """Request AI task generation via Hermes bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.post(f"{BRIDGE_URL}/tasks/generate", json=body)
        return resp.json()


@app.get(f"{API_PREFIX}/ai/task-results/{{job_id}}")
async def ai_get_task_results(job_id: str):
    """Get AI task generation results from bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.get(f"{BRIDGE_URL}/task-results/{job_id}")
        return resp.json()


@app.post(f"{API_PREFIX}/xp/{{user_id}}/award")
async def award_xp(user_id: str, transaction: XPTransaction):
    """Award XP to user"""
    result = await xp_service.award_xp(
        user_id=user_id,
        amount=transaction.amount,
        source=transaction.source,
        pillar=transaction.pillar
    )
    return result


@app.get(f"{API_PREFIX}/xp/{{user_id}}/history")
async def get_xp_history(user_id: str, limit: int = 50):
    """Get XP transaction history"""
    return await xp_service.get_history(user_id, limit)


@app.get(f"{API_PREFIX}/skins/{{user_id}}")
async def get_skins(user_id: str):
    """Get user's skin collection"""
    return await xp_service.get_skins(user_id)


@app.post(f"{API_PREFIX}/skins/{{user_id}}/unlock")
async def unlock_skin(user_id: str, skin_id: str):
    """Unlock a skin for user"""
    return await xp_service.unlock_skin(user_id, skin_id)


@app.post(f"{API_PREFIX}/streak/{{user_id}}/update")
async def update_streak(user_id: str):
    """Update user's streak (call daily)"""
    return await xp_service.update_streak(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# FREE COURSES ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/courses")
async def list_courses(
    category: Optional[str] = None,
    pillar: Optional[str] = None,
    difficulty: Optional[int] = None
):
    """List all available free courses with optional filters"""
    return await course_service.get_all_courses(category, pillar, difficulty)


@app.get(f"{API_PREFIX}/courses/{{course_id}}")
async def get_course(course_id: str):
    """Get course details by ID"""
    course = await course_service.get_course(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return course


@app.get(f"{API_PREFIX}/courses/search/{{query}}")
async def search_courses(query: str):
    """Search courses by title, description, or provider"""
    return await course_service.search_courses(query)


@app.post(f"{API_PREFIX}/courses/{{course_id}}")
async def create_course(course_id: str, course: CourseCreate):
    """Create a new course (admin/hermes endpoint)"""
    return await course_service.create_course(course)


@app.post(f"{API_PREFIX}/courses/{{user_id}}/enroll/{{course_id}}")
async def enroll_in_course(user_id: str, course_id: str):
    """Enroll user in a free course"""
    course = await course_service.get_course(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    enrollment = await course_service.enroll_user(user_id, course_id)
    return enrollment


@app.get(f"{API_PREFIX}/courses/{{user_id}}/enrolled")
async def get_user_enrollments(user_id: str, status: Optional[str] = None):
    """Get all courses a user is enrolled in"""
    return await course_service.get_user_enrollments(user_id, status)


@app.post(f"{API_PREFIX}/courses/{{user_id}}/submit-certificate/{{course_id}}")
async def submit_certificate(user_id: str, course_id: str, body: CertificateSubmit):
    """Submit certificate URL for a completed course"""
    enrollment = await course_service.get_enrollment(user_id, course_id)
    if not enrollment:
        raise HTTPException(status_code=404, detail="Not enrolled in this course")
    
    result = await course_service.submit_certificate(
        user_id, course_id, body.certificate_url
    )
    return result


@app.post(f"{API_PREFIX}/courses/{{user_id}}/complete/{{course_id}}")
async def complete_course(user_id: str, course_id: str):
    """Mark course as completed (after certificate approval)"""
    course = await course_service.get_course(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    enrollment = await course_service.get_enrollment(user_id, course_id)
    if not enrollment:
        raise HTTPException(status_code=404, detail="Not enrolled in this course")
    
    result = await course_service.complete_enrollment(user_id, course_id)
    
    xp_result = await xp_service.award_xp(
        user_id=user_id,
        amount=course.xp_reward,
        source=f"course:{course_id}",
        pillar=course.pillar or "academics"
    )
    
    return {
        "status": "completed",
        "enrollment": result,
        "xp_awarded": xp_result
    }


@app.get(f"{API_PREFIX}/courses/{{user_id}}/stats")
async def get_course_stats(user_id: str):
    """Get course completion stats for a user"""
    return await course_service.get_user_stats(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# CHAT ENDPOINTS — Connect to Hermes via bridge
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Send a message to the Hermes AI coach via the bridge server.
    
    The message is forwarded to the bridge (localhost:8090), which processes it
    and returns a coaching response. Conversation history is maintained per session.
    
    Context options:
    - "essay_review": Essay writing and Common App guidance
    - "task_help": Help completing a specific ProfileForge task
    - "research_guidance": Research paper methodology and planning
    - "competition_prep": Olympiad/competition preparation
    - "general": General college admissions advice
    """
    try:
        response = await chat_service.send_message(request)
        return response
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail=f"Chat service unavailable: {str(e)}. The Hermes agent may be offline."
        )


@app.get(f"{API_PREFIX}/chat/{{conversation_id}}/history")
async def get_chat_history(conversation_id: str):
    """Get the full conversation history for a chat session."""
    history = await chat_service.get_conversation_history(conversation_id)
    if not history:
        raise HTTPException(status_code=404, detail="Conversation not found")
    return history


@app.get(f"{API_PREFIX}/chat/conversations/{{user_id}}")
async def list_user_conversations(user_id: str):
    """List all chat conversations for a user."""
    return await chat_service.list_conversations(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# WEEKLY TARGETS & RESEARCH MILESTONES
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/weekly-targets", response_model=WeeklyTarget)
async def create_weekly_target(request: CreateWeeklyTargetRequest):
    """
    Create a new weekly target.
    
    Set `generate_research_milestones=True` and provide a `paper_title`
    to auto-generate the 8-step research paper pipeline:
      1. Topic Selection → 2. Literature Review → 3. Methodology →
      4. Data Collection → 5. Draft v1 → 6. Peer Review →
      7. Revision → 8. Submission
    """
    return await weekly_targets_service.create_target(request)


@app.get(f"{API_PREFIX}/weekly-targets/{{user_id}}")
async def get_weekly_targets(
    user_id: str,
    week: Optional[int] = None,
    year: Optional[int] = None,
):
    """Get all targets for a user in a given week (defaults to current week)."""
    return await weekly_targets_service.get_weekly_targets(user_id, week, year)


@app.put(f"{API_PREFIX}/weekly-targets/{{target_id}}/status")
async def update_target_status(target_id: str, status: MilestoneStatus):
    """Update a weekly target's status (not_started → in_progress → completed)."""
    target = await weekly_targets_service.update_target_status(target_id, status)
    if not target:
        raise HTTPException(status_code=404, detail="Target not found")
    return target


@app.delete(f"{API_PREFIX}/weekly-targets/{{target_id}}")
async def delete_target(target_id: str):
    """Delete a weekly target and its associated milestones."""
    deleted = await weekly_targets_service.delete_target(target_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Target not found")
    return {"status": "deleted"}


@app.get(f"{API_PREFIX}/research-milestones/{{user_id}}")
async def get_research_milestones(user_id: str):
    """Get all research paper milestones for a user."""
    return await weekly_targets_service.get_all_milestones(user_id)


@app.put(f"{API_PREFIX}/research-milestones/{{milestone_id}}")
async def update_milestone(milestone_id: str, req: UpdateMilestoneRequest):
    """
    Update a research milestone's status.
    
    When a milestone is completed, the parent target's progress is
    automatically recalculated. Complete all 8 milestones to finish
    the research paper pipeline (100% progress).
    """
    milestone = await weekly_targets_service.update_milestone(milestone_id, req)
    if not milestone:
        raise HTTPException(status_code=404, detail="Milestone not found")
    return milestone


# ═══════════════════════════════════════════════════════════════════════════
# HERMES INTEGRATION ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/hermes/tasks/push")
async def hermes_push_tasks(tasks: List[TaskCreate]):
    """
    Endpoint for Hermes agent to push generated tasks.
    Called by Hermes cron job.
    """
    created_tasks = []
    for task in tasks:
        created = await task_service.create_task(task)
        created_tasks.append(created)
    
    return {"status": "success", "tasks_created": len(created_tasks)}


@app.get(f"{API_PREFIX}/hermes/tasks/{{user_id}}/pending")
async def hermes_get_pending(user_id: str):
    """
    Endpoint for Hermes to check pending tasks.
    Used for autonomous task generation.
    """
    return await task_service.get_user_tasks(user_id, "pending")


@app.post(f"{API_PREFIX}/hermes/evaluate")
async def hermes_evaluate(request: EvaluationRequest):
    """
    Endpoint for Hermes to evaluate documents.
    Called when user uploads a document.
    """
    return await evaluation_service.evaluate(request)


# ═══════════════════════════════════════════════════════════════════════════
# OPPORTUNITY ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/opportunities/search")
async def search_opportunities(city: str):
    """Search opportunities by city"""
    return await location_service.search_by_city(city)


@app.get(f"{API_PREFIX}/opportunities/{{user_id}}")
async def get_opportunities(user_id: str):
    """Get opportunities for user based on location"""
    return await location_service.get_nearby_opportunities(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# UNIVERSITY MATCHER
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/universities")
async def list_universities(country: Optional[str] = None, max_tuition: Optional[int] = None):
    """List all universities, optionally filtered by country or budget"""
    return university_service.search(country=country, max_tuition=max_tuition)


@app.get(f"{API_PREFIX}/universities/{{uni_id}}")
async def get_university(uni_id: str):
    """Get details for a specific university"""
    uni = university_service.get_by_id(uni_id)
    if not uni:
        raise HTTPException(status_code=404, detail="University not found")
    return uni


@app.post(f"{API_PREFIX}/universities/match")
async def match_universities(request: UniversityMatchRequest):
    """Find best-fit universities based on student profile"""
    interests = request.interests.split(",") if request.interests else None
    return university_service.match(
        gpa=request.gpa,
        sat=request.sat_score,
        country=request.country_preference,
        budget=request.budget_max_usd,
        interests=interests,
    )


# ═══════════════════════════════════════════════════════════════════════════
# NOTIFICATIONS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/notifications/{{user_id}}/daily")
async def get_daily_reminder(user_id: str):
    """Get a context-aware daily reminder for the user"""
    context = {
        "tasks_remaining": 3,
        "probability": 65,
        "top_task": "Complete your weekly target",
        "streak": 5,
    }
    return notification_service.get_daily_reminder(user_id, context)


@app.get(f"{API_PREFIX}/notifications/{{user_id}}/weekly")
async def get_weekly_report(user_id: str):
    """Get weekly summary report"""
    stats = {
        "week_number": 1,
        "targets_completed": 2,
        "targets_total": 5,
        "xp_earned": 50,
        "xp_available": 200,
        "probability": 65,
        "probability_change": 3,
        "streak": 5,
        "level": 3,
        "xp_total": 350,
        "next_week_tasks": [
            "Complete 3 weekly targets",
            "Work on research paper methodology",
            "Write 300 words of Common App essay",
        ],
    }
    return notification_service.get_weekly_report(user_id, stats)


@app.post(f"{API_PREFIX}/notifications/{{user_id}}/competition-alert")
async def get_competition_alert(user_id: str, competition: str = "KVPY",
                                 days_left: int = 14):
    """Get competition registration alert"""
    return notification_service.get_competition_alert(user_id, competition, days_left)


@app.get(f"{API_PREFIX}/notifications/{{user_id}}/streak")
async def get_streak_reminder(user_id: str, streak: int = 5):
    """Get streak-based reminder"""
    return notification_service.get_streak_reminder(user_id, streak)


# ═══════════════════════════════════════════════════════════════════════════
# SCHOLARSHIPS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/scholarships")
async def list_scholarships(country: Optional[str] = None):
    """List all scholarships, optionally filtered by country"""
    return scholarship_service.get_all(country=country)


@app.get(f"{API_PREFIX}/search-scholarships/{{query}}")
async def search_scholarships(query: str):
    """Search scholarships by name, country, or description"""
    return scholarship_service.search(query)


@app.get(f"{API_PREFIX}/indian-scholarships")
async def get_indian_scholarships():
    """Get scholarships relevant to Indian students"""
    return scholarship_service.get_for_indian_student()


@app.get(f"{API_PREFIX}/scholarships/{{scholarship_id}}")
async def get_scholarship(scholarship_id: str):
    """Get a specific scholarship"""
    s = scholarship_service.get_by_id(scholarship_id)
    if not s:
        raise HTTPException(status_code=404, detail="Scholarship not found")
    return s


# ═══════════════════════════════════════════════════════════════════════════
# ESSAY PROMPTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/essay/prompts")
async def list_essay_prompts(platform: Optional[str] = None):
    """List all essay prompts, optionally filtered by platform"""
    return essay_service.get_all(platform=platform)


@app.get(f"{API_PREFIX}/essay-indian-tips/{{platform}}")
async def get_indian_student_tips(platform: str = "common_app"):
    """Get essay prompts with enhanced tips for Indian students"""
    return essay_service.get_for_indian_student(platform)


@app.get(f"{API_PREFIX}/essay/prompts/{{prompt_id}}")
async def get_essay_prompt(prompt_id: str):
    """Get a specific essay prompt with tips"""
    prompt = essay_service.get_by_id(prompt_id)
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    return prompt


@app.post(f"{API_PREFIX}/essay/review")
async def review_essay(request: dict):
    """Review an essay draft and provide feedback"""
    essay_text = request.get("essay", "")
    prompt_id = request.get("prompt_id", "")
    word_limit = request.get("word_limit", 650)

    if not essay_text.strip():
        raise HTTPException(status_code=400, detail="Essay text is required")

    word_count = len(essay_text.split())

    # Basic analysis
    feedback = {
        "word_count": word_count,
        "word_limit": word_limit,
        "within_limit": word_count <= word_limit,
        "utilization_pct": round(word_count / word_limit * 100, 1) if word_limit > 0 else 0,
        "paragraph_count": len([p for p in essay_text.split("\n\n") if p.strip()]),
        "sentence_count": essay_text.count(".") + essay_text.count("!") + essay_text.count("?"),
        "avg_sentence_length": 0,
        "tips": [],
        "strengths": [],
        "improvements": [],
    }

    if feedback["sentence_count"] > 0:
        feedback["avg_sentence_length"] = round(word_count / feedback["sentence_count"])

    # Content analysis
    words = essay_text.lower().split()
    word_set = set(words)

    # Check for weak words
    weak_words = {"very", "really", "quite", "somewhat", "basically", "actually", "just", "thing", "stuff", "nice", "good", "bad"}
    found_weak = word_set & weak_words
    if found_weak:
        feedback["improvements"].append(f"Consider replacing weak words: {', '.join(found_weak)}")

    # Check for first person variety
    i_count = words.count("i")
    if i_count > 15 and word_count > 100:
        feedback["improvements"].append(f"'I' appears {i_count} times — try varying sentence structure")

    # Check for hook
    first_30 = " ".join(words[:30])
    if any(first_30.startswith(w) for w in ["my name is", "i am", "i was", "i have", "i went", "i like"]):
        feedback["improvements"].append("Opening may be too generic — consider a more attention-grabbing hook")

    # Check for storytelling
    story_words = {"then", "suddenly", "however", "meanwhile", "finally", "afterward", "realized"}
    if word_set & story_words:
        feedback["strengths"].append("Good use of narrative transitions")

    # Check for sensory language
    sensory = {"see", "heard", "felt", "smelled", "tasted", "touch", "sound", "smell", "taste", "color", "bright", "dark"}
    if word_set & sensory:
        feedback["strengths"].append("Nice use of sensory language — keeps the reader engaged")

    # Check for show don't tell
    telling = {"important", "learned", "grew", "developed", "became", "understood"}
    showing = {"instead", "decided", "chose", "stood", "walked", "built", "created", "wrote"}
    if word_set & telling and not (word_set & showing):
        feedback["improvements"].append("Try showing through actions rather than telling (e.g., 'I stood up' vs 'I learned bravery')")

    # Word utilization feedback
    if feedback["utilization_pct"] < 60:
        feedback["improvements"].append(f"Only {feedback['utilization_pct']}% of word limit used — expand your story")
    elif feedback["within_limit"]:
        feedback["strengths"].append(f"Good word count: {word_count}/{word_limit} ({feedback['utilization_pct']}%)")
    else:
        feedback["improvements"].append(f"Over word limit by {word_count - word_limit} words — trim for a tighter narrative")

    # Sentence variety
    if feedback["avg_sentence_length"] > 30:
        feedback["improvements"].append("Average sentence length is high — try mixing short punchy sentences with longer ones")
    elif feedback["avg_sentence_length"] > 0:
        feedback["strengths"].append("Good sentence variety")

    if not feedback["tips"]:
        feedback["tips"] = [
            "Read your essay aloud to catch awkward phrasing",
            "Have someone unfamiliar with your story read it — does it make sense?",
            "The best essays often start in the middle of the action, not at the beginning",
        ]

    return feedback





# ══════════════════════════════════════════════════════════════════════════════
# ACHIEVEMENTS & USER STATS
# ══════════════════════════════════════════════════════════════════════════════


# ══════════════════════════════════════════════════════════════════════════════
# PROFILE COMPLETION STRENGTH
# ══════════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/users/{{user_id}}/profile-strength")
async def get_profile_strength(user_id: str):
    """Calculate profile completion strength as percentage"""
    cursor = await db.db.execute("SELECT * FROM users WHERE id = ?", (user_id,))
    user = await cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Calculate completion based on filled fields
    checks = {
        "name": bool(user[1] if len(user) > 1 else None),       # name
        "email": bool(user[2] if len(user) > 2 else None),      # email
        "grade": bool(user[3] if len(user) > 3 else None),      # grade
        "board": bool(user[4] if len(user) > 4 else None),      # board
        "stream": bool(user[5] if len(user) > 5 else None),     # stream
        "city": bool(user[7] if len(user) > 7 else None),       # city
        "state": bool(user[8] if len(user) > 8 else None),      # state
    }
    
    filled = sum(1 for v in checks.values() if v)
    total = len(checks)
    percentage = round(filled / total * 100)
    
    # Recommendations
    missing = [k for k, v in checks.items() if not v]
    tips = []
    if not checks["grade"]:
        tips.append("Add your grade to help us find age-appropriate opportunities")
    if not checks["stream"]:
        tips.append("Add your stream (Science/Commerce/Arts) for personalized content")
    if not checks["city"]:
        tips.append("Enable location to discover local opportunities")
    if not checks["board"]:
        tips.append("Add your education board (CBSE/ICSE/State) for tailored advice")
    
    # Level system
    if percentage >= 90:
        level = "Excellent"
        emoji = "🏆"
    elif percentage >= 70:
        level = "Strong"
        emoji = "⭐"
    elif percentage >= 50:
        level = "Good"
        emoji = "👍"
    elif percentage >= 30:
        level = "Getting Started"
        emoji = "🌱"
    else:
        level = "Just Beginning"
        emoji = "🚀"
    
    return {
        "user_id": user_id,
        "percentage": percentage,
        "level": level,
        "emoji": emoji,
        "filled_fields": filled,
        "total_fields": total,
        "checks": checks,
        "tips": tips,
    }


# ══════════════════════════════════════════════════════════════════════════════
# NOTIFICATIONS & REMINDERS
# ══════════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/notifications/{{user_id}}")
async def get_notifications(user_id: str):
    """Get personalized notifications and reminders for a user"""
    notifications = []
    
    # Get user profile for personalization
    try:
        cursor = await db.db.execute("SELECT * FROM users WHERE id = ?", (user_id,))
        user = await cursor.fetchone()
        name = user[1] if user and len(user) > 1 else "Student"
    except Exception as e:
        logger.warning(f"Failed to fetch user name for notifications: {e}")
        name = "Student"
    
    # Check for pending weekly targets
    try:
        cursor = await db.db.execute(
            "SELECT COUNT(*) FROM weekly_targets WHERE user_id = ? AND status != 'completed'",
            (user_id,)
        )
        pending = (await cursor.fetchone())[0]
        if pending > 0:
            notifications.append({
                "id": "pending_targets",
                "type": "reminder",
                "title": f"{pending} targets remaining this week",
                "body": f"Hi {name}! You have {pending} unfinished targets. Complete them before Sunday to maintain your streak!",
                "priority": "high",
                "icon": "🎯",
                "action": "weekly_targets",
            })
    except Exception as e:
        logger.warning(f"Failed to fetch pending targets: {e}")
    
    # Streak reminder
    try:
        cursor = await db.db.execute(
            "SELECT streak_count FROM user_streaks WHERE user_id = ?",
            (user_id,)
        )
        streak = await cursor.fetchone()
        if streak and streak[0] > 0:
            notifications.append({
                "id": "streak_reminder",
                "type": "motivation",
                "title": f"🔥 {streak[0]}-day streak!",
                "body": f"Amazing {name}! Your {streak[0]}-day streak is on fire. Keep it going!",
                "priority": "medium",
                "icon": "🔥",
                "action": "streak",
            })
    except Exception as e:
        logger.warning(f"Failed to fetch streak data: {e}")
    
    # Competition reminders
    try:
        cursor = await db.db.execute("SELECT * FROM competition_entries WHERE user_id = ?", (user_id,))
        entries = await cursor.fetchall()
        if entries:
            notifications.append({
                "id": "competition_update",
                "type": "reminder",
                "title": "Competition deadline approaching",
                "body": f"You have {len(entries)} competition entries. Check your deadlines!",
                "priority": "medium",
                "icon": "🏆",
                "action": "competitions",
            })
    except Exception as e:
        logger.warning(f"Failed to fetch competition entries: {e}")
    
    # Daily tip notification
    import datetime
    hour = datetime.datetime.now().hour
    if 7 <= hour <= 10:
        notifications.append({
            "id": "morning_tip",
            "type": "tip",
            "title": "Good morning, {name}! ☀️",
            "body": "Start your day with 15 minutes of reading. It improves vocabulary and essay writing skills.",
            "priority": "low",
            "icon": "☀️",
            "action": None,
        })
    elif 17 <= hour <= 20:
        notifications.append({
            "id": "evening_review",
            "type": "tip",
            "title": "Evening review time, {name} 📖",
            "body": "Take 10 minutes to review what you learned today. Spaced repetition strengthens memory.",
            "priority": "low",
            "icon": "🌙",
            "action": None,
        })
    
    # Motivational message
    notifications.append({
        "id": "motivation",
        "type": "motivation",
        "title": "You're doing great!",
        "body": "Every step you take brings you closer to your dream college. Keep pushing forward! 💪",
        "priority": "low",
        "icon": "💪",
        "action": None,
    })
    
    return {"notifications": notifications, "count": len(notifications)}


@app.get(f"{API_PREFIX}/daily-tips")
async def get_daily_tips():
    """Return daily tips for students"""
    tips = [
        {"category": "Academics", "tip": "Read for 30 minutes daily — it improves vocabulary and comprehension for essays.", "icon": "📚"},
        {"category": "Writing", "tip": "Start your college essay with a specific moment, not a general statement.", "icon": "✍️"},
        {"category": "Research", "tip": "Spend 15 minutes daily researching universities that match your profile.", "icon": "🔍"},
        {"category": "Extracurriculars", "tip": "Quality over quantity — deep involvement in 2-3 activities beats surface-level participation in 10.", "icon": "🎯"},
        {"category": "Health", "tip": "Sleep 7-8 hours. Studies show well-rested students perform 20% better on exams.", "icon": "💤"},
        {"category": "Planning", "tip": "Every Sunday, review your week and plan 3 key goals for the next week.", "icon": "📋"},
        {"category": "Social", "tip": "Join one new club or community this month to expand your network.", "icon": "🤝"},
        {"category": "Finance", "tip": "Research 3 scholarships you qualify for before the end of this week.", "icon": "💰"},
    ]
    
    # Rotate tips based on day of year
    import datetime
    day = datetime.datetime.now().timetuple().tm_yday
    rotated = tips[day % len(tips):] + tips[:day % len(tips)]
    
    return {"tips": rotated[:3]}  # Return 3 tips daily


@app.get(f"{API_PREFIX}/achievements")
async def get_achievements():
    """Return all available achievements"""
    achievements = [
        {"id": "first_steps", "title": "First Steps", "description": "Complete your first mission", "icon": "🚀", "xp_reward": 50, "category": "onboarding"},
        {"id": "week_warrior", "title": "Week Warrior", "description": "Complete 7 days in a row", "icon": "⚔️", "xp_reward": 200, "category": "streak"},
        {"id": "essay_master", "title": "Essay Master", "description": "Write 5 essays", "icon": "✍️", "xp_reward": 300, "category": "writing"},
        {"id": "research_ninja", "title": "Research Ninja", "description": "Complete 10 research tasks", "icon": "🥷", "xp_reward": 250, "category": "research"},
        {"id": "community_hero", "title": "Community Hero", "description": "Log 20 volunteer hours", "icon": "🦸", "xp_reward": 400, "category": "service"},
        {"id": "compete_champ", "title": "Compete Champion", "description": "Enter 3 competitions", "icon": "🏆", "xp_reward": 350, "category": "competitions"},
        {"id": "profile_pro", "title": "Profile Pro", "description": "Complete 100% of profile", "icon": "⭐", "xp_reward": 500, "category": "profile"},
        {"id": "polyglot", "title": "Polyglot", "description": "Learn basics of 2 languages", "icon": "🌍", "xp_reward": 150, "category": "skills"},
        {"id": "night_owl", "title": "Night Owl", "description": "Study past 10 PM for 5 nights", "icon": "🦉", "xp_reward": 100, "category": "dedication"},
        {"id": "early_bird", "title": "Early Bird", "description": "Start tasks before 7 AM for 5 days", "icon": "🐦", "xp_reward": 100, "category": "dedication"},
        {"id": "social_butterfly", "title": "Social Butterfly", "description": "Connect with 5 peers", "icon": "🦋", "xp_reward": 150, "category": "social"},
        {"id": "level_up", "title": "Level Up!", "description": "Reach Level 5", "icon": "📈", "xp_reward": 250, "category": "progress"},
    ]
    return {"achievements": achievements}


@app.get(f"{API_PREFIX}/users/{{user_id}}/stats")
async def get_user_stats(user_id: str):
    """Get aggregated user statistics"""
    # Get user
    cursor = await db.db.execute("SELECT * FROM users WHERE id = ?", (user_id,))
    user = await cursor.fetchone()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    try:

        # Count weekly targets completed
        try:
            cursor = await db.db.execute(
                "SELECT COUNT(*) as total, SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed FROM weekly_targets WHERE user_id = ?",
                (user_id,)
            )
            targets = await cursor.fetchone()
            total_targets = targets[0] if targets else 0
            completed_targets = targets[1] if targets and targets[1] else 0
        except Exception as e:
            logger.warning(f"Failed to count weekly targets: {e}")
            total_targets = 0
            completed_targets = 0

        # Count chat messages
        try:
            cursor = await db.db.execute("SELECT COUNT(*) FROM chat_messages WHERE user_id = ?", (user_id,))
            msg_count = (await cursor.fetchone())[0]
        except Exception as e:
            logger.warning(f"Failed to count chat messages: {e}")
            msg_count = 0

        # Count competition entries
        try:
            cursor = await db.db.execute("SELECT COUNT(*) FROM competition_entries WHERE user_id = ?", (user_id,))
            comp_count = (await cursor.fetchone())[0]
        except Exception as e:
            logger.warning(f"Failed to count competition entries: {e}")
            comp_count = 0

        return {
            "user_id": user_id,
            "total_targets": total_targets,
            "completed_targets": completed_targets,
            "target_completion_rate": round(completed_targets / total_targets * 100, 1) if total_targets > 0 else 0,
            "chat_messages": msg_count,
            "competition_entries": comp_count,
            "achievements_unlocked": min(completed_targets // 2, 12),
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



# ══════════════════════════════════════════════════════════════════════════════
# ACTIVITY LOG & ANALYTICS
# ══════════════════════════════════════════════════════════════════════════════

@app.post(f"{API_PREFIX}/users/{{user_id}}/activity")
async def log_activity(user_id: str, activity: dict):
    """Log a user activity for analytics and streak tracking"""
    try:
        activity_type = activity.get("type", "unknown")
        description = activity.get("description", "")
        xp_earned = activity.get("xp_earned", 0)
        
        # Store in a simple table (create if not exists)
        try:
            await db.db.execute("""
                CREATE TABLE IF NOT EXISTS activity_log (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id TEXT NOT NULL,
                    activity_type TEXT NOT NULL,
                    description TEXT,
                    xp_earned INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
        except Exception as e:
            logger.warning(f'Operation failed at line 1223: {e}')
        
        await db.db.execute(
            "INSERT INTO activity_log (user_id, activity_type, description, xp_earned) VALUES (?, ?, ?, ?)",
            (user_id, activity_type, description, xp_earned)
        )
        await db.db.commit()
        
        return {"status": "logged", "activity_type": activity_type}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get(f"{API_PREFIX}/users/{{user_id}}/activity")
async def get_activity_history(user_id: str, limit: int = 20):
    """Get recent activity history for a user"""
    try:
        try:
            cursor = await db.db.execute(
                "SELECT activity_type, description, xp_earned, created_at FROM activity_log WHERE user_id = ? ORDER BY created_at DESC LIMIT ?",
                (user_id, limit)
            )
            rows = await cursor.fetchall()
        except Exception as e:
            rows = []
        
        activities = []
        for row in rows:
            activities.append({
                "type": row[0],
                "description": row[1],
                "xp_earned": row[2],
                "created_at": str(row[3]) if row[3] else None,
            })
        
        return {"activities": activities, "count": len(activities)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



# SCHOOL SEARCH and SCHOLARSHIPS

@app.get('/api/schools/search')
async def search_schools(q: str = '', state: str = ''):
    schools_db = [
        {'name': 'Delhi Public School R.K. Puram', 'city': 'New Delhi', 'state': 'Delhi', 'board': 'CBSE'},
        {'name': 'Delhi Public School Vasant Kunj', 'city': 'New Delhi', 'state': 'Delhi', 'board': 'CBSE'},
        {'name': 'The Shri Ram School', 'city': 'Gurgaon', 'state': 'Haryana', 'board': 'CBSE'},
        {'name': 'DPS Bangalore North', 'city': 'Bangalore', 'state': 'Karnataka', 'board': 'CBSE'},
        {'name': 'St. Xavier Collegiate School', 'city': 'Kolkata', 'state': 'West Bengal', 'board': 'ISC'},
        {'name': 'Bombay Scottish School', 'city': 'Mumbai', 'state': 'Maharashtra', 'board': 'ICSE'},
        {'name': 'Cathedral and John Connon School', 'city': 'Mumbai', 'state': 'Maharashtra', 'board': 'ICSE'},
        {'name': 'La Martiniere for Boys', 'city': 'Kolkata', 'state': 'West Bengal', 'board': 'ISC'},
        {'name': 'Vasant Valley School', 'city': 'New Delhi', 'state': 'Delhi', 'board': 'CBSE'},
        {'name': 'The Doon School', 'city': 'Dehradun', 'state': 'Uttarakhand', 'board': 'CBSE'},
        {'name': 'Mayo College', 'city': 'Ajmer', 'state': 'Rajasthan', 'board': 'CBSE'},
        {'name': 'Scindia School', 'city': 'Gwalior', 'state': 'Madhya Pradesh', 'board': 'CBSE'},
        {'name': 'Welham Boys School', 'city': 'Dehradun', 'state': 'Uttarakhand', 'board': 'CBSE'},
        {'name': 'DAV Public School', 'city': 'Multiple', 'state': 'All India', 'board': 'CBSE'},
        {'name': 'Amity International School', 'city': 'Noida', 'state': 'Uttar Pradesh', 'board': 'CBSE'},
        {'name': 'Ryan International School', 'city': 'Mumbai', 'state': 'Maharashtra', 'board': 'CBSE'},
        {'name': 'Modern School Barakhamba Road', 'city': 'New Delhi', 'state': 'Delhi', 'board': 'CBSE'},
        {'name': 'PSBB Senior Secondary School', 'city': 'Chennai', 'state': 'Tamil Nadu', 'board': 'CBSE'},
        {'name': 'Chinmaya Vidyalaya', 'city': 'Kochi', 'state': 'Kerala', 'board': 'CBSE'},
        {'name': 'Bharatiya Vidya Bhavan', 'city': 'Multiple', 'state': 'All India', 'board': 'CBSE'},
    ]
    results = schools_db
    if q:
        q_lower = q.lower()
        results = [s for s in results if q_lower in s['name'].lower() or q_lower in s['city'].lower()]
    if state:
        state_lower = state.lower()
        results = [s for s in results if state_lower in s['state'].lower()]
    return {'schools': results[:20], 'total': len(results)}


@app.get(f"{API_PREFIX}/leaderboard")
async def get_leaderboard(period: str = "weekly"):
    """Get leaderboard with mock data for demo + real user stats"""
    # Mock leaderboard data (will be replaced with real data later)
    leaderboard = [
        {"rank": 1, "name": "Aarav Sharma", "xp": 2450, "level": 12, "streak": 21, "avatar": "🌟"},
        {"rank": 2, "name": "Priya Patel", "xp": 2200, "level": 11, "streak": 18, "avatar": "⭐"},
        {"rank": 3, "name": "Rohan Gupta", "xp": 2050, "level": 10, "streak": 15, "avatar": "🏆"},
        {"rank": 4, "name": "Ananya Singh", "xp": 1900, "level": 10, "streak": 14, "avatar": "🎯"},
        {"rank": 5, "name": "Arjun Mehta", "xp": 1800, "level": 9, "streak": 12, "avatar": "🔥"},
        {"rank": 6, "name": "Kavya Nair", "xp": 1650, "level": 9, "streak": 11, "avatar": "💡"},
        {"rank": 7, "name": "Vihaan Kumar", "xp": 1500, "level": 8, "streak": 10, "avatar": "🚀"},
        {"rank": 8, "name": "Diya Reddy", "xp": 1400, "level": 8, "streak": 9, "avatar": "📚"},
        {"rank": 9, "name": "Ishaan Joshi", "xp": 1300, "level": 7, "streak": 8, "avatar": "🎓"},
        {"rank": 10, "name": "Saanvi Iyer", "xp": 1200, "level": 7, "streak": 7, "avatar": "✨"},
        {"rank": 11, "name": "Aditya Verma", "xp": 1100, "level": 6, "streak": 6, "avatar": "💪"},
        {"rank": 12, "name": "Riya Choudhary", "xp": 1000, "level": 6, "streak": 5, "avatar": "🌟"},
        {"rank": 13, "name": "Kabir Malhotra", "xp": 900, "level": 5, "streak": 5, "avatar": "🎯"},
        {"rank": 14, "name": "Meera Rao", "xp": 800, "level": 5, "streak": 4, "avatar": "🔥"},
        {"rank": 15, "name": "Reyansh Tiwari", "xp": 700, "level": 4, "streak": 3, "avatar": "🚀"},
    ]
    
    return {"leaderboard": leaderboard, "period": period, "total": len(leaderboard)}



# ══════════════════════════════════════════════════════════════════════════════
# MENTOR TIPS & GOAL TRACKING
# ══════════════════════════════════════════════════════════════════════════════

@app.get(f"{API_PREFIX}/mentor-tips")
async def get_mentor_tips(category: str = "all"):
    """Get curated mentor tips for college admissions"""
    tips = {
        "essay": [
            {"title": "Show Growth", "tip": "Admissions officers want to see how you've evolved. Don't just describe events — explain what you learned.", "mentor": "MIT Admissions Officer"},
            {"title": "Be Specific", "tip": "Instead of 'I volunteered at a shelter', write 'Every Saturday morning, I spent 3 hours teaching reading to 8 children at Hope Shelter.'", "mentor": "Stanford Former Reader"},
            {"title": "Voice Matters", "tip": "Your essay should sound like YOU, not a thesaurus. Use your natural speaking voice.", "mentor": "Yale Admissions"},
        ],
        "strategy": [
            {"title": "Start Early", "tip": "Begin your college research in 10th grade. By 11th, you should have a preliminary college list.", "mentor": "IvyWise Counselor"},
            {"title": "Demonstrated Interest", "tip": "Attend virtual info sessions, email professors, visit campuses if possible. Colleges track this.", "mentor": "College Counselor"},
            {"title": "Balanced List", "tip": "Aim for 2-3 reach schools, 3-4 match schools, and 2-3 safety schools.", "mentor": "US Admissions Expert"},
        ],
        "india_specific": [
            {"title": "Board Scores Matter", "tip": "For US/UK universities, your 10th and 12th board scores are critical. Aim for 90%+.", "mentor": "Study India Counselor"},
            {"title": "JEE/NEET + Abroad", "tip": "Many Indian students prepare for JEE/NEET alongside college apps. Start planning early to avoid burnout.", "mentor": "Indian Admissions Coach"},
            {"title": "Scholarships for Indians", "tip": "Look into Tata Scholarship (Cornell), Tata Trusts, Inlaks, Narotam Sekhsaria, and Kotak Kanya.", "mentor": "Financial Aid Expert"},
        ],
        "extracurriculars": [
            {"title": "Depth Over Breadth", "tip": "Being president of 1 club is better than being a member of 10. Show leadership and impact.", "mentor": "Harvard Admissions"},
            {"title": "Impact Metrics", "tip": "Quantify your achievements: 'Raised ₹2,5,000 for 50 underprivileged students' is better than 'Organized a fundraiser.'", "mentor": "Princeton Review"},
        ],
        "mental_health": [
            {"title": "It's a Marathon", "tip": "College admissions is stressful. Take breaks, talk to friends, and remember: your worth is not defined by admissions decisions.", "mentor": "Student Wellness Expert"},
            {"title": "Rejection is Normal", "tip": "Even the best students get rejected. Harvard rejects 96% of applicants. Don't take it personally.", "mentor": "College Counselor"},
        ],
    }
    
    import datetime
    day = datetime.datetime.now().timetuple().tm_yday
    
    if category == "all":
        # Return one from each category
        result = []
        for cat, cat_tips in tips.items():
            tip = cat_tips[day % len(cat_tips)]
            tip["category"] = cat
            result.append(tip)
        return {"tips": result}
    
    cat_tips = tips.get(category, tips["strategy"])
    tip = cat_tips[day % len(cat_tips)]
    tip["category"] = category
    return {"tips": [tip]}


@app.post(f"{API_PREFIX}/users/{{user_id}}/goals")
async def set_user_goals(user_id: str, goals: dict):
    """Set weekly goals for a user"""
    try:
        target_xp = goals.get("target_xp", 200)
        target_missions = goals.get("target_missions", 5)
        target_essays = goals.get("target_essays", 2)
        
        try:
            await db.db.execute("""
                CREATE TABLE IF NOT EXISTS user_goals (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id TEXT NOT NULL,
                    target_xp INTEGER DEFAULT 200,
                    target_missions INTEGER DEFAULT 5,
                    target_essays INTEGER DEFAULT 2,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
        except Exception as e:
            logger.warning(f'Operation failed at line 1397: {e}')
        
        # Upsert: delete old goals and insert new
        await db.db.execute("DELETE FROM user_goals WHERE user_id = ?", (user_id,))
        await db.db.execute(
            "INSERT INTO user_goals (user_id, target_xp, target_missions, target_essays) VALUES (?, ?, ?, ?)",
            (user_id, target_xp, target_missions, target_essays)
        )
        await db.db.commit()
        
        return {"status": "saved", "target_xp": target_xp, "target_missions": target_missions, "target_essays": target_essays}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get(f"{API_PREFIX}/users/{{user_id}}/goals")
async def get_user_goals(user_id: str):
    """Get user's weekly goals"""
    try:
        try:
            cursor = await db.db.execute(
                "SELECT target_xp, target_missions, target_essays FROM user_goals WHERE user_id = ? ORDER BY created_at DESC LIMIT 1",
                (user_id,)
            )
            row = await cursor.fetchone()
        except Exception as e:
            row = None
        
        if row:
            return {
                "target_xp": row[0],
                "target_missions": row[1],
                "target_essays": row[2],
            }
        
        # Default goals
        return {"target_xp": 200, "target_missions": 5, "target_essays": 2}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete(f"{API_PREFIX}/users/{{user_id}}")
async def delete_user(user_id: str):
    """Delete a user and all associated data"""
    tables = [
        "weekly_targets", "chat_messages", "competition_entries",
        "research_milestones", "opportunities", "gamification",
    ]
    # Validate table names against whitelist to prevent SQL injection
    allowed_tables = set(tables)
    deleted = []
    errors = []
    for table in tables:
        if table not in allowed_tables:
            errors.append(f"{table}: not allowed")
            continue
        try:
            await db.db.execute(f"DELETE FROM {table} WHERE user_id = ?", (user_id,))
            deleted.append(table)
        except Exception as e:
            errors.append(table)
    try:
        await db.db.execute("DELETE FROM users WHERE id = ?", (user_id,))
        deleted.append("users")
    except Exception as e:
        errors.append(f"users: {e}")
    await db.db.commit()
    return {"status": "deleted", "user_id": user_id, "tables_cleaned": deleted, "skipped": errors}


if __name__ == "__main__":
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=8080,
        reload=True
    )
