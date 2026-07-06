"""
Course Service
Manages free course listings, enrollments, and certificate verification
"""

import uuid
from typing import Optional, List
from datetime import datetime

from models.course import Course, CourseCreate, CourseEnrollment, CourseStatus, CertificateStatus
from services.database import Database


class CourseService:
    def __init__(self, db: Database):
        self.db = db
    
    # ═══════════════════════════════════════════════════════════════════════════
    # COURSE CATALOG OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def create_course(self, course: CourseCreate) -> Course:
        """Create a new course in the catalog"""
        course_id = str(uuid.uuid4())
        now = datetime.now().isoformat()
        
        await self.db.db.execute("""
            INSERT INTO courses (id, title, description, provider, url, category, 
                                 pillar, difficulty, xp_reward, estimated_hours, 
                                 certificate_required, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (course_id, course.title, course.description, course.provider, 
              course.url, course.category, course.pillar, course.difficulty,
              course.xp_reward, course.estimated_hours, course.certificate_required, now))
        
        await self.db.db.commit()
        
        return Course(
            id=course_id,
            title=course.title,
            description=course.description,
            provider=course.provider,
            url=course.url,
            category=course.category,
            pillar=course.pillar,
            difficulty=course.difficulty,
            xp_reward=course.xp_reward,
            estimated_hours=course.estimated_hours,
            certificate_required=course.certificate_required,
            created_at=now
        )
    
    async def get_course(self, course_id: str) -> Optional[Course]:
        """Get course by ID"""
        cursor = await self.db.db.execute(
            "SELECT * FROM courses WHERE id = ?", (course_id,)
        )
        row = await cursor.fetchone()
        
        if not row:
            return None
        
        return Course(
            id=row[0],
            title=row[1],
            description=row[2],
            provider=row[3],
            url=row[4],
            category=row[5],
            pillar=row[6],
            difficulty=row[7],
            xp_reward=row[8],
            estimated_hours=row[9],
            certificate_required=row[10],
            created_at=row[11]
        )
    
    async def get_all_courses(
        self, 
        category: Optional[str] = None,
        pillar: Optional[str] = None,
        difficulty: Optional[int] = None
    ) -> List[Course]:
        """Get all courses with optional filters"""
        query = "SELECT * FROM courses WHERE 1=1"
        params = []
        
        if category:
            query += " AND category = ?"
            params.append(category)
        if pillar:
            query += " AND pillar = ?"
            params.append(pillar)
        if difficulty:
            query += " AND difficulty = ?"
            params.append(difficulty)
        
        query += " ORDER BY created_at DESC"
        
        cursor = await self.db.db.execute(query, params)
        rows = await cursor.fetchall()
        
        return [
            Course(
                id=row[0],
                title=row[1],
                description=row[2],
                provider=row[3],
                url=row[4],
                category=row[5],
                pillar=row[6],
                difficulty=row[7],
                xp_reward=row[8],
                estimated_hours=row[9],
                certificate_required=row[10],
                created_at=row[11]
            )
            for row in rows
        ]
    
    async def search_courses(self, query: str) -> List[Course]:
        """Search courses by title, description, or provider"""
        search_term = f"%{query}%"
        cursor = await self.db.db.execute("""
            SELECT * FROM courses 
            WHERE title LIKE ? OR description LIKE ? OR provider LIKE ?
            ORDER BY created_at DESC
        """, (search_term, search_term, search_term))
        rows = await cursor.fetchall()
        
        return [
            Course(
                id=row[0],
                title=row[1],
                description=row[2],
                provider=row[3],
                url=row[4],
                category=row[5],
                pillar=row[6],
                difficulty=row[7],
                xp_reward=row[8],
                estimated_hours=row[9],
                certificate_required=row[10],
                created_at=row[11]
            )
            for row in rows
        ]
    
    # ═══════════════════════════════════════════════════════════════════════════
    # ENROLLMENT OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    
    async def enroll_user(self, user_id: str, course_id: str) -> CourseEnrollment:
        """Enroll a user in a course"""
        enrollment_id = str(uuid.uuid4())
        now = datetime.now().isoformat()
        
        # Check if already enrolled
        existing = await self.get_enrollment(user_id, course_id)
        if existing:
            return existing
        
        await self.db.db.execute("""
            INSERT INTO course_enrollments (id, user_id, course_id, status, 
                                           certificate_status, enrolled_at)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (enrollment_id, user_id, course_id, "enrolled", "pending", now))
        
        await self.db.db.commit()
        
        return CourseEnrollment(
            id=enrollment_id,
            user_id=user_id,
            course_id=course_id,
            status="enrolled",
            certificate_status="pending",
            enrolled_at=now
        )
    
    async def get_enrollment(
        self, user_id: str, course_id: str
    ) -> Optional[CourseEnrollment]:
        """Get enrollment for a user in a course"""
        cursor = await self.db.db.execute("""
            SELECT * FROM course_enrollments 
            WHERE user_id = ? AND course_id = ?
        """, (user_id, course_id))
        row = await cursor.fetchone()
        
        if not row:
            return None
        
        return CourseEnrollment(
            id=row[0],
            user_id=row[1],
            course_id=row[2],
            status=row[3],
            certificate_url=row[4],
            certificate_status=row[5],
            enrolled_at=row[6],
            completed_at=row[7]
        )
    
    async def get_user_enrollments(
        self, user_id: str, status: Optional[str] = None
    ) -> List[CourseEnrollment]:
        """Get all enrollments for a user"""
        if status:
            cursor = await self.db.db.execute("""
                SELECT * FROM course_enrollments 
                WHERE user_id = ? AND status = ?
                ORDER BY enrolled_at DESC
            """, (user_id, status))
        else:
            cursor = await self.db.db.execute("""
                SELECT * FROM course_enrollments 
                WHERE user_id = ?
                ORDER BY enrolled_at DESC
            """, (user_id,))
        
        rows = await cursor.fetchall()
        
        return [
            CourseEnrollment(
                id=row[0],
                user_id=row[1],
                course_id=row[2],
                status=row[3],
                certificate_url=row[4],
                certificate_status=row[5],
                enrolled_at=row[6],
                completed_at=row[7]
            )
            for row in rows
        ]
    
    async def submit_certificate(
        self, user_id: str, course_id: str, certificate_url: str
    ) -> Optional[CourseEnrollment]:
        """Submit certificate for a course"""
        enrollment = await self.get_enrollment(user_id, course_id)
        if not enrollment:
            return None
        
        now = datetime.now().isoformat()
        
        await self.db.db.execute("""
            UPDATE course_enrollments 
            SET certificate_url = ?, certificate_status = ?, status = ?
            WHERE user_id = ? AND course_id = ?
        """, (certificate_url, "pending", "in_progress", user_id, course_id))
        
        await self.db.db.commit()
        
        return await self.get_enrollment(user_id, course_id)
    
    async def complete_enrollment(
        self, user_id: str, course_id: str
    ) -> Optional[CourseEnrollment]:
        """Mark enrollment as completed (after certificate approved)"""
        enrollment = await self.get_enrollment(user_id, course_id)
        if not enrollment:
            return None
        
        now = datetime.now().isoformat()
        
        await self.db.db.execute("""
            UPDATE course_enrollments 
            SET status = ?, certificate_status = ?, completed_at = ?
            WHERE user_id = ? AND course_id = ?
        """, ("completed", "approved", now, user_id, course_id))
        
        await self.db.db.commit()
        
        return await self.get_enrollment(user_id, course_id)
    
    async def get_user_stats(self, user_id: str) -> dict:
        """Get course completion statistics for a user"""
        all_enrollments = await self.get_user_enrollments(user_id)
        enrolled = await self.get_user_enrollments(user_id, "enrolled")
        in_progress = await self.get_user_enrollments(user_id, "in_progress")
        completed = await self.get_user_enrollments(user_id, "completed")
        
        # Calculate total XP earned from courses
        total_xp = 0
        for enrollment in completed:
            course = await self.get_course(enrollment.course_id)
            if course:
                total_xp += course.xp_reward
        
        return {
            "total_enrolled": len(all_enrollments),
            "enrolled": len(enrolled),
            "in_progress": len(in_progress),
            "completed": len(completed),
            "total_xp_earned": total_xp,
            "completion_rate": len(completed) / max(len(all_enrollments), 1)
        }
    
    async def delete_course(self, course_id: str) -> bool:
        """Delete a course from catalog"""
        cursor = await self.db.db.execute(
            "DELETE FROM courses WHERE id = ?", (course_id,)
        )
        await self.db.db.commit()
        return cursor.rowcount > 0
