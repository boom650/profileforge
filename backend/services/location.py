"""
Location Service — Real opportunity discovery for Indian students
Handles GPS coordinates, city search, and nearby opportunities
Includes: NGOs (NGO Darpan), ATL Labs, Competitions, Scholarships
"""

from typing import Optional, List, Dict
from datetime import datetime
import json
import random

from models.user import UserLocation
from services.database import Database


# ═══════════════════════════════════════════════════════════════════════════
# REAL INDIAN OPPORTUNITIES DATABASE
# ═══════════════════════════════════════════════════════════════════════════

INDIAN_NGOS = [
    {
        "id": "ngo_1",
        "name": "Teach For India",
        "type": "ngo",
        "category": "education",
        "cities": ["Mumbai", "Delhi", "Bangalore", "Chennai", "Hyderabad", "Pune", "Ahmedabad"],
        "description": "Teach underprivileged children for 2 years. Build leadership skills and social impact profile.",
        "url": "https://www.teachforindia.org",
        "impact_level": "high",
        "time_commitment": "2 years",
        "admissions_value": "Very High — Demonstrates sustained social impact and leadership",
    },
    {
        "id": "ngo_2",
        "name": "Pratham",
        "type": "ngo",
        "category": "education",
        "cities": ["Delhi", "Mumbai", "Lucknow", "Jaipur", "Pune", "Bangalore"],
        "description": "India's largest education NGO. Volunteer for read-aloud campaigns and ASER surveys.",
        "url": "https://www.pratham.org",
        "impact_level": "high",
        "time_commitment": "Weekends",
        "admissions_value": "High — Research-grade data collection + social impact",
    },
    {
        "id": "ngo_3",
        "name": "CRY (Child Rights and You)",
        "type": "ngo",
        "category": "child_rights",
        "cities": ["Mumbai", "Delhi", "Bangalore", "Chennai", "Kolkata", "Pune"],
        "description": "Advocate for children's rights. Run awareness campaigns and fundraise.",
        "url": "https://www.cry.org",
        "impact_level": "medium",
        "time_commitment": "Flexible",
        "admissions_value": "Medium — Good for showing community engagement",
    },
    {
        "id": "ngo_4",
        "name": "Habitat for Humanity India",
        "type": "ngo",
        "category": "housing",
        "cities": ["Mumbai", "Delhi", "Bangalore", "Chennai", "Hyderabad"],
        "description": "Build homes for families in need. Participate in Global Village builds.",
        "url": "https://www.habitatindia.org",
        "impact_level": "medium",
        "time_commitment": "Weekend builds",
        "admissions_value": "Medium — Shows teamwork and hands-on impact",
    },
    {
        "id": "ngo_5",
        "name": "Doctors For You",
        "type": "ngo",
        "category": "health",
        "cities": ["Mumbai", "Delhi", "Bangalore", "Chennai"],
        "description": "Medical relief and public health. Volunteer at health camps.",
        "url": "https://www.doctorsforyou.org",
        "impact_level": "high",
        "time_commitment": "Flexible",
        "admissions_value": "High — Great for pre-med applicants",
    },
    {
        "id": "ngo_6",
        "name": "Give India",
        "type": "ngo",
        "category": "fundraising",
        "cities": ["Mumbai", "Delhi", "Bangalore", "All India"],
        "description": "Fundraise for vetted NGOs. Run campaigns on campus.",
        "url": "https://www.giveindia.org",
        "impact_level": "medium",
        "time_commitment": "Flexible",
        "admissions_value": "Medium — Entrepreneurial + social impact",
    },
    {
        "id": "ngo_7",
        "name": "Vivekananda Kendra",
        "type": "ngo",
        "category": "community",
        "cities": ["Pan India"],
        "description": "Community service rooted in Swami Vivekananda's teachings. Nature camps, rural service.",
        "url": "https://www.vivekanandakendra.org",
        "impact_level": "medium",
        "time_commitment": "Weekends",
        "admissions_value": "Medium — Cultural + community engagement",
    },
]

ATL_LABS = [
    {
        "id": "atl_1",
        "name": "ATL — Delhi Public School, R.K. Puram",
        "type": "atl_lab",
        "city": "Delhi",
        "address": "Sri Aurobindo Marg, R.K. Puram, New Delhi",
        "equipment": ["3D Printers", "IoT Kits", "Robotics Kits", "AI/ML Workstations"],
        "programs": ["Space Innovation", "Robotics", "App Development", "Design Thinking"],
        "url": "https://innovate.mygov.in/atlas",
    },
    {
        "id": "atl_2",
        "name": "ATL — Kendriya Vidyalaya IIT Bombay",
        "type": "atl_lab",
        "city": "Mumbai",
        "address": "IIT Bombay Campus, Powai, Mumbai",
        "equipment": ["3D Printers", "IoT Sensors", "Drone Kits", "VR Headsets"],
        "programs": ["Space Tech", "AI/ML", "Biotech Innovation", "Smart Agriculture"],
        "url": "https://innovate.mygov.in/atlas",
    },
    {
        "id": "atl_3",
        "name": "ATL — Jawahar Navodaya Vidyalaya",
        "type": "atl_lab",
        "city": "Bangalore",
        "address": "JNV Campus, Bangalore Rural",
        "equipment": ["3D Printers", "Robotics", "IoT Kits"],
        "programs": ["Waste Management", "Water Conservation", "Solar Innovation"],
        "url": "https://innovate.mygov.in/atlas",
    },
    {
        "id": "atl_4",
        "name": "ATL — DAV Public School",
        "type": "atl_lab",
        "city": "Chennai",
        "address": "DAV Campus, Velachery, Chennai",
        "equipment": ["3D Printers", "Arduino Kits", "Raspberry Pi"],
        "programs": ["IoT Projects", "Green Tech", "Smart City Solutions"],
        "url": "https://innovate.mygov.in/atlas",
    },
    {
        "id": "atl_5",
        "name": "ATL — The Heritage School",
        "type": "atl_lab",
        "city": "Kolkata",
        "address": "VIP Road, Kolkata",
        "equipment": ["3D Printers", "Robotics Kits", "AI Workstations"],
        "programs": ["AI for Social Good", "Biomedical Devices", "Climate Tech"],
        "url": "https://innovate.mygov.in/atlas",
    },
]

COMPETITIONS = [
    {
        "id": "comp_1",
        "name": "NTSE (National Talent Search Examination)",
        "type": "competition",
        "category": "academic",
        "eligibility": "Class 10 (appear in Nov-Dec)",
        "deadline": "2026-11-15",
        "url": "https://ncert.nic.in",
        "admissions_value": "Very High — Prestigious scholarship exam",
        "description": "National scholarship for top 1000 students. Tests mental ability + scholastic aptitude.",
    },
    {
        "id": "comp_2",
        "name": "KVPY (Kishore Vaigyanik Protsahan Yojana)",
        "type": "competition",
        "category": "research",
        "eligibility": "Class 11-12 Science students",
        "deadline": "2026-10-01",
        "url": "https://kvpy.iisc.ac.in",
        "admissions_value": "Very High — Direct admission to IISc/IISERs",
        "description": "Fellowship for science research aspirants. Interview after aptitude test.",
    },
    {
        "id": "comp_3",
        "name": "INSPIRE Scholarship (SHE)",
        "type": "competition",
        "category": "research",
        "eligibility": "Top 1% of Class 10 board exam",
        "deadline": "2026-12-31",
        "url": "https://www.online-inspire.gov.in",
        "admissions_value": "High — ₹80,000/year research scholarship",
        "description": "Scholarship for pursuing BSc/BS/Int-MS in natural sciences.",
    },
    {
        "id": "comp_4",
        "name": "International Olympiads (IOQM/INMO/RMO/IMO)",
        "type": "competition",
        "category": "math",
        "eligibility": "Class 8-12",
        "deadline": "2026-09-30",
        "url": "https://www.mtai.org.in",
        "admissions_value": "Very High — IMO medal = automatic IIT admission",
        "description": "Mathematics olympiad pipeline. IOQM → INMO → RMO → IMO.",
    },
    {
        "id": "comp_5",
        "name": "Indian Science Olympiad (NSEJS→NSEP→NSEA→IOS→IOAA)",
        "type": "competition",
        "category": "science",
        "eligibility": "Class 8-12",
        "deadline": "2026-11-30",
        "url": "https://iapt.org",
        "admissions_value": "Very High — International medal = IISc admission",
        "description": "Physics/Chemistry/Biology/Astronomy olympiad pipeline.",
    },
    {
        "id": "comp_6",
        "name": "JEE Main & Advanced",
        "type": "competition",
        "category": "engineering",
        "eligibility": "Class 12 pass (75%+ or top 20 percentile)",
        "deadline": "2027-04-01",
        "url": "https://jeemain.nta.nic.in",
        "admissions_value": "Very High — Gateway to IITs/NITs/IIITs",
        "description": "National engineering entrance. JEE Main → JEE Advanced → IIT counseling.",
    },
    {
        "id": "comp_7",
        "name": "Hackathon: Smart India Hackathon (SIH)",
        "type": "competition",
        "category": "tech",
        "eligibility": "College students (but early preparation helps)",
        "deadline": "2026-08-15",
        "url": "https://sih.gov.in",
        "admissions_value": "High — Shows innovation and teamwork",
        "description": "World's largest hackathon. Solve real government problem statements.",
    },
    {
        "id": "comp_8",
        "name": "ISRO Young Scientist Program (YUVIKA)",
        "type": "competition",
        "category": "space",
        "eligibility": "Class 9 (studying in Class 9 as of 2026)",
        "deadline": "2026-03-31",
        "url": "https://www.isro.gov.in",
        "admissions_value": "Very High — ISRO research experience",
        "description": "2-week residential program at ISRO centers. Space science, rocketry, satellite tech.",
    },
]

SCHOLARSHIPS = [
    {
        "id": "sch_1",
        "name": "AICTE Pragati Scholarship for Girls",
        "type": "scholarship",
        "eligibility": "Girls pursuing technical education (₹30,000/year)",
        "deadline": "2026-11-30",
        "url": "https://www.aicte-india.org",
        "admissions_value": "Medium — Financial support + resume builder",
    },
    {
        "id": "sch_2",
        "name": "National Means-cum-Merit Scholarship (NMMSS)",
        "type": "scholarship",
        "eligibility": "Class 9 students, family income <₹3.5L",
        "deadline": "2026-09-30",
        "url": "https://www.education.gov.in",
        "admissions_value": "Medium — ₹12,000/year for Classes 9-12",
    },
    {
        "id": "sch_3",
        "name": "Tata Scholarship (Cornell)",
        "type": "scholarship",
        "eligibility": "Indian students accepted to Cornell, need-based",
        "deadline": "2026-11-01",
        "url": "https://finaid.cornell.edu/tata",
        "admissions_value": "Very High — Full funding at Cornell",
    },
    {
        "id": "sch_4",
        "name": "Inlaks Scholarship",
        "type": "scholarship",
        "eligibility": "Indian undergrads for UK/US/EU masters",
        "deadline": "2026-10-15",
        "url": "https://inlaksfoundation.org",
        "admissions_value": "High — Up to $100K for overseas study",
    },
    {
        "id": "sch_5",
        "name": "Narotam Sekhsaria Foundation Scholarship",
        "type": "scholarship",
        "eligibility": "Indian students for PG studies abroad",
        "deadline": "2026-12-15",
        "url": "https://www.narotamsekhsaria.org.in",
        "admissions_value": "High — Interest-free loan + grant",
    },
]

ALL_OPPORTUNITIES = INDIAN_NGOS + ATL_LABS + COMPETITIONS + SCHOLARSHIPS


class LocationService:
    def __init__(self, db: Database):
        self.db = db

    async def update_location(self, user_id: str, location: UserLocation) -> bool:
        """Update user's GPS coordinates"""
        now = datetime.now().isoformat()

        await self.db.db.execute(
            "UPDATE users SET latitude=?, longitude=?, city=?, state=?, country=?, updated_at=? WHERE id=?",
            (location.latitude, location.longitude, location.city,
             location.state, location.country, now, user_id)
        )
        await self.db.db.commit()
        return True

    async def get_location(self, user_id: str) -> Optional[dict]:
        """Get user's stored location"""
        user = await self.db.get_user(user_id)
        if not user or (user.latitude is None and user.city is None):
            return None

        return {
            "latitude": user.latitude,
            "longitude": user.longitude,
            "city": user.city,
            "state": user.state,
            "country": user.country,
        }

    async def update_city(self, user_id: str, city: str) -> bool:
        """Update user's city (manual entry fallback)"""
        now = datetime.now().isoformat()
        await self.db.db.execute(
            "UPDATE users SET city=?, updated_at=? WHERE id=?",
            (city, now, user_id)
        )
        await self.db.db.commit()
        return True

    async def get_nearby_opportunities(self, user_id: str) -> List[dict]:
        """Get opportunities near user's location or city"""
        location = await self.get_location(user_id)
        if not location:
            return self._get_default_opportunities()

        city = location.get("city", "")
        if not city:
            return self._get_default_opportunities()

        return self._filter_by_city(city)

    async def search_by_city(self, city: str) -> List[dict]:
        """Search opportunities by city name"""
        return self._filter_by_city(city)

    async def search_by_type(self, opp_type: str) -> List[dict]:
        """Search opportunities by type (ngo, atl_lab, competition, scholarship)"""
        return [o for o in ALL_OPPORTUNITIES if o["type"] == opp_type]

    async def search_by_category(self, category: str) -> List[dict]:
        """Search by category (education, research, math, science, etc.)"""
        return [o for o in ALL_OPPORTUNITIES if o.get("category") == category]

    async def get_opportunity_detail(self, opp_id: str) -> Optional[dict]:
        """Get full details for a single opportunity"""
        for o in ALL_OPPORTUNITIES:
            if o["id"] == opp_id:
                return o
        return None

    def _filter_by_city(self, city: str) -> List[dict]:
        """Filter all opportunities relevant to a city"""
        city_lower = city.lower()
        results = []

        for opp in ALL_OPPORTUNITIES:
            # NGOs — check if city is in their city list
            if opp["type"] == "ngo":
                cities = opp.get("cities", [])
                if any(city_lower in c.lower() or c.lower() in city_lower for c in cities):
                    results.append(opp)
                elif "All India" in cities:
                    results.append(opp)
            # ATL Labs — direct city match
            elif opp["type"] == "atl_lab":
                if city_lower in opp.get("city", "").lower():
                    results.append(opp)
            # Competitions and scholarships — always relevant (national)
            elif opp["type"] in ("competition", "scholarship"):
                results.append(opp)

        return results

    def _get_default_opportunities(self) -> List[dict]:
        """Default set when no city is set"""
        # Return competitions + scholarships (always national) + top NGOs
        defaults = (
            [o for o in COMPETITIONS[:5]]
            + [o for o in SCHOLARSHIPS[:3]]
            + [o for o in INDIAN_NGOS[:3]]
        )
        return defaults
