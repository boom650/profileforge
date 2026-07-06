"""
Task Service
Manages task creation, retrieval, and updates
"""

from typing import Optional, List
from datetime import datetime

from models.task import Task, TaskCreate, TaskStatus
from services.database import Database


class TaskService:
    def __init__(self, db: Database):
        self.db = db
    
    async def create_task(self, task: TaskCreate) -> Task:
        """Create a new task"""
        return await self.db.create_task(task)
    
    async def get_user_tasks(self, user_id: str, status: Optional[str] = None) -> List[Task]:
        """Get tasks for a user, optionally filtered by status"""
        return await self.db.get_user_tasks(user_id, status)
    
    async def get_task(self, task_id: str) -> Optional[Task]:
        """Get task by ID"""
        return await self.db.get_task(task_id)
    
    async def update_status(self, task_id: str, status: TaskStatus) -> bool:
        """Update task status"""
        return await self.db.update_task_status(task_id, status.value)
    
    async def generate_tasks_for_user(self, user_id: str) -> List[Task]:
        """
        Generate initial tasks for a user based on their profile.
        
        This is called after onboarding to populate the dashboard.
        """
        # Get user profile
        user = await self.db.get_user(user_id)
        if not user:
            return []
        
        # Generate tasks based on grade and interests
        tasks = []
        
        # Academic tasks
        tasks.append(TaskCreate(
            user_id=user_id,
            title="Complete your first practice essay",
            description="Write a 500-word essay on a topic you're passionate about. Focus on structure: introduction, body paragraphs, and conclusion.",
            category="writing",
            pillar="academics",
            difficulty=1,
            xp_reward=25
        ))
        
        tasks.append(TaskCreate(
            user_id=user_id,
            title="Research 3 universities",
            description="Find 3 universities that match your interests. Note their admission requirements and deadlines.",
            category="research",
            pillar="academics",
            difficulty=1,
            xp_reward=30
        ))
        
        # Research tasks
        tasks.append(TaskCreate(
            user_id=user_id,
            title="Read a research paper",
            description="Find and read a research paper in your field of interest. Summarize the key findings and methodology.",
            category="research",
            pillar="research",
            difficulty=2,
            xp_reward=40
        ))
        
        # Community tasks
        tasks.append(TaskCreate(
            user_id=user_id,
            title="Find a local NGO to volunteer with",
            description="Research NGOs in your area. Identify one that aligns with your values and note their volunteer opportunities.",
            category="community",
            pillar="community",
            difficulty=1,
            xp_reward=35
        ))
        
        # Leadership tasks
        tasks.append(TaskCreate(
            user_id=user_id,
            title="Plan a small group activity",
            description="Organize a study group or community activity. Document your role and what you learned about leadership.",
            category="leadership",
            pillar="leadership",
            difficulty=2,
            xp_reward=45
        ))
        
        # Create all tasks
        created_tasks = []
        for task_create in tasks:
            task = await self.create_task(task_create)
            created_tasks.append(task)
        
        return created_tasks
    
    async def get_task_stats(self, user_id: str) -> dict:
        """Get task completion statistics"""
        all_tasks = await self.get_user_tasks(user_id)
        pending = await self.get_user_tasks(user_id, "pending")
        completed = await self.get_user_tasks(user_id, "completed")
        
        return {
            "total": len(all_tasks),
            "pending": len(pending),
            "completed": len(completed),
            "completion_rate": len(completed) / max(len(all_tasks), 1)
        }
