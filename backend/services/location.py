"""
Location Service
Handles GPS coordinates, city search, and nearby opportunity discovery
"""

from typing import Optional, List
from datetime import datetime

from models.user import UserLocation
from services.database import Database


class LocationService:
    def __init__(self, db: Database):
        self.db = db
    
    async def update_location(self, user_id: str, location: UserLocation) -> bool:
        """Update user's GPS coordinates"""
        now = datetime.now().isoformat()
        
        await self.db.db.execute("""
            UPDATE users 
            SET latitude=?, longitude=?, city=?, state=?, country=?, updated_at=?
            WHERE id=?
        """, (location.latitude, location.longitude, location.city, 
              location.state, location.country, now, user_id))
        
        await self.db.db.commit()
        return True
    
    async def get_location(self, user_id: str) -> Optional[dict]:
        """Get user's stored location"""
        user = await self.db.get_user(user_id)
        if not user or user.latitude is None:
            return None
        
        return {
            "latitude": user.latitude,
            "longitude": user.longitude,
            "city": user.city,
            "state": user.state,
            "country": user.country
        }
    
    async def update_city(self, user_id: str, city: str) -> bool:
        """Update user's city (manual entry fallback)"""
        now = datetime.now().isoformat()
        
        await self.db.db.execute("""
            UPDATE users 
            SET city=?, updated_at=?
            WHERE id=?
        """, (city, now, user_id))
        
        await self.db.db.commit()
        return True
    
    async def get_nearby_opportunities(self, user_id: str) -> List[dict]:
        """Get opportunities near user's location"""
        location = await self.get_location(user_id)
        
        if not location:
            # Return empty if no location set
            return []
        
        # For now, return a placeholder
        # In production, this would query OpenStreetMap/Overpass API
        return [
            {
                "type": "ngo",
                "name": "Local NGO Opportunity",
                "distance": "2.5 km",
                "description": "Volunteer opportunity at a local NGO"
            },
            {
                "type": "competition",
                "name": "Science Fair 2026",
                "distance": "5 km",
                "description": "Annual science fair competition"
            }
        ]
    
    async def search_by_city(self, city: str) -> List[dict]:
        """Search opportunities by city name"""
        # Placeholder - would query external APIs
        return [
            {
                "type": "ngo",
                "name": f"NGO in {city}",
                "description": f"Volunteer opportunity in {city}"
            },
            {
                "type": "competition",
                "name": f"Competition in {city}",
                "description": f"Academic competition in {city}"
            }
        ]
