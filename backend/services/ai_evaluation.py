"""
AI Evaluation Service — Uses Gemini LLM for real document grading.
Replaces the heuristic scorer with actual AI intelligence.
"""

import json
from typing import Optional
from services.gemini_client import get_gemini


class AIEvaluationService:
    """Real AI-powered evaluation using Gemini LLM."""

    EVALUATION_PROMPT = """You are a college admissions evaluator for an Indian 11th-grade student named Shridhar who is building his profile for international university applications (US/UK/Canada/Australia).

Evaluate this student submission honestly and constructively.

STUDENT CONTEXT:
- Name: Shridhar Deshmukh
- Grade: 11th (Indian CBSE/ISC system)
- Goal: International college admissions (top 50 universities)
- Interests: {interests}

SUBMISSION TO EVALUATE:
Content: {content}
Task: {task_title}
{file_context}

EVALUATION CRITERIA (score each 0-100):
1. RELEVANCE: Does it address the task? Is it on-topic?
2. DEPTH: Analysis vs surface description? Original thinking?
3. STRUCTURE: Organization, flow, clarity, paragraphing?
4. EVIDENCE: Facts, data, examples, citations?
5. LANGUAGE: Grammar, vocabulary, academic tone?
6. EFFORT: Does it show genuine effort and engagement?

RESPOND IN EXACTLY THIS JSON FORMAT:
{{
  "relevance": <0-100>,
  "depth": <0-100>,
  "structure": <0-100>,
  "evidence": <0-100>,
  "language": <0-100>,
  "effort": <0-100>,
  "overall_score": <0-100>,
  "status": "approved" or "conditional" or "rejected",
  "one_liner": "<one sentence summary>",
  "top_strength": "<biggest strength>",
  "top_improvement": "<most important thing to improve>",
  "encouragement": "<personalized encouraging message>"
}}

RULES:
- Be honest but encouraging. This is a teenager building his profile.
- "approved" means overall_score >= 70
- "conditional" means 40-69 (needs revision)
- "rejected" means below 40
- If content is empty or gibberish, score 0 and reject
- The one_liner should be specific to THIS submission, not generic
- The encouragement should reference something specific they did well"""

    TASK_GENERATION_PROMPT = """You are an AI college admissions counselor for an Indian 11th-grade student named Shridhar preparing for international university applications.

Generate 5 personalized tasks for this student for the upcoming week.

STUDENT PROFILE:
- Name: Shridhar Deshmukh
- Grade: 11th (Indian CBSE/ISC)
- Location: Maharashtra, India
- Target: International universities (US/UK/Canada/Australia)
- Interests: {interests}
- Completed tasks: {completed_count} total
- Current XP: {current_xp}
- Current streak: {streak} days
- Weak pillars: {weak_pillars}
{recent_activity}

TASK REQUIREMENTS:
- Mix of: academic competitions, volunteering, research, skill-building, leadership
- Each task should be specific, actionable, and completable in 1-7 days
- Include real opportunities when possible (Olympiads, hackathons, NGO work)
- Difficulty should match student's level (challenging but achievable)
- At least 2 tasks should build the weakest pillars

RESPOND IN EXACTLY THIS JSON FORMAT:
{{
  "tasks": [
    {{
      "title": "<specific task title>",
      "description": "<2-3 sentence description of what to do>",
      "pillar": "academic" or "leadership" or "community" or "skills" or "research",
      "xp_reward": <15-50>,
      "difficulty": "easy" or "medium" or "hard",
      "deadline_days": <1-7>,
      "why": "<why this helps their college application>"
    }}
  ],
  "weekly_theme": "<overall theme for the week>",
  "motivation": "<personalized motivational message>"
}}

RULES:
- Be specific. "Join a competition" is bad. "Register for NSEJS by July 15 at ios-edu.in" is good.
- Every task must be actually doable from Maharashtra, India
- No tasks requiring expensive resources or international travel
- XP reward should match difficulty: easy=15-20, medium=25-35, hard=40-50"""

    async def evaluate_text(
        self,
        content: str,
        task_title: str = "General submission",
        task_description: str = "",
        interests: str = "technology, science, leadership",
    ) -> dict:
        """Use Gemini to evaluate a text submission."""
        if not content or len(content.strip()) < 10:
            return {
                "status": "rejected",
                "score": 0.0,
                "feedback": "Submission is too short or empty. Please submit meaningful work.",
                "details": {},
            }

        try:
            gemini = await get_gemini()
            prompt = self.EVALUATION_PROMPT.format(
                content=content,
                task_title=task_title,
                interests=interests,
                file_context="",
            )

            response = await gemini.chat(
                prompt=prompt,
                system="You are a helpful, encouraging college admissions evaluator. Always respond with valid JSON only, no markdown.",
                temperature=0.3,
                max_tokens=1024,
            )

            # Parse JSON response
            # Strip markdown code fences if present
            cleaned = response.strip()
            if cleaned.startswith("```"):
                cleaned = cleaned.split("\n", 1)[1]
            if cleaned.endswith("```"):
                cleaned = cleaned.rsplit("```", 1)[0]
            cleaned = cleaned.strip()

            result = json.loads(cleaned)

            return {
                "status": result.get("status", "conditional"),
                "score": result.get("overall_score", 50) / 100.0,
                "feedback": self._format_feedback(result),
                "details": result,
            }

        except json.JSONDecodeError:
            # Fallback: Gemini returned non-JSON, extract score heuristically
            return self._fallback_evaluate(content)
        except Exception as e:
            return {
                "status": "conditional",
                "score": 0.5,
                "feedback": f"Evaluation service temporarily unavailable. Manual review needed. Error: {str(e)[:100]}",
                "details": {},
            }

    async def evaluate_document(
        self,
        content: str,
        filename: str,
        task_title: str = "Document submission",
        interests: str = "technology, science, leadership",
    ) -> dict:
        """Use Gemini to evaluate a document upload."""
        return await self.evaluate_text(
            content=f"[Document: {filename}]\n{content}",
            task_title=task_title,
            interests=interests,
        )

    async def generate_tasks(
        self,
        interests: str = "technology, science, leadership",
        completed_count: int = 0,
        current_xp: int = 0,
        streak: int = 0,
        weak_pillars: str = "research, community",
        recent_activity: str = "",
    ) -> dict:
        """Use Gemini to generate personalized weekly tasks."""
        try:
            gemini = await get_gemini()
            prompt = self.TASK_GENERATION_PROMPT.format(
                interests=interests,
                completed_count=completed_count,
                current_xp=current_xp,
                streak=streak,
                weak_pillars=weak_pillars,
                recent_activity=recent_activity,
            )

            response = await gemini.chat(
                prompt=prompt,
                system="You are a helpful college admissions counselor. Always respond with valid JSON only, no markdown.",
                temperature=0.7,
                max_tokens=2048,
            )

            cleaned = response.strip()
            if cleaned.startswith("```"):
                cleaned = cleaned.split("\n", 1)[1]
            if cleaned.endswith("```"):
                cleaned = cleaned.rsplit("```", 1)[0]
            cleaned = cleaned.strip()

            result = json.loads(cleaned)
            return result

        except (json.JSONDecodeError, Exception) as e:
            return {
                "tasks": [],
                "weekly_theme": "Error generating tasks",
                "motivation": "The AI task generator encountered an error. Please try again later.",
                "error": str(e)[:200],
            }

    def _format_feedback(self, result: dict) -> str:
        """Format the AI evaluation result into readable feedback."""
        parts = [
            f"Score: {result.get('overall_score', 0)}/100 — {result.get('status', 'conditional').upper()}",
            "",
            result.get("one_liner", ""),
            "",
            f"Strength: {result.get('top_strength', 'Good effort')}",
            f"Improve: {result.get('top_improvement', 'Keep working')}",
            "",
            result.get("encouragement", "Keep building your profile!"),
        ]

        if "relevance" in result:
            breakdown = (
                f"Relevance: {result.get('relevance', 0)} | "
                f"Depth: {result.get('depth', 0)} | "
                f"Structure: {result.get('structure', 0)} | "
                f"Evidence: {result.get('evidence', 0)} | "
                f"Language: {result.get('language', 0)} | "
                f"Effort: {result.get('effort', 0)}"
            )
            parts.insert(1, breakdown)

        return "\n".join(parts)

    def _fallback_evaluate(self, content: str) -> dict:
        """Fallback evaluation when Gemini fails."""
        word_count = len(content.split())
        score = min(0.7, word_count / 500)
        status = "approved" if score >= 0.7 else "conditional" if score >= 0.4 else "rejected"
        return {
            "status": status,
            "score": score,
            "feedback": f"Fallback evaluation (AI unavailable). Word count: {word_count}. Status: {status.upper()}.",
            "details": {},
        }
