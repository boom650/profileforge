"""
Chat Service
Handles communication between ProfileForge and Hermes via the bridge server.
Supports both synchronous and streaming chat.
"""

import uuid
import time
import json
import asyncio
import os
from datetime import datetime
from typing import Optional, List, Dict
from pathlib import Path

import httpx

from models.chat import (
    ChatRequest, ChatResponse, ChatMessage, ConversationHistory
)

BRIDGE_URL = os.getenv("BRIDGE_URL", "http://127.0.0.1:8090")

# In-memory conversation store (lightweight; can be backed by DB later)
_conversations: Dict[str, ConversationHistory] = {}

# System prompt for the Hermes coach persona
SYSTEM_PROMPT = """You are ProfileForge Coach, an AI college admissions mentor for Indian students.
You help students build competitive profiles for top universities worldwide.

Your expertise includes:
- Research paper writing and methodology
- Competition preparation and strategy
- Essay review and narrative coaching
- Activity planning and time management
- Scholarship research and applications

Guidelines:
- Be encouraging but honest
- Give specific, actionable advice
- Reference the student's profile and goals when available
- Keep responses concise (2-4 paragraphs max) unless asked for detail
- Use bullet points for actionable steps
- When reviewing essays, focus on structure, voice, and authenticity
- For research guidance, suggest concrete next steps and resources
"""



import re

# ══════════════════════════════════════════════════════════════════════════════
# BUILT-IN RULE-BASED AI FALLBACK (works without Hermes bridge)
# ══════════════════════════════════════════════════════════════════════════════

def _builtin_response(message: str, context: str) -> dict:
    """Generate a response using rules and templates when the bridge is offline."""
    msg = message.lower().strip()
    
    # Context-specific responses
    responses = {
        "essay_review": {
            "triggers": ["essay", "common app", "coalition", "personal statement", "write", "draft", "hook", "opening"],
            "tips": [
                "Start with a specific moment or image — not a general statement about life.",
                "Show, don't tell. Instead of 'I am hardworking', describe the 5 AM study sessions.",
                "Your essay should reveal something that your grades and test scores cannot.",
                "End with how you'll contribute to the college community, not just what you'll gain.",
                "Read your essay aloud — if it sounds formal and stiff, rewrite it like you're talking to a friend."
            ]
        },
        "task_help": {
            "triggers": ["mission", "task", "activity", "complete", "finish", "target", "deadline"],
            "tips": [
                "Break big tasks into small 15-minute chunks. Progress beats perfection.",
                "Start with the easiest item to build momentum, then tackle the harder ones.",
                "Use the Pomodoro technique: 25 min focused work, 5 min break.",
                "Track your progress daily — seeing small wins builds motivation.",
                "If stuck on a task for more than 20 minutes, move on and come back later."
            ]
        },
        "research_guidance": {
            "triggers": ["research", "paper", "experiment", "methodology", "literature", "hypothesis"],
            "tips": [
                "Start with 3-5 peer-reviewed papers on your topic. Use Google Scholar.",
                "Your hypothesis should be testable and specific, not vague.",
                "Document everything from day one — lab notebooks save you later.",
                "Present your research at school science fairs before going to bigger competitions.",
                "Connect your research to real-world problems — judges love practical applications."
            ]
        },
        "competition_prep": {
            "triggers": ["competition", "olympiad", "exam", "test", "prepare", "study", "practice"],
            "tips": [
                "Solve past year papers under timed conditions — the real exam is about time management.",
                "Focus on your weak areas, not your strengths. 80/20 rule: 80% of marks come from 20% of topics.",
                "Join study groups — teaching others is the fastest way to learn.",
                "For Olympiads, focus on conceptual understanding, not rote memorization.",
                "Take care of your health during exam season: sleep, exercise, and proper nutrition."
            ]
        },
        "general": {
            "triggers": ["college", "university", "admission", "application", "scholarship", "career", "future"],
            "tips": [
                "Start researching colleges now — don't wait until 12th grade.",
                "Build a balanced college list: 2-3 reach, 3-4 match, 2-3 safety schools.",
                "Extracurriculars matter more than you think — depth beats breadth.",
                "Apply for every scholarship you qualify for — even small ones add up.",
                "Your college essay is your chance to show who you really are beyond grades."
            ]
        }
    }
    
    # Find matching context
    best_match = None
    best_score = 0
    for ctx_key, ctx_data in responses.items():
        score = sum(1 for trigger in ctx_data["triggers"] if trigger in msg)
        if score > best_score:
            best_score = score
            best_match = ctx_key
    
    if not best_match:
        best_match = context if context in responses else "general"
    
    # Pick a tip based on message hash for variety
    tips = responses[best_match]["tips"]
    tip_idx = hash(msg) % len(tips)
    selected_tip = tips[tip_idx]
    
    # Build response
    context_labels = {
        "essay_review": "📝 Essay Writing",
        "task_help": "🎯 Task Planning",
        "research_guidance": "🔬 Research",
        "competition_prep": "🏆 Competition Prep",
        "general": "🎓 College Admissions"
    }
    
    label = context_labels.get(best_match, "🎓 College Admissions")
    
    response_text = f"**{label}**\n\n{selected_tip}\n\n"
    
    # Add a follow-up suggestion
    follow_ups = {
        "essay_review": "Would you like me to review a specific part of your essay?",
        "task_help": "Need help breaking down a specific task into steps?",
        "research_guidance": "Want help designing your research methodology?",
        "competition_prep": "Looking for study strategies for a specific subject?",
        "general": "Want advice on a specific aspect of your college application?"
    }
    response_text += follow_ups.get(best_match, "What else would you like help with?")
    
    suggestions = [
        "How do I start my college essay?",
        "What activities should I focus on?",
        "Help me plan my week",
        "Tell me about Indian student scholarships"
    ]
    
    return {
        "response": response_text,
        "suggestions": suggestions,
        "action_items": []
    }


class ChatService:
    def __init__(self):
        self.client = httpx.AsyncClient(timeout=30.0)

    async def send_message(self, request: ChatRequest) -> ChatResponse:
        """Send a message to Hermes via bridge and get response."""
        conv_id = request.conversation_id or str(uuid.uuid4())[:12]

        # Build conversation history
        history = _conversations.get(conv_id)
        if not history:
            history = ConversationHistory(
                conversation_id=conv_id,
                user_id=request.user_id,
                messages=[],
                created_at=datetime.now().isoformat(),
                updated_at=datetime.now().isoformat(),
                context=request.context,
            )
            _conversations[conv_id] = history

        # Add user message
        user_msg = ChatMessage(
            role="user",
            content=request.message,
            timestamp=datetime.now().isoformat(),
        )
        history.messages.append(user_msg)

        # Build messages payload for bridge
        messages = [{"role": "system", "content": SYSTEM_PROMPT}]

        # Add context hint
        context_hint = _get_context_hint(request.context)
        if context_hint:
            messages.append({"role": "system", "content": context_hint})

        # Add conversation history (last 20 messages to stay within context)
        for msg in history.messages[-20:]:
            messages.append({"role": msg.role, "content": msg.content})

        # Forward to Hermes bridge
        try:
            response = await self._call_bridge_chat(messages, conv_id)
            assistant_text = response.get("response", "I'm having trouble connecting right now. Please try again.")
            suggestions = response.get("suggestions", [])
            action_items = response.get("action_items", [])
        except Exception as e:
            # Try built-in fallback when bridge is offline
            try:
                fb = _builtin_response(request.message, request.context or "general")
                assistant_text = fb["response"]
                suggestions = fb.get("suggestions", [])
                action_items = fb.get("action_items", [])
            except Exception:
                assistant_text = f"⚠️ Connection error: {str(e)}. The Hermes agent might be offline. Please try again in a moment."
                suggestions = []
                action_items = []

        # Store assistant response
        assistant_msg = ChatMessage(
            role="assistant",
            content=assistant_text,
            timestamp=datetime.now().isoformat(),
        )
        history.messages.append(assistant_msg)
        history.updated_at = datetime.now().isoformat()

        return ChatResponse(
            message=assistant_text,
            conversation_id=conv_id,
            suggestions=suggestions,
            action_items=action_items,
            metadata={"message_count": len(history.messages)},
        )

    async def _call_bridge_chat(self, messages: List[dict], conversation_id: str) -> dict:
        """Forward chat to Hermes via bridge server."""
        payload = {
            "messages": messages,
            "conversation_id": conversation_id,
            "stream": False,
        }

        resp = await self.client.post(
            f"{BRIDGE_URL}/chat",
            json=payload,
        )
        resp.raise_for_status()
        return resp.json()

    async def get_conversation_history(self, conversation_id: str) -> Optional[ConversationHistory]:
        """Get full conversation history."""
        return _conversations.get(conversation_id)

    async def list_conversations(self, user_id: str) -> List[dict]:
        """List all conversations for a user."""
        results = []
        for conv in _conversations.values():
            if conv.user_id == user_id:
                results.append({
                    "conversation_id": conv.conversation_id,
                    "context": conv.context,
                    "message_count": len(conv.messages),
                    "created_at": conv.created_at,
                    "updated_at": conv.updated_at,
                    "last_message": conv.messages[-1].content[:100] if conv.messages else "",
                })
        return sorted(results, key=lambda x: x["updated_at"], reverse=True)

    async def close(self):
        """Cleanup HTTP client."""
        await self.client.aclose()


def _get_context_hint(context: Optional[str]) -> str:
    """Build a context-specific system hint for the LLM."""
    hints = {
        "essay_review": (
            "CONTEXT: The student is asking about essay writing or has submitted an essay for review. "
            "Focus on narrative structure, authenticity, voice, and Common App requirements. "
            "Check word count (250-650), narrative arc, and specific details."
        ),
        "task_help": (
            "CONTEXT: The student needs help completing a specific task from their ProfileForge dashboard. "
            "Provide step-by-step guidance, suggest resources, and help them plan."
        ),
        "research_guidance": (
            "CONTEXT: The student is working on a research paper or project. "
            "Help with methodology, literature review, writing structure, and publication strategy. "
            "Suggest relevant conferences and journals for Indian students."
        ),
        "competition_prep": (
            "CONTEXT: The student is preparing for an academic competition or Olympiad. "
            "Help with study plans, practice strategies, and time management."
        ),
        "general": "",
    }
    return hints.get(context, "")


# Singleton
chat_service = ChatService()
