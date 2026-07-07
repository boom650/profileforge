"""
Chat Service
Handles communication between ProfileForge and Hermes via the bridge server.
Supports both synchronous and streaming chat.
"""

import uuid
import time
import json
import asyncio
from datetime import datetime
from typing import Optional, List, Dict
from pathlib import Path

import httpx

from models.chat import (
    ChatRequest, ChatResponse, ChatMessage, ConversationHistory
)

BRIDGE_URL = "http://127.0.0.1:8090"

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
