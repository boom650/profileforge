"""
ProfileForge Backend Server
FastAPI-based backend for the Flutter app
Handles: Users, Location, Tasks, Document Evaluation, XP/Gamification
"""

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
from services.database import Database
from services.evaluation import EvaluationService
from services.tasks import TaskService
from services.xp import XPService
from services.location import LocationService
from services.ai_evaluation import AIEvaluationService
from services.gemini_client import get_gemini

# Initialize FastAPI app
app = FastAPI(
    title="ProfileForge API",
    description="Backend for ProfileForge - AI CV Builder",
    version="1.0.0"
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
ai_eval = AIEvaluationService()


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
    """Evaluate text content against task criteria.
    Accepts JSON body: {"user_id": "...", "task_id": "...", "content": "..."}"""
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
# STARTUP/SHUTDOWN
# ═══════════════════════════════════════════════════════════════════════════

@app.on_event("startup")
async def startup():
    """Initialize database on startup"""
    await db.initialize()
    print("✅ ProfileForge API started")


@app.on_event("shutdown")
async def shutdown():
    """Cleanup on shutdown"""
    await db.close()
    print("🛑 ProfileForge API stopped")


if __name__ == "__main__":
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=8080,
        reload=True
    )
