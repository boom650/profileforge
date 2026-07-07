"""
Scholarships Database — Real scholarships for Indian students
Covers: India-based, US, UK, Canada, Australia, EU
"""

from typing import Optional, List
from pydantic import BaseModel


class Scholarship(BaseModel):
    id: str
    name: str
    country: str
    provider: str
    amount_usd: Optional[int] = None  # in USD
    amount_inr: Optional[int] = None  # in INR
    coverage: str  # "full", "partial", "living_expenses", "tuition_only"
    eligibility: str
    deadline: str  # YYYY-MM-DD or "Rolling"
    website: str
    description: str
    requirements: List[str] = []
    tips: List[str] = []


SCHOLARSHIPS = [
    # ════════════════════════════════════════════════════════════════════════
    # INDIA-BASED SCHOLARSHIPS
    # ════════════════════════════════════════════════════════════════════════
    Scholarship(
        id="inspire_she", name="INSPIRE Scholarship (SHE)", country="India",
        provider="Department of Science & Technology, GoI",
        amount_inr=80000, coverage="tuition_only",
        eligibility="Top 1% of Class 12 board exams OR KVPY/NTSE scholars. Age ≤27, pursuing BSc/BS/Int.MSc.",
        deadline="2025-09-30",
        website="https://www.online-inspire.gov.in/",
        description="₹80,000/year for 5 years for top science students pursuing bachelor's in natural/basic sciences.",
        requirements=["Top 1% board exam rank or KVPY/NTSE qualification", "Enrolled in BSc/BS/Integrated MSc", "Age below 27"],
        tips=["Apply through INSPIRE portal — only online applications accepted", "Carry board exam marksheet showing top 1% rank", "Renewable for 5 years if maintaining good academic performance"],
    ),
    Scholarship(
        id="kvpy_fellowship", name="KVPY Fellowship", country="India",
        provider="Department of Science & Technology",
        amount_inr=84000, coverage="tuition_only",
        eligibility="Class 11/12 students selected through KVPY aptitude test + interview",
        deadline="2025-11-15", website="https://www.kvpy.iisc.ac.in/",
        description="₹84,000/year fellowship for science research. Monthly contingency grant of ₹28,000 for PhD scholars.",
        requirements=["KVPY SA/SX/SB stream qualification", "Strong aptitude in science and math"],
        tips=["Start preparation in Class 10 for SA stream", "Focus on conceptual understanding, not rote learning", "Practice previous year KVPY papers extensively"],
    ),
    Scholarship(
        id="ntse", name="NTSE Scholarship", country="India",
        provider="NCERT, Ministry of Education",
        amount_inr=36000, coverage="living_expenses",
        eligibility="Class 10 students, state-level selection followed by national exam",
        deadline="2025-12-31", website="https://ncert.nic.in/scholarship.php",
        description="₹2,000/month for Class 11-12, ₹2,500/month for UG/PG, ₹3,000/month for PhD. Renewable throughout studies.",
        requirements=["State-level NTSE qualification", "Class 10 enrollment"],
        tips=["Apply through your school — individual applications not accepted", "Mental Ability Test (MAT) is where most students lose marks", "Start preparation early in Class 9"],
    ),
    Scholarship(
        id="tata_scholars", name="Tata Scholarships for Cornell", country="India",
        provider="Tata Education and Development Trust",
        amount_inr=5000000, coverage="full",
        eligibility="Indian students admitted to Cornell University, demonstrated financial need",
        deadline="Rolling (apply with FAFSA)",
        website="https://finaid.cornell.edu/types/tata",
        description="Full cost of attendance at Cornell for ~20 Indian students per year. Covers tuition, room, board, books.",
        requirements=["Admitted to Cornell University", "Indian citizenship", "Financial need (family income < ₹8 lakh)"],
        tips=["Apply to Cornell Regular Decision for best chances", "Write a strong 'Why Cornell?' essay", "Mention your financial background honestly in CSS Profile"],
    ),
    Scholarship(
        id="agha_khan", name="Aga Khan Foundation International Scholarship", country="India",
        provider="Aga Khan Foundation",
        amount_inr=2000000, coverage="full",
        eligibility="Students from developing countries, admitted to top universities, demonstrated financial need",
        deadline="2025-03-31", website="https://www.akdn.org/our-agencies/aga-khan-foundation",
        description="50% grant + 50% loan. Covers tuition and living expenses at top graduate programs worldwide.",
        requirements=["Admission to recognized graduate program", "Financial need", "Strong academic record"],
        tips=["Apply before admission deadline — early applications preferred", "The loan portion has very low interest rates", "Show how your education will benefit your community"],
    ),

    # ════════════════════════════════════════════════════════════════════════
    # US SCHOLARSHIPS
    # ════════════════════════════════════════════════════════════════════════
    Scholarship(
        id="mit_isa", name="MIT India Scholarship (ISA)", country="US",
        provider="MIT Office of Financial Aid",
        amount_usd=80000, coverage="full",
        eligibility="Indian students admitted to MIT, need-based. No separate application.",
        deadline="Rolling (with admission application)",
        website="https://sfs.mit.edu/undergraduate-students/types-of-aid/scholarships-grants/",
        description="MIT meets 100% of demonstrated financial need for all admitted students, including internationals.",
        requirements=["Admitted to MIT", "Demonstrated financial need via CSS Profile/IDOC"],
        tips=["MIT is need-blind for internationals — apply even if you think you can't afford it", "CSS Profile must be submitted by February deadline", "No separate scholarship application needed"],
    ),
    Scholarship(
        id="stanford_lank", name="Stanford Leland Scholars Program", country="US",
        provider="Stanford University",
        amount_usd=85000, coverage="full",
        eligibility="Students admitted to Stanford with financial need",
        deadline="Rolling", website="https://financialaid.stanford.edu/undergrad/how/index.html",
        description="Stanford commits to meeting 100% of demonstrated need. Average aid package ~$65,000/year.",
        requirements=["Admitted to Stanford", "CSS Profile and FAFSA submitted", "Financial need demonstrated"],
        tips=["Stanford is need-blind — apply regardless of finances", "The supplemental essays matter a lot for financial aid consideration"],
    ),
    Scholarship(
        id="fulbright", name="Fulbright-Nehru Fellowship", country="US",
        provider="USIEF / Fulbright Commission",
        amount_usd=70000, coverage="full",
        eligibility="Indian professionals/students for Master's at US universities",
        deadline="2025-06-30", website="https://usief.org.in/Fellowships-Grants-Fulbright-Nehru-Fellowships.aspx",
        description="Full funding for Master's at US: tuition, living, travel, health insurance, book allowance.",
        requirements=["Indian citizenship", "Bachelor's degree", "3+ years work experience preferred", "Strong leadership potential"],
        tips=["Start application 8-10 months in advance", "Write about how your US education will benefit India", "Get strong recommendation letters from Indian academics"],
    ),

    # ════════════════════════════════════════════════════════════════════════
    # UK SCHOLARSHIPS
    # ════════════════════════════════════════════════════════════════════════
    Scholarship(
        id="chevening", name="Chevening Scholarship", country="UK",
        provider="UK Government (FCDO)",
        amount_usd=60000, coverage="full",
        eligibility="Professionals with 2+ years experience, return to home country after studies",
        deadline="2025-11-01", website="https://www.chevening.org/",
        description="Full Master's funding at any UK university: tuition, monthly stipend, travel, visa costs.",
        requirements=["2+ years work experience", "Return to home country for 2 years post-study", "Strong leadership and networking skills"],
        tips=["Write 4 leadership essays — each must be specific and evidence-based", "Chevening values community impact over personal achievement", "Apply to 3 UK universities in your application"],
    ),
    Scholarship(
        id="rhodes_india", name="Rhodes Scholarship (India)", country="UK",
        provider="Rhodes Trust / Cecil Rhodes",
        amount_usd=75000, coverage="full",
        eligibility="Indian students with outstanding academic and leadership record, admitted to Oxford",
        deadline="2025-08-01", website="https://www.rhodeshouse.ox.ac.uk/scholarships/the-rhodes-scholarship/",
        description="Full funding for 2-3 years at Oxford: tuition, personal stipend, travel, health insurance.",
        requirements=["Age 19-27 on Oct 1 of selection year", "Bachelor's degree with First Class", "Exceptional leadership and service record"],
        tips=["The interview is the most critical part — prepare extensively", "Rhodes looks for 'whole person' — sports, arts, activism matter", "India has 5 Rhodes spots per year — competition is fierce"],
    ),
    Scholarship(
        id="gates_cambridge", name="Gates Cambridge Scholarship", country="UK",
        provider="Bill & Melinda Gates Foundation",
        amount_usd=70000, coverage="full",
        eligibility="Outstanding postgraduate students from outside UK, admitted to Cambridge",
        deadline="2025-12-03", website="https://www.gatescambridge.org/",
        description="Full cost of study at Cambridge: tuition, maintenance, travel, development funding.",
        requirements=["Admitted to Cambridge postgraduate program", "Outstanding intellectual ability", "Leadership and commitment to improving lives of others"],
        tips=["Apply through the Cambridge graduate application portal", "Gates values social impact and global perspective", "Strong research proposal boosts chances significantly"],
    ),

    # ════════════════════════════════════════════════════════════════════════
    # CANADA, AUSTRALIA, EU
    # ════════════════════════════════════════════════════════════════════════
    Scholarship(
        id="utoronto Lester", name="University of Toronto Lester B. Pearson", country="Canada",
        provider="University of Toronto",
        amount_usd=65000, coverage="full",
        eligibility="Outstanding international students admitted to UofT, nominated by school",
        deadline="2025-11-07", website="https://future.utoronto.ca/pearson/",
        description="Full tuition + living for 4 years. 37 scholarships awarded globally per year.",
        requirements=["Nominated by school", "Exceptional academic achievement", "Community impact and leadership"],
        tips=["Your school must nominate you — talk to your counselor early", "Write about how you'll use your degree to impact your community", "UofT is one of the top universities in Canada — strong applications"],
    ),
    Scholarship(
        id="melbourne_chancellor", name="Melbourne Chancellor's Scholarship", country="Australia",
        provider="University of Melbourne",
        amount_usd=50000, coverage="tuition_only",
        eligibility="High-achieving international students entering University of Melbourne",
        deadline="2025-10-31", website="https://scholarships.unimelb.edu.au/",
        description="25-100% tuition remission for up to 5 years. Based on academic merit.",
        requirements=["Outstanding academic record", "Admitted to University of Melbourne undergraduate program"],
        tips=["No separate application needed — automatically considered", "Achieve highest possible ATAR or equivalent", "University of Melbourne is consistently ranked #1 in Australia"],
    ),
    Scholarship(
        id="eth_excellence", name="ETH Zurich Excellence Scholarship", country="Switzerland",
        provider="ETH Zurich",
        amount_usd=75000, coverage="full",
        eligibility="Outstanding Master's students at ETH Zurich",
        deadline="2025-12-15", website="https://ethz.ch/students/en/studies/financial/scholarships/excellence-scholarship.html",
        description="Covers full study and living costs for entire Master's program. CHF 12,000/semester + tuition waiver.",
        requirements=["Outstanding academic record (top 5%)", "Admitted to ETH Master's program", "Strong reference letters"],
        tips=["ETH is one of Europe's best universities — focus on STEM", "Apply directly through ETH admissions — no separate scholarship app", "ETH has low tuition even without scholarship (~CHF 730/semester)"],
    ),
]


class ScholarshipService:
    def __init__(self):
        self.scholarships = {s.id: s for s in SCHOLARSHIPS}

    def get_all(self, country: Optional[str] = None) -> List[Scholarship]:
        if country:
            return [s for s in SCHOLARSHIPS if s.country.lower() == country.lower()]
        return SCHOLARSHIPS

    def get_by_id(self, scholarship_id: str) -> Optional[Scholarship]:
        return self.scholarships.get(scholarship_id)

    def search(self, query: str) -> List[Scholarship]:
        q = query.lower()
        return [s for s in SCHOLARSHIPS
                if q in s.name.lower() or q in s.country.lower()
                or q in s.description.lower() or q in s.provider.lower()]

    def get_for_indian_student(self) -> List[dict]:
        """Get scholarships specifically relevant to Indian students"""
        india_relevant = [s for s in SCHOLARSHIPS
                          if s.country == "India" or s.country in ["US", "UK", "Canada", "Australia", "Switzerland"]]
        return [
            {
                "id": s.id,
                "name": s.name,
                "country": s.country,
                "amount": f"${s.amount_usd:,}/yr" if s.amount_usd else f"₹{s.amount_inr:,}/yr",
                "coverage": s.coverage,
                "deadline": s.deadline,
                "eligibility": s.eligibility,
                "tips": s.tips,
            }
            for s in india_relevant
        ]


scholarship_service = ScholarshipService()
