"""
University Service — Real university data for Indian students
Includes US/UK/Canada/Australia/EU universities with admission data
"""

from typing import Optional, List
from models.university import University, UniversityMatch


# ═══════════════════════════════════════════════════════════════════════════
# REAL UNIVERSITY DATABASE
# ═══════════════════════════════════════════════════════════════════════════

UNIVERSITIES = [
    # ── US — Ivy League + Top 20 ──
    University(id="harvard", name="Harvard University", country="US", city="Cambridge, MA",
               acceptance_rate=0.03, ranking_us_news=1, ranking_qs=4, tuition_usd=59076,
               has_need_based_aid=True, strengths=["Research", "Liberal Arts", "Business", "Law", "Medicine"],
               typical_gpa=4.0, typical_sat=1520, website="https://harvard.edu",
               deadline_early="Nov 1", deadline_regular="Jan 1"),
    University(id="mit", name="MIT", country="US", city="Cambridge, MA",
               acceptance_rate=0.039, ranking_us_news=2, ranking_qs=1, tuition_usd=59750,
               has_need_based_aid=True, strengths=["Engineering", "CS", "Math", "Physics", "AI"],
               typical_gpa=4.0, typical_sat=1550, website="https://mit.edu",
               deadline_early="Nov 1", deadline_regular="Jan 1"),
    University(id="stanford", name="Stanford University", country="US", city="Stanford, CA",
               acceptance_rate=0.036, ranking_us_news=3, ranking_qs=5, tuition_usd=62484,
               has_need_based_aid=True, strengths=["CS", "Engineering", "Business", "Entrepreneurship"],
               typical_gpa=4.0, typical_sat=1540, website="https://stanford.edu",
               deadline_early="Nov 1", deadline_regular="Jan 2"),
    University(id="caltech", name="Caltech", country="US", city="Pasadena, CA",
               acceptance_rate=0.027, ranking_us_news=7, ranking_qs=6, tuition_usd=63402,
               has_need_based_aid=True, strengths=["Physics", "Math", "Engineering", "Astronomy"],
               typical_gpa=4.0, typical_sat=1560, website="https://caltech.edu",
               deadline_early="Nov 1", deadline_regular="Jan 3"),
    University(id="columbia", name="Columbia University", country="US", city="New York, NY",
               acceptance_rate=0.039, ranking_us_news=12, ranking_qs=22, tuition_usd=65524,
               has_need_based_aid=True, strengths=["Humanities", "Social Sciences", "Journalism", "Engineering"],
               typical_gpa=3.9, typical_sat=1510, website="https://columbia.edu",
               deadline_early="Nov 1", deadline_regular="Jan 1"),
    University(id="upenn", name="University of Pennsylvania", country="US", city="Philadelphia, PA",
               acceptance_rate=0.055, ranking_us_news=6, ranking_qs=13, tuition_usd=63452,
               has_need_based_aid=True, strengths=["Business (Wharton)", "Engineering", "Nursing"],
               typical_gpa=3.9, typical_sat=1500, website="https://upenn.edu",
               deadline_early="Nov 1", deadline_regular="Jan 5"),
    University(id="yale", name="Yale University", country="US", city="New Haven, CT",
               acceptance_rate=0.046, ranking_us_news=5, ranking_qs=16, tuition_usd=64700,
               has_need_based_aid=True, strengths=["Liberal Arts", "Drama", "Law", "Humanities"],
               typical_gpa=4.0, typical_sat=1510, website="https://yale.edu",
               deadline_early="Nov 1", deadline_regular="Jan 2"),
    University(id="princeton", name="Princeton University", country="US", city="Princeton, NJ",
               acceptance_rate=0.040, ranking_us_news=1, ranking_qs=22, tuition_usd=59710,
               has_need_based_aid=True, strengths=["Math", "Physics", "Economics", "Public Policy"],
               typical_gpa=4.0, typical_sat=1520, website="https://princeton.edu",
               deadline_early="Nov 1", deadline_regular="Jan 1"),

    # ── US — Top Public + Other ──
    University(id="ucb", name="UC Berkeley", country="US", city="Berkeley, CA",
               acceptance_rate=0.116, ranking_us_news=22, ranking_qs=10, tuition_usd=44007,
               has_need_based_aid=True, strengths=["CS", "Engineering", "Chemistry", "Business (Haas)"],
               typical_gpa=3.9, typical_sat=1450, website="https://berkeley.edu",
               deadline_regular="Nov 30"),
    University(id="ucla", name="UCLA", country="US", city="Los Angeles, CA",
               acceptance_rate=0.087, ranking_us_news=15, ranking_qs=29, tuition_usd=43473,
               has_need_based_aid=True, strengths=["Film", "Engineering", "Psychology", "Biology"],
               typical_gpa=3.9, typical_sat=1440, website="https://ucla.edu",
               deadline_regular="Nov 30"),
    University(id="umich", name="University of Michigan", country="US", city="Ann Arbor, MI",
               acceptance_rate=0.178, ranking_us_news=21, ranking_qs=33, tuition_usd=55220,
               has_need_based_aid=True, has_merit_scholarships=True,
               strengths=["Engineering", "Business (Ross)", "CS", "Medicine"],
               typical_gpa=3.8, typical_sat=1430, website="https://umich.edu"),
    University(id="gatech", name="Georgia Tech", country="US", city="Atlanta, GA",
               acceptance_rate=0.164, ranking_us_news=33, ranking_qs=36, tuition_usd=37600,
               has_merit_scholarships=True, strengths=["Engineering", "CS", "Industrial Design"],
               typical_gpa=3.8, typical_sat=1430, website="https://gatech.edu"),

    # ── UK — Russell Group ──
    University(id="oxford", name="University of Oxford", country="UK", city="Oxford",
               acceptance_rate=0.175, ranking_qs=2, tuition_usd=42000,
               strengths=["Humanities", "Medicine", "Law", "Physics", "PPE"],
               typical_gpa=3.9, website="https://ox.ac.uk", deadline_regular="Jan 15"),
    University(id="cambridge", name="University of Cambridge", country="UK", city="Cambridge",
               acceptance_rate=0.186, ranking_qs=3, tuition_usd=42000,
               strengths=["Math", "Science", "Engineering", "Medicine"],
               typical_gpa=3.9, website="https://cam.ac.uk", deadline_regular="Jan 15"),
    University(id="imperial", name="Imperial College London", country="UK", city="London",
               acceptance_rate=0.143, ranking_qs=6, tuition_usd=41500,
               strengths=["Engineering", "Medicine", "CS", "Business"],
               typical_gpa=3.8, website="https://imperial.ac.uk", deadline_regular="Jan 30"),
    University(id="ucl", name="UCL", country="UK", city="London",
               acceptance_rate=0.156, ranking_qs=9, tuition_usd=38000,
               strengths=["Architecture", "Education", "Medicine", "Law"],
               typical_gpa=3.7, website="https://ucl.ac.uk", deadline_regular="Jan 30"),
    University(id="edinburgh", name="University of Edinburgh", country="UK", city="Edinburgh",
               acceptance_rate=0.180, ranking_qs=15, tuition_usd=32000,
               strengths=["AI", "Medicine", "Law", "Literature"],
               typical_gpa=3.6, website="https://ed.ac.uk", deadline_regular="Jan 30"),

    # ── Canada ──
    University(id="uoft", name="University of Toronto", country="Canada", city="Toronto, ON",
               acceptance_rate=0.43, ranking_qs=21, tuition_usd=57020,
               strengths=["CS", "Engineering", "Medicine", "Business (Rotman)"],
               typical_gpa=3.7, website="https://utoronto.ca", deadline_regular="Jan 15"),
    University(id="ubc", name="University of British Columbia", country="Canada", city="Vancouver, BC",
               acceptance_rate=0.52, ranking_qs=34, tuition_usd=43238,
               has_merit_scholarships=True, strengths=["Forestry", "Mining", "CS", "Business"],
               typical_gpa=3.6, website="https://ubc.ca", deadline_regular="Jan 15"),
    University(id="mcgill", name="McGill University", country="Canada", city="Montreal, QC",
               acceptance_rate=0.46, ranking_qs=30, tuition_usd=25000,
               strengths=["Medicine", "Music", "Engineering", "Science"],
               typical_gpa=3.7, website="https://mcgill.ca", deadline_regular="Jan 15"),
    University(id="waterloo", name="University of Waterloo", country="Canada", city="Waterloo, ON",
               acceptance_rate=0.53, ranking_qs=112, tuition_usd=55000,
               strengths=["CS (Co-op)", "Engineering", "Math", "Entrepreneurship"],
               typical_gpa=3.6, website="https://uwaterloo.ca", deadline_regular="Feb 1"),

    # ── Australia ──
    University(id="usyd", name="University of Sydney", country="Australia", city="Sydney, NSW",
               acceptance_rate=0.30, ranking_qs=18, tuition_usd=44000,
               strengths=["Medicine", "Law", "Engineering", "Business"],
               typical_gpa=3.5, website="https://sydney.edu.au"),
    University(id="unimelb", name="University of Melbourne", country="Australia", city="Melbourne, VIC",
               acceptance_rate=0.28, ranking_qs=13, tuition_usd=42000,
               strengths=["Medicine", "Law", "Engineering", "Arts"],
               typical_gpa=3.5, website="https://unimelb.edu.au"),
    University(id="anu", name="Australian National University", country="Australia", city="Canberra, ACT",
               acceptance_rate=0.35, ranking_qs=30, tuition_usd=39000,
               has_merit_scholarships=True, strengths=["Politics", "International Relations", "Science"],
               typical_gpa=3.4, website="https://anu.edu.au"),

    # ── EU — Germany/Netherlands ──
    University(id="tum", name="TU Munich", country="Germany", city="Munich",
               acceptance_rate=0.25, ranking_qs=37, tuition_usd=0,
               strengths=["Engineering", "CS", "Automotive", "Robotics"],
               typical_gpa=3.5, website="https://tum.de"),
    University(id="eth", name="ETH Zurich", country="Switzerland", city="Zurich",
               acceptance_rate=0.27, ranking_qs=7, tuition_usd=1500,
               strengths=["Engineering", "Math", "Physics", "Architecture"],
               typical_gpa=3.8, website="https://ethz.ch"),
    University(id="delft", name="TU Delft", country="Netherlands", city="Delft",
               acceptance_rate=0.35, ranking_qs=47, tuition_usd=10000,
               strengths=["Aerospace", "Civil Engineering", "Industrial Design"],
               typical_gpa=3.4, website="https://tudelft.nl"),
]


class UniversityService:
    def __init__(self):
        self.universities = {u.id: u for u in UNIVERSITIES}

    def get_all(self) -> List[University]:
        return UNIVERSITIES

    def get_by_id(self, uni_id: str) -> Optional[University]:
        return self.universities.get(uni_id)

    def search(self, country: Optional[str] = None,
               max_tuition: Optional[int] = None,
               strengths: Optional[List[str]] = None) -> List[University]:
        results = UNIVERSITIES
        if country:
            results = [u for u in results if u.country.lower() == country.lower()]
        if max_tuition is not None:
            results = [u for u in results if (u.tuition_usd or 0) <= max_tuition]
        if strengths:
            results = [u for u in results
                       if any(s.lower() in [x.lower() for x in u.strengths] for s in strengths)]
        return results

    def match(self, gpa: Optional[float] = None,
              sat: Optional[int] = None,
              country: Optional[str] = None,
              budget: Optional[int] = None,
              interests: Optional[List[str]] = None) -> List[UniversityMatch]:
        matches = []
        for u in UNIVERSITIES:
            if country and u.country.lower() != country.lower():
                continue
            if budget and (u.tuition_usd or 0) > budget:
                continue

            # Calculate fit score
            score = 50.0
            reasons = []

            if gpa and u.typical_gpa:
                gpa_diff = gpa - u.typical_gpa
                if gpa_diff >= 0.1:
                    score += 15
                    reasons.append("GPA above average")
                elif gpa_diff >= -0.1:
                    score += 5
                    reasons.append("GPA competitive")
                else:
                    score -= 10
                    reasons.append("GPA below average")

            if sat and u.typical_sat:
                sat_diff = sat - u.typical_sat
                if sat_diff >= 50:
                    score += 15
                    reasons.append("SAT well above average")
                elif sat_diff >= -20:
                    score += 5
                    reasons.append("SAT competitive")
                else:
                    score -= 10
                    reasons.append("SAT below average")

            if interests:
                matched = [i for i in interests if any(i.lower() in s.lower() for s in u.strengths)]
                if matched:
                    score += min(len(matched) * 5, 20)
                    reasons.append(f"Strong in {', '.join(matched[:2])}")

            if u.has_need_based_aid:
                score += 5
                reasons.append("Need-based financial aid available")

            if u.acceptance_rate > 0.3:
                score += 5
                reasons.append("Higher acceptance rate")

            score = max(0, min(100, score))

            # Classification
            if u.acceptance_rate < 0.10:
                cls = "dream"
            elif u.acceptance_rate < 0.25:
                cls = "reach"
            elif u.acceptance_rate < 0.45:
                cls = "target"
            else:
                cls = "safety"

            if not reasons:
                reasons.append("Matches your search criteria")

            matches.append(UniversityMatch(
                university=u, fit_score=score,
                classification=cls, reasons=reasons))

        matches.sort(key=lambda m: m.fit_score, reverse=True)
        return matches


university_service = UniversityService()
