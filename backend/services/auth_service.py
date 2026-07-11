from jose import jwt, JWTError
from datetime import datetime, timedelta
from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config import SECRET_KEY, ALGORITHM
from models.user import User

# Add to your existing services/database.py or a new auth_service.py
from services.database import Database 

db = Database()

security = HTTPBearer()

class AuthService:
    def create_access_token(self, data: dict, expires_delta: timedelta = timedelta(minutes=30)):
        to_encode = data.copy()
        expire = datetime.utcnow() + expires_delta
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        return encoded_jwt

    async def get_current_user(self, credentials: HTTPAuthorizationCredentials = Depends(security)) -> User:
        if credentials is None:
            raise HTTPException(status_code=401, detail="Not authenticated")
        
        token = credentials.credentials
        credentials_exception = HTTPException(
            status_code=401,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            user_id: str = payload.get("sub")
            if user_id is None:
                raise credentials_exception
        except JWTError:
            raise credentials_exception
        
        user = await db.get_user(user_id)
        if user is None:
            raise credentials_exception
        return user

auth_service = AuthService()
