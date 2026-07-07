"""
Essay Prompts Database — Common App, UC, UK Personal Statement
Real prompts with tips specific to Indian students
"""

from typing import Optional, List
from pydantic import BaseModel


class EssayPrompt(BaseModel):
    id: str
    platform: str  # "common_app", "uc", "uk_personal_statement", "scholarship"
    number: int
    text: str
    word_limit: int
    tips: List[str] = []
    indian_student_tips: List[str] = []
    examples_of_good_hooks: List[str] = []
    common_mistakes: List[str] = []


ESSAY_PROMPTS = [
    # ── COMMON APP 2024-2025 ──
    EssayPrompt(
        id="common_1", platform="common_app", number=1,
        text="Some students have a background, identity, interest, or talent that is so meaningful they believe their application would be incomplete without it. If this sounds like you, then please share your story.",
        word_limit=650,
        tips=[
            "This is the MOST versatile prompt — pick this if you're unsure",
            "Focus on ONE specific aspect of your identity, not a list",
            "Show transformation: how did this shape who you are today?",
        ],
        indian_student_tips=[
            "Being Indian IS your background — but go deeper: your specific community, language, food, festivals",
            "Don't just say 'I'm from Mumbai' — describe the monsoon, the vada pav stall, the local train chaos",
            "Cultural identity stories work when you show tension between two worlds",
        ],
        examples_of_good_hooks=[
            "The smell of cardamom and burnt sugar from my grandmother's kitchen...",
            "At 3 AM, the only sounds are my keyboard and my mother's prayers next door...",
            "The first time I explained 'jugaad' to my American teacher, she gave me a zero...",
        ],
        common_mistakes=[
            "Listing achievements instead of telling a story",
            "Being too generic ('I am a hard-working student')",
            "Trying to impress with vocabulary instead of being authentic",
        ],
    ),
    EssayPrompt(
        id="common_2", platform="common_app", number=2,
        text="The lessons we take from obstacles we encounter can be fundamental to later success. Recount a time when you faced a challenge, setback, or failure. How did it affect you, and what did you learn from the experience?",
        word_limit=650,
        tips=[
            "Pick a REAL challenge, not a humble brag",
            "Spend 70% on the LESSON, 30% on the challenge",
            "Show vulnerability — admissions officers are human too",
        ],
        indian_student_tips=[
            "JEE/NEET failure stories are OVERDONE — pick something unique",
            "Moving cities, language barriers, family financial struggles can be powerful",
            "Don't write about 'failure' — write about what you BUILT from the rubble",
        ],
        examples_of_good_hooks=[
            "I failed my first coding competition so badly that the judge asked if I was in the right room...",
            "The day my father's shop closed, I learned what 'starting over' really means...",
        ],
        common_mistakes=[
            "Turning it into a 'secret success' story",
            "Blaming others for the failure",
            "Not showing genuine reflection",
        ],
    ),
    EssayPrompt(
        id="common_3", platform="common_app", number=3,
        text="Reflect on a time when you questioned or challenged a belief or idea. What prompted your thinking? What was the outcome?",
        word_limit=650,
        tips=[
            "This prompt values INTELLECTUAL CURIOSITY",
            "The 'belief' doesn't have to be big — personal beliefs count too",
            "Show that you think critically, not just rebel for the sake of it",
        ],
        indian_student_tips=[
            "Challenging caste/gender norms in your community can be powerful",
            "Questioning 'why do we have to study this?' and finding your own path",
            "The tension between traditional expectations and modern values",
        ],
        examples_of_good_hooks=[
            "When my teacher said 'girls don't do science,' I built a robot to prove her wrong...",
            "I questioned why our village festival excluded widows — and changed 200 years of tradition...",
        ],
        common_mistakes=[
            "Being preachy or self-righteous",
            "Picking a controversial political topic without nuance",
            "Not showing genuine growth in your thinking",
        ],
    ),
    EssayPrompt(
        id="common_4", platform="common_app", number=4,
        text="Reflect on something that someone has done for you that has made you happy or thankful in a surprising way. How has this gratitude affected or motivated you?",
        word_limit=650,
        tips=[
            "Focus on a SPECIFIC person and moment",
            "The 'surprising' element is key — show an unexpected source of gratitude",
            "Connect it to how you now help others",
        ],
        indian_student_tips=[
            "A chai wallah who remembered your order, a stranger who helped in an auto",
            "Teachers who went beyond the syllabus, parents who sacrificed without telling you",
            "The daily helpers — housekeeping, security guards — whose kindness we overlook",
        ],
        examples_of_good_hooks=[
            "The night before my board exam, my housekeeper left a handwritten note in my lunchbox...",
            "Mr. Sharma never taught me physics. He taught me how to fail and get back up...",
        ],
        common_mistakes=[
            "Being too generic ('my parents support me')",
            "Not showing how the gratitude changed your behavior",
            "Making it about yourself instead of the other person",
        ],
    ),
    EssayPrompt(
        id="common_5", platform="common_app", number=5,
        text="Discuss an accomplishment, event, or realization that sparked a period of personal growth and a new understanding of yourself or others.",
        word_limit=650,
        tips=[
            "The KEY word is 'growth' — show BEFORE and AFTER",
            "A 'realization' is often more powerful than an event",
            "Show how your self-understanding deepened",
        ],
        indian_student_tips=[
            "First-generation college student realizing the power of education",
            "Winning a competition and understanding what 'merit' really means",
            "Traveling outside your city/state and seeing a different India",
        ],
        examples_of_good_hooks=[
            "I always thought poverty was about money. Then I met the richest family in the poorest village...",
            "The day I won the state science fair, I realized I'd been doing it for my parents, not for me...",
        ],
        common_mistakes=[
            "Picking an accomplishment without showing growth",
            "Being superficial about the 'new understanding'",
            "Not connecting the growth to your future goals",
        ],
    ),
    EssayPrompt(
        id="common_6", platform="common_app", number=6,
        text="Describe a topic, idea, or concept you find so engaging that it makes you lose all track of time. Why does it captivate you? What or who do you turn to when you want to learn more?",
        word_limit=650,
        tips=[
            "This is the 'intellectual vitality' prompt — show your passion",
            "Describe the TOPIC, not just your interest in it",
            "Show how you go deeper: books, videos, experiments, mentors",
        ],
        indian_student_tips=[
            "Jugaad innovation, jugaad engineering — it's uniquely Indian and fascinating",
            "Indian classical music/raga theory, temple architecture mathematics",
            "Vedic mathematics, Indian chess (chaturanga) history",
        ],
        examples_of_good_hooks=[
            "The Fibonacci sequence appears in sunflower heads, in temple carvings, and in the way I organize my code...",
            "I spent 47 hours debugging one bug. It was the most satisfying 47 hours of my life...",
        ],
        common_mistakes=[
            "Being vague about what specifically captivates you",
            "Not showing the depth of your exploration",
            "Forgetting to mention who you learn from",
        ],
    ),
    EssayPrompt(
        id="common_7", platform="common_app", number=7,
        text="Share an essay on any topic of your choice. It can be one you've already written, one that responds to a different prompt, or one of your own design.",
        word_limit=650,
        tips=[
            "This is the FLEX prompt — only pick if other prompts don't fit",
            "Use this for a story that doesn't fit the other categories",
            "Even though it's 'any topic,' it still needs structure and reflection",
        ],
        indian_student_tips=[
            "Write in Hinglish if it's authentic to your voice",
            "Tell a story ONLY an Indian student could tell",
            "This is your chance to be truly creative — don't waste it on something safe",
        ],
        examples_of_good_hooks=[
            "My grandmother sends me WhatsApp forwards every morning. Last Tuesday, one of them changed my life...",
            "The argument between my parents about my education lasted 47 minutes. I timed it...",
        ],
        common_mistakes=[
            "Using this as a 'safe' option when another prompt would work better",
            "Writing something too unconventional without substance",
            "Not having a clear narrative arc",
        ],
    ),
    # ── UK PERSONAL STATEMENT ──
    EssayPrompt(
        id="uk_ps_1", platform="uk_personal_statement", number=1,
        text="Why do you want to study this course? What skills and experience do you have?",
        word_limit=4000,
        tips=[
            "UK statements are ACADEMIC — focus on your subject, not personal life",
            "Show you've read beyond the syllabus",
            "Mention specific topics you want to explore at university level",
        ],
        indian_student_tips=[
            "Mention specific Indian context: problems in your field that India faces",
            "Reference Indian researchers, Indian case studies, Indian contributions",
            "Show how your background gives you a unique perspective on the subject",
        ],
        examples_of_good_hooks=[
            "The 2016 Indian demonetization crisis sparked my fascination with economic policy...",
            "Watching my grandfather's farm fail due to erratic monsoons made me want to study climate science...",
        ],
        common_mistakes=[
            "Being too personal (UK statement ≠ US essay)",
            "Not mentioning the specific course/subject",
            "Using the same statement for multiple universities without customization",
        ],
    ),
]


class EssayService:
    def __init__(self):
        self.prompts = {p.id: p for p in ESSAY_PROMPTS}

    def get_all(self, platform: Optional[str] = None) -> List[EssayPrompt]:
        if platform:
            return [p for p in ESSAY_PROMPTS if p.platform == platform]
        return ESSAY_PROMPTS

    def get_by_id(self, prompt_id: str) -> Optional[EssayPrompt]:
        return self.prompts.get(prompt_id)

    def get_for_indian_student(self, platform: str = "common_app") -> List[dict]:
        """Get prompts with enhanced Indian student tips"""
        prompts = [p for p in ESSAY_PROMPTS if p.platform == platform]
        return [
            {
                "prompt_number": p.number,
                "text": p.text,
                "word_limit": p.word_limit,
                "general_tips": p.tips,
                "indian_student_tips": p.indian_student_tips,
                "good_hooks": p.examples_of_good_hooks,
                "common_mistakes": p.common_mistakes,
            }
            for p in prompts
        ]


essay_service = EssayService()
