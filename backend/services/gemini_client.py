"""
Gemini LLM Client — OAuth-based access to Gemini API.
Uses the Gemini CLI's OAuth refresh token for authentication.
"""

import json
import httpx
import os
import time
from typing import Optional

# Gemini CLI OAuth credentials
CREDS_PATH = os.path.expanduser("~/.gemini/oauth_creds.json")
PROJECTS_PATH = os.path.expanduser("~/.gemini/projects.json")

# Google OAuth endpoints
TOKEN_URL = "https://oauth2.googleapis.com/token"
# Gemini API endpoint (OpenAI-compatible)
GEMINI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai"


class GeminiClient:
    """Gemini API client using OAuth refresh token from Gemini CLI."""
    
    def __init__(self):
        self._access_token: Optional[str] = None
        self._token_expiry: float = 0
        self._http = httpx.AsyncClient(timeout=60)
    
    async def _load_credentials(self):
        """Load OAuth credentials from Gemini CLI."""
        with open(CREDS_PATH) as f:
            creds = json.load(f)
        return creds["client_id"], creds["client_secret"], creds["refresh_token"]
    
    async def _refresh_token(self):
        """Refresh the access token using the refresh token."""
        client_id, client_secret, refresh_token = await self._load_credentials()
        
        resp = await self._http.post(TOKEN_URL, data={
            "grant_type": "refresh_token",
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token,
        })
        resp.raise_for_status()
        data = resp.json()
        self._access_token = data["access_token"]
        self._token_expiry = time.time() + data.get("expires_in", 3600) - 60
    
    async def _get_token(self) -> str:
        """Get a valid access token, refreshing if needed."""
        if not self._access_token or time.time() >= self._token_expiry:
            await self._refresh_token()
        return self._access_token or ""
    
    async def chat(
        self,
        prompt: str,
        system: str = "",
        model: str = "gemini-2.5-flash",
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> str:
        """Send a chat completion request to Gemini API."""
        token = await self._get_token()
        
        messages = []
        if system:
            messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})
        
        resp = await self._http.post(
            f"{GEMINI_BASE_URL}/chat/completions",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json",
            },
            json={
                "model": model,
                "messages": messages,
                "temperature": temperature,
                "max_tokens": max_tokens,
            },
        )
        resp.raise_for_status()
        data = resp.json()
        return data["choices"][0]["message"]["content"]
    
    async def close(self):
        await self._http.aclose()


# Singleton
_client: Optional[GeminiClient] = None


async def get_gemini() -> GeminiClient:
    """Get or create the Gemini client singleton."""
    global _client
    if _client is None:
        _client = GeminiClient()
    return _client
