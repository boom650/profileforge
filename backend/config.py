"""
ProfileForge Backend Server Config
Handles all environment-specific settings.
"""
import os
from dotenv import load_dotenv

load_dotenv()

# API URLs
API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8080")
BRIDGE_URL = os.getenv("BRIDGE_URL", "http://127.0.0.1:8090")

# Database
DATABASE_URL = os.getenv("DATABASE_URL", "profileforge.db")

# Security
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    import warnings
    warnings.warn("SECRET_KEY is not set! Using a generated key. Set SECRET_KEY in your .env file.", UserWarning, stacklevel=2)
    import secrets
    SECRET_KEY = secrets.token_hex(32)

ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
