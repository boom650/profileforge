"""
XP Service
Manages XP transactions, levels, and gamification
"""

from typing import Optional, List
from datetime import datetime, timedelta

from models.xp import XPTransaction, XPResult, XPState
from services.database import Database


class XPService:
    def __init__(self, db: Database):
        self.db = db
    
    async def get_xp_state(self, user_id: str) -> Optional[dict]:
        """Get user's current XP state"""
        return await self.db.get_xp_state(user_id)
    
    async def award_xp(
        self, 
        user_id: str, 
        amount: int, 
        source: str, 
        pillar: str
    ) -> dict:
        """
        Award XP to user
        
        Args:
            user_id: User ID
            amount: XP amount to award
            source: What triggered this (e.g., "task:123", "evaluation:456")
            pillar: Which pillar this XP belongs to
        
        Returns:
            Updated XP state with level info
        """
        return await self.db.add_xp(user_id, amount, pillar, source)
    
    async def get_history(self, user_id: str, limit: int = 50) -> List[dict]:
        """Get XP transaction history"""
        return await self.db.get_xp_history(user_id, limit)
    
    async def get_skins(self, user_id: str) -> List[dict]:
        """Get user's skin collection"""
        cursor = await self.db.db.execute(
            "SELECT * FROM skins WHERE user_id = ?", (user_id,)
        )
        rows = await cursor.fetchall()
        
        return [
            {
                "id": row[0],
                "skin_id": row[2],
                "unlocked_at": row[3],
                "equipped": bool(row[4])
            }
            for row in rows
        ]
    
    async def unlock_skin(self, user_id: str, skin_id: str) -> dict:
        """Unlock a skin for user"""
        import uuid
        
        skin_id_full = str(uuid.uuid4())
        
        await self.db.db.execute("""
            INSERT OR IGNORE INTO skins (id, user_id, skin_id, equipped)
            VALUES (?, ?, ?, 0)
        """, (skin_id_full, user_id, skin_id))
        
        await self.db.db.commit()
        
        return {"status": "success", "skin_id": skin_id}
    
    async def update_streak(self, user_id: str) -> dict:
        """Update user's daily streak"""
        now = datetime.now()
        today = now.date().isoformat()
        
        state = await self.get_xp_state(user_id)
        if not state:
            return {"error": "User not found"}
        
        last_active = state.get("last_active")
        current_streak = state.get("streak_days", 0)
        
        if last_active:
            last_date = datetime.fromisoformat(last_active).date()
            days_diff = (now.date() - last_date).days
            
            if days_diff == 1:
                # Consecutive day - increment streak
                new_streak = current_streak + 1
            elif days_diff == 0:
                # Same day - no change
                new_streak = current_streak
            else:
                # Streak broken
                new_streak = 1
        else:
            # First activity
            new_streak = 1
        
        # Update streak in database
        await self.db.db.execute("""
            UPDATE xp_state 
            SET streak_days=?, last_active=?, updated_at=?
            WHERE user_id=?
        """, (new_streak, now.isoformat(), now.isoformat(), user_id))
        
        await self.db.db.commit()
        
        # Check for streak bonuses
        bonus_xp = 0
        if new_streak == 7:
            bonus_xp = 50  # Weekly streak bonus
        elif new_streak == 30:
            bonus_xp = 200  # Monthly streak bonus
        
        if bonus_xp > 0:
            await self.award_xp(user_id, bonus_xp, "streak_bonus", "consistency")
        
        return {
            "streak_days": new_streak,
            "bonus_xp": bonus_xp,
            "leveled_up": False
        }
