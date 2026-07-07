"""
ProfileForge Backend Server
FastAPI-based backend for the Flutter app
Handles: Users, Location, Tasks, Document Evaluation, XP/Gamification, Chat, Weekly Targets
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException, UploadFile, File, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import os
import json
import uuid
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel
import sqlite3

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
)

# CORS middleware - allow Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
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

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}


# ═══════════════════════════════════════════════════════════════════════════
# USER ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/api/users", response_model=User)
async def create_user(user: UserCreate):
    """Create a new user profile"""
    try:
        return await db.create_user(user)
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=409, detail="User with this email already exists")


@app.get("/api/users/{user_id}", response_model=User)
async def get_user(user_id: str):
    """Get user by ID"""
    user = await db.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.put("/api/users/{user_id}", response_model=User)
async def update_user(user_id: str, user: User):
    """Update user profile"""
    updated = await db.update_user(user_id, user)
    if not updated:
        raise HTTPException(status_code=404, detail="User not found")
    return updated


# ═══════════════════════════════════════════════════════════════════════════
# LOCATION ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/api/users/{user_id}/location")
async def update_location(user_id: str, location: UserLocation):
    """Update user's GPS coordinates"""
    result = await location_service.update_location(user_id, location)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return {"status": "success", "location": location}


@app.get("/api/users/{user_id}/location")
async def get_location(user_id: str):
    """Get user's stored location"""
    location = await location_service.get_location(user_id)
    if not location:
        raise HTTPException(status_code=404, detail="Location not set")
    return location


@app.post("/api/users/{user_id}/city")
async def update_city(user_id: str, city: str):
    """Update user's city (manual entry fallback)"""
    result = await location_service.update_city(user_id, city)
    if not result:
        raise HTTPException(status_code=404, detail="User not found")
    return {"status": "success", "city": city}


# ═══════════════════════════════════════════════════════════════════════════
# TASK ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/api/tasks", response_model=Task)
async def create_task(task: TaskCreate):
    """Create a new task (used by Hermes agent)"""
    return await task_service.create_task(task)


@app.get("/api/tasks/{user_id}", response_model=List[Task])
async def get_user_tasks(user_id: str, status: Optional[str] = None):
    """Get all tasks for a user, optionally filtered by status"""
    return await task_service.get_user_tasks(user_id, status)


@app.get("/api/tasks/{user_id}/pending", response_model=List[Task])
async def get_pending_tasks(user_id: str):
    """Get pending tasks for a user"""
    return await task_service.get_user_tasks(user_id, "pending")


class TaskStatusUpdate(BaseModel):
    status: TaskStatus

@app.put("/api/tasks/{task_id}/status")
async def update_task_status(task_id: str, body: TaskStatusUpdate):
    """Update task status"""
    result = await task_service.update_status(task_id, body.status)
    if not result:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"status": "success"}


@app.post("/api/tasks/{task_id}/complete")
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

@app.post("/api/evaluate")
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


@app.post("/api/evaluate/text")
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

@app.get("/api/xp/{user_id}")
async def get_xp(user_id: str):
    """Get user's XP state"""
    return await xp_service.get_xp_state(user_id)


import httpx as _httpx
BRIDGE_URL = "http://127.0.0.1:8090"


@app.post("/api/ai/evaluate")
async def ai_evaluate_via_bridge(body: dict):
    """Submit text for AI evaluation via Hermes bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.post(f"{BRIDGE_URL}/evaluate", json=body)
        return resp.json()


@app.get("/api/ai/results/{job_id}")
async def ai_get_result(job_id: str):
    """Get AI evaluation result from bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.get(f"{BRIDGE_URL}/results/{job_id}")
        return resp.json()


@app.post("/api/ai/tasks/generate")
async def ai_generate_tasks_via_bridge(body: dict):
    """Request AI task generation via Hermes bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.post(f"{BRIDGE_URL}/tasks/generate", json=body)
        return resp.json()


@app.get("/api/ai/task-results/{job_id}")
async def ai_get_task_results(job_id: str):
    """Get AI task generation results from bridge."""
    async with _httpx.AsyncClient(timeout=5) as client:
        resp = await client.get(f"{BRIDGE_URL}/task-results/{job_id}")
        return resp.json()


@app.post("/api/xp/{user_id}/award")
async def award_xp(user_id: str, transaction: XPTransaction):
    """Award XP to user"""
    result = await xp_service.award_xp(
        user_id=user_id,
        amount=transaction.amount,
        source=transaction.source,
        pillar=transaction.pillar
    )
    return result


@app.get("/api/xp/{user_id}/history")
async def get_xp_history(user_id: str, limit: int = 50):
    """Get XP transaction history"""
    return await xp_service.get_history(user_id, limit)


@app.get("/api/skins/{user_id}")
async def get_skins(user_id: str):
    """Get user's skin collection"""
    return await xp_service.get_skins(user_id)


@app.post("/api/skins/{user_id}/unlock")
async def unlock_skin(user_id: str, skin_id: str):
    """Unlock a skin for user"""
    return await xp_service.unlock_skin(user_id, skin_id)


@app.post("/api/streak/{user_id}/update")
async def update_streak(user_id: str):
    """Update user's streak (call daily)"""
    return await xp_service.update_streak(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# FREE COURSES ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get("/api/courses")
async def list_courses(
    category: Optional[str] = None,
    pillar: Optional[str] = None,
    difficulty: Optional[int] = None
):
    """List all available free courses with optional filters"""
    return await course_service.get_all_courses(category, pillar, difficulty)


@app.get("/api/courses/{course_id}")
async def get_course(course_id: str):
    """Get course details by ID"""
    course = await course_service.get_course(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return course


@app.get("/api/courses/search/{query}")
async def search_courses(query: str):
    """Search courses by title, description, or provider"""
    return await course_service.search_courses(query)


@app.post("/api/courses/{course_id}")
async def create_course(course_id: str, course: CourseCreate):
    """Create a new course (admin/hermes endpoint)"""
    return await course_service.create_course(course)


@app.post("/api/courses/{user_id}/enroll/{course_id}")
async def enroll_in_course(user_id: str, course_id: str):
    """Enroll user in a free course"""
    course = await course_service.get_course(course_id)
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    
    enrollment = await course_service.enroll_user(user_id, course_id)
    return enrollment


@app.get("/api/courses/{user_id}/enrolled")
async def get_user_enrollments(user_id: str, status: Optional[str] = None):
    """Get all courses a user is enrolled in"""
    return await course_service.get_user_enrollments(user_id, status)


@app.post("/api/courses/{user_id}/submit-certificate/{course_id}")
async def submit_certificate(user_id: str, course_id: str, body: CertificateSubmit):
    """Submit certificate URL for a completed course"""
    enrollment = await course_service.get_enrollment(user_id, course_id)
    if not enrollment:
        raise HTTPException(status_code=404, detail="Not enrolled in this course")
    
    result = await course_service.submit_certificate(
        user_id, course_id, body.certificate_url
    )
    return result


@app.post("/api/courses/{user_id}/complete/{course_id}")
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


@app.get("/api/courses/{user_id}/stats")
async def get_course_stats(user_id: str):
    """Get course completion stats for a user"""
    return await course_service.get_user_stats(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# CHAT ENDPOINTS — Connect to Hermes via bridge
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/api/chat", response_model=ChatResponse)
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


@app.get("/api/chat/{conversation_id}/history")
async def get_chat_history(conversation_id: str):
    """Get the full conversation history for a chat session."""
    history = await chat_service.get_conversation_history(conversation_id)
    if not history:
        raise HTTPException(status_code=404, detail="Conversation not found")
    return history


@app.get("/api/chat/conversations/{user_id}")
async def list_user_conversations(user_id: str):
    """List all chat conversations for a user."""
    return await chat_service.list_conversations(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# WEEKLY TARGETS & RESEARCH MILESTONES
# ═══════════════════════════════════════════════════════════════════════════

@app.post("/api/weekly-targets", response_model=WeeklyTarget)
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


@app.get("/api/weekly-targets/{user_id}")
async def get_weekly_targets(
    user_id: str,
    week: Optional[int] = None,
    year: Optional[int] = None,
):
    """Get all targets for a user in a given week (defaults to current week)."""
    return await weekly_targets_service.get_weekly_targets(user_id, week, year)


@app.put("/api/weekly-targets/{target_id}/status")
async def update_target_status(target_id: str, status: MilestoneStatus):
    """Update a weekly target's status (not_started → in_progress → completed)."""
    target = await weekly_targets_service.update_target_status(target_id, status)
    if not target:
        raise HTTPException(status_code=404, detail="Target not found")
    return target


@app.delete("/api/weekly-targets/{target_id}")
async def delete_target(target_id: str):
    """Delete a weekly target and its associated milestones."""
    deleted = await weekly_targets_service.delete_target(target_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Target not found")
    return {"status": "deleted"}


@app.get("/api/research-milestones/{user_id}")
async def get_research_milestones(user_id: str):
    """Get all research paper milestones for a user."""
    return await weekly_targets_service.get_all_milestones(user_id)


@app.put("/api/research-milestones/{milestone_id}")
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

@app.post("/api/hermes/tasks/push")
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


@app.get("/api/hermes/tasks/{user_id}/pending")
async def hermes_get_pending(user_id: str):
    """
    Endpoint for Hermes to check pending tasks.
    Used for autonomous task generation.
    """
    return await task_service.get_user_tasks(user_id, "pending")


@app.post("/api/hermes/evaluate")
async def hermes_evaluate(request: EvaluationRequest):
    """
    Endpoint for Hermes to evaluate documents.
    Called when user uploads a document.
    """
    return await evaluation_service.evaluate(request)


# ═══════════════════════════════════════════════════════════════════════════
# OPPORTUNITY ENDPOINTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get("/api/opportunities/search")
async def search_opportunities(city: str):
    """Search opportunities by city"""
    return await location_service.search_by_city(city)


@app.get("/api/opportunities/{user_id}")
async def get_opportunities(user_id: str):
    """Get opportunities for user based on location"""
    return await location_service.get_nearby_opportunities(user_id)


# ═══════════════════════════════════════════════════════════════════════════
# UNIVERSITY MATCHER
# ═══════════════════════════════════════════════════════════════════════════

@app.get("/api/universities")
async def list_universities(country: Optional[str] = None, max_tuition: Optional[int] = None):
    """List all universities, optionally filtered by country or budget"""
    return university_service.search(country=country, max_tuition=max_tuition)


@app.get("/api/universities/{uni_id}")
async def get_university(uni_id: str):
    """Get details for a specific university"""
    uni = university_service.get_by_id(uni_id)
    if not uni:
        raise HTTPException(status_code=404, detail="University not found")
    return uni


@app.post("/api/universities/match")
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

@app.get("/api/notifications/{user_id}/daily")
async def get_daily_reminder(user_id: str):
    """Get a context-aware daily reminder for the user"""
    context = {
        "tasks_remaining": 3,
        "probability": 65,
        "top_task": "Complete your weekly target",
        "streak": 5,
    }
    return notification_service.get_daily_reminder(user_id, context)


@app.get("/api/notifications/{user_id}/weekly")
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


@app.post("/api/notifications/{user_id}/competition-alert")
async def get_competition_alert(user_id: str, competition: str = "KVPY",
                                 days_left: int = 14):
    """Get competition registration alert"""
    return notification_service.get_competition_alert(user_id, competition, days_left)


@app.get("/api/notifications/{user_id}/streak")
async def get_streak_reminder(user_id: str, streak: int = 5):
    """Get streak-based reminder"""
    return notification_service.get_streak_reminder(user_id, streak)


# ═══════════════════════════════════════════════════════════════════════════
# SCHOLARSHIPS
# ═══════════════════════════════════════════════════════════════════════════

@app.get("/api/scholarships")
async def list_scholarships(country: Optional[str] = None):
    """List all scholarships, optionally filtered by country"""
    return scholarship_service.get_all(country=country)


@app.get("/api/search-scholarships/{query}")
async def search_scholarships(query: str):
    """Search scholarships by name, country, or description"""
    return scholarship_service.search(query)


@app.get("/api/indian-scholarships")
async def get_indian_scholarships():
    """Get scholarships relevant to Indian students"""
    return scholarship_service.get_for_indian_student()


@app.get("/api/scholarships/{scholarship_id}")
async def get_scholarship(scholarship_id: str):
    """Get a specific scholarship"""
    s = scholarship_service.get_by_id(scholarship_id)
    if not s:
        raise HTTPException(status_code=404, detail="Scholarship not found")
    return s


# ═══════════════════════════════════════════════════════════════════════════
# ESSAY PROMPTS
# ═══════════════════════════════════════════════════════════════════════════

@app.get("/api/essay/prompts")
async def list_essay_prompts(platform: Optional[str] = None):
    """List all essay prompts, optionally filtered by platform"""
    return essay_service.get_all(platform=platform)


@app.get("/api/essay-indian-tips/{platform}")
async def get_indian_student_tips(platform: str = "common_app"):
    """Get essay prompts with enhanced tips for Indian students"""
    return essay_service.get_for_indian_student(platform)


@app.get("/api/essay/prompts/{prompt_id}")
async def get_essay_prompt(prompt_id: str):
    """Get a specific essay prompt with tips"""
    prompt = essay_service.get_by_id(prompt_id)
    if not prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    return prompt


@app.post("/api/essay/review")
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




@app.delete("/api/users/{user_id}")
async def delete_user(user_id: str):
    """Delete a user and all associated data"""
    tables = [
        "weekly_targets", "chat_messages", "competition_entries",
        "research_milestones", "opportunities", "gamification",
    ]
    deleted = []
    errors = []
    for table in tables:
        try:
            await db.db.execute(f"DELETE FROM {table} WHERE user_id = ?", (user_id,))
            deleted.append(table)
        except Exception:
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
