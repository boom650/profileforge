"""
Chat Models
"""

from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class ChatMessage(BaseModel):
    """A single chat message"""
    role: str  # "user" or "assistant"
    content: str
    timestamp: Optional[str] = None


class ChatRequest(BaseModel):
    """Incoming chat request from the Flutter app"""
    user_id: str
    message: str
    context: Optional[str] = None  # "essay_review", "task_help", "general"
    conversation_id: Optional[str] = None  # For multi-turn conversations


class ChatResponse(BaseModel):
    """Response returned to the Flutter app"""
    message: str
    conversation_id: str
    suggestions: Optional[List[str]] = None  # Quick-reply suggestions
    action_items: Optional[List[str]] = None  # Extracted action items
    metadata: Optional[dict] = None


class ConversationHistory(BaseModel):
    """Full conversation history"""
    conversation_id: str
    user_id: str
    messages: List[ChatMessage]
    created_at: str
    updated_at: str
    context: Optional[str] = None
