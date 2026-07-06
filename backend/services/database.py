"""
Database Service
SQLite-based storage for ProfileForge backend
"""

import aiosqlite
import json
import uuid
from datetime import datetime
from typing import Optional, List
from pathlib import Path

from models.user import User, UserCreate, UserLocation
from models.task import Task, TaskCreate, TaskStatus
from models.xp import XPState, XPTransaction, XPResult


class Database:
    def __init__(self):
        self.db_path = Path(__file__).parent.parent / "data" / "profileforge.db"
        self.db: Optional[aiosqlite.Connection] = None
    
    async def initialize(self):
        """Create tables if they don't exist"""
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self.db = await aiosqlite.connect(str(self.db_path))
        
        # Enable WAL mode for better concurrency
        await self.db.execute("PRAGMA journal_mode=WAL")
        
        # Create tables
        await self._create_tables()
        print(f"✅ Database initialized at {self.db_path}")
    
    async def _create_tables(self):
        """Create all required tables"""
        
        # Users table
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                email TEXT UNIQUE,
                grade INTEGER,
                board TEXT,
                stream TEXT,
                city TEXT,
                state TEXT,
                country TEXT,
                latitude REAL,
                longitude REAL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        # Tasks table
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS tasks (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                title TEXT NOT NULL,
                description TEXT,
                category TEXT,
                pillar TEXT,
                difficulty INTEGER DEFAULT 1,
                xp_reward INTEGER DEFAULT 10,
                status TEXT DEFAULT 'pending',
                due_date TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                completed_at TEXT,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)
        
        # XP transactions table
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS xp_transactions (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                amount INTEGER NOT NULL,
                source TEXT,
                pillar TEXT,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)
        
        # XP state table (aggregated)
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS xp_state (
                user_id TEXT PRIMARY KEY,
                total_xp INTEGER DEFAULT 0,
                level INTEGER DEFAULT 1,
                academics_xp INTEGER DEFAULT 0,
                research_xp INTEGER DEFAULT 0,
                leadership_xp INTEGER DEFAULT 0,
                creativity_xp INTEGER DEFAULT 0,
                community_xp INTEGER DEFAULT 0,
                evidence_xp INTEGER DEFAULT 0,
                consistency_xp INTEGER DEFAULT 0,
                streak_days INTEGER DEFAULT 0,
                last_active TEXT,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)
        
        # Skins table
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS skins (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                skin_id TEXT NOT NULL,
                unlocked_at TEXT DEFAULT CURRENT_TIMESTAMP,
                equipped INTEGER DEFAULT 0,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)
        
        # Evaluations table
        await self.db.execute("""
            CREATE TABLE IF NOT EXISTS evaluations (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                task_id TEXT,
                file_type TEXT,
                filename TEXT,
                status TEXT,
                feedback TEXT,
                score REAL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)
        
        await self.db.commit()
    
    # ═══════════════════════════════════════════════════════════════════════════
    # USER OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def create_user(self, user: UserCreate) -> User:
        """Create a new user"""
        user_id = str(uuid.uuid4())
        now = datetime.now().isoformat()
        
        await self.db.execute("""
            INSERT INTO users (id, name, email, grade, board, stream, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (user_id, user.name, user.email, user.grade, user.board, user.stream, now, now))
        
        # Initialize XP state
        await self.db.execute("""
            INSERT INTO xp_state (user_id, last_active)
            VALUES (?, ?)
        """, (user_id, now))
        
        await self.db.commit()
        
        return User(
            id=user_id,
            name=user.name,
            email=user.email,
            grade=user.grade,
            board=user.board,
            stream=user.stream,
            created_at=now,
            updated_at=now
        )
    
    async def get_user(self, user_id: str) -> Optional[User]:
        """Get user by ID"""
        cursor = await self.db.execute(
            "SELECT * FROM users WHERE id = ?", (user_id,)
        )
        row = await cursor.fetchone()
        
        if not row:
            return None
        
        return User(
            id=row[0],
            name=row[1],
            email=row[2],
            grade=row[3],
            board=row[4],
            stream=row[5],
            city=row[6],
            state=row[7],
            country=row[8],
            latitude=row[9],
            longitude=row[10],
            created_at=row[11],
            updated_at=row[12]
        )
    
    async def update_user(self, user_id: str, user: User) -> Optional[User]:
        """Update user profile"""
        now = datetime.now().isoformat()
        
        await self.db.execute("""
            UPDATE users 
            SET name=?, email=?, grade=?, board=?, stream=?, 
                city=?, state=?, country=?, updated_at=?
            WHERE id=?
        """, (user.name, user.email, user.grade, user.board, user.stream,
              user.city, user.state, user.country, now, user_id))
        
        await self.db.commit()
        return await self.get_user(user_id)
    
    # ═══════════════════════════════════════════════════════════════════════════
    # TASK OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def create_task(self, task: TaskCreate) -> Task:
        """Create a new task"""
        task_id = str(uuid.uuid4())
        now = datetime.now().isoformat()
        
        await self.db.execute("""
            INSERT INTO tasks (id, user_id, title, description, category, 
                              pillar, difficulty, xp_reward, status, due_date, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (task_id, task.user_id, task.title, task.description, task.category,
              task.pillar, task.difficulty, task.xp_reward, "pending", task.due_date, now))
        
        await self.db.commit()
        
        return Task(
            id=task_id,
            user_id=task.user_id,
            title=task.title,
            description=task.description,
            category=task.category,
            pillar=task.pillar,
            difficulty=task.difficulty,
            xp_reward=task.xp_reward,
            status="pending",
            due_date=task.due_date,
            created_at=now
        )
    
    async def get_user_tasks(self, user_id: str, status: Optional[str] = None) -> List[Task]:
        """Get tasks for a user"""
        if status:
            cursor = await self.db.execute(
                "SELECT * FROM tasks WHERE user_id = ? AND status = ? ORDER BY created_at DESC",
                (user_id, status)
            )
        else:
            cursor = await self.db.execute(
                "SELECT * FROM tasks WHERE user_id = ? ORDER BY created_at DESC",
                (user_id,)
            )
        
        rows = await cursor.fetchall()
        
        return [
            Task(
                id=row[0],
                user_id=row[1],
                title=row[2],
                description=row[3],
                category=row[4],
                pillar=row[5],
                difficulty=row[6],
                xp_reward=row[7],
                status=row[8],
                due_date=row[9],
                created_at=row[10],
                completed_at=row[11]
            )
            for row in rows
        ]
    
    async def get_task(self, task_id: str) -> Optional[Task]:
        """Get task by ID"""
        cursor = await self.db.execute(
            "SELECT * FROM tasks WHERE id = ?", (task_id,)
        )
        row = await cursor.fetchone()
        
        if not row:
            return None
        
        return Task(
            id=row[0],
            user_id=row[1],
            title=row[2],
            description=row[3],
            category=row[4],
            pillar=row[5],
            difficulty=row[6],
            xp_reward=row[7],
            status=row[8],
            due_date=row[9],
            created_at=row[10],
            completed_at=row[11]
        )
    
    async def update_task_status(self, task_id: str, status: str) -> bool:
        """Update task status"""
        now = datetime.now().isoformat()
        
        cursor = await self.db.execute(
            "UPDATE tasks SET status=?, completed_at=? WHERE id=?",
            (status, now if status == "completed" else None, task_id)
        )
        
        await self.db.commit()
        return cursor.rowcount > 0
    
    # ═══════════════════════════════════════════════════════════════════════════
    # XP OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def get_xp_state(self, user_id: str) -> Optional[dict]:
        """Get user's XP state"""
        cursor = await self.db.execute(
            "SELECT * FROM xp_state WHERE user_id = ?", (user_id,)
        )
        row = await cursor.fetchone()
        
        if not row:
            return None
        
        return {
            "user_id": row[0],
            "total_xp": row[1],
            "level": row[2],
            "academics_xp": row[3],
            "research_xp": row[4],
            "leadership_xp": row[5],
            "creativity_xp": row[6],
            "community_xp": row[7],
            "evidence_xp": row[8],
            "consistency_xp": row[9],
            "streak_days": row[10],
            "last_active": row[11]
        }
    
    async def add_xp(self, user_id: str, amount: int, pillar: str) -> dict:
        """Add XP to user and update level"""
        now = datetime.now().isoformat()
        
        # Get current state
        current = await self.get_xp_state(user_id)
        if not current:
            return {"error": "User not found"}
        
        # Calculate new values
        new_total = current["total_xp"] + amount
        new_level = (new_total // 100) + 1  # Level up every 100 XP
        
        # Update pillar XP
        pillar_column = f"{pillar}_xp"
        new_pillar_xp = current.get(f"{pillar}_xp", 0) + amount
        
        # Update XP state
        await self.db.execute(f"""
            UPDATE xp_state 
            SET total_xp=?, level=?, {pillar_column}=?, updated_at=?
            WHERE user_id=?
        """, (new_total, new_level, new_pillar_xp, now, user_id))
        
        # Record transaction
        tx_id = str(uuid.uuid4())
        await self.db.execute("""
            INSERT INTO xp_transactions (id, user_id, amount, source, pillar, created_at)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (tx_id, user_id, amount, f"task_completion", pillar, now))
        
        await self.db.commit()
        
        return {
            "total_xp": new_total,
            "level": new_level,
            "pillar_xp": new_pillar_xp,
            "leveled_up": new_level > current["level"]
        }
    
    async def get_xp_history(self, user_id: str, limit: int = 50) -> List[dict]:
        """Get XP transaction history"""
        cursor = await self.db.execute(
            "SELECT * FROM xp_transactions WHERE user_id = ? ORDER BY created_at DESC LIMIT ?",
            (user_id, limit)
        )
        rows = await cursor.fetchall()
        
        return [
            {
                "id": row[0],
                "amount": row[2],
                "source": row[3],
                "pillar": row[4],
                "created_at": row[5]
            }
            for row in rows
        ]
    
    # ═══════════════════════════════════════════════════════════════════════════
    # EVALUATION OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def save_evaluation(self, user_id: str, task_id: str, result: dict) -> str:
        """Save evaluation result"""
        eval_id = str(uuid.uuid4())
        now = datetime.now().isoformat()
        
        await self.db.execute("""
            INSERT INTO evaluations (id, user_id, task_id, file_type, filename, 
                                    status, feedback, score, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (eval_id, user_id, task_id, result.get("file_type"), 
              result.get("filename"), result.get("status"), 
              result.get("feedback"), result.get("score"), now))
        
        await self.db.commit()
        return eval_id
    
    async def close(self):
        """Close database connection"""
        if self.db:
            await self.db.close()
