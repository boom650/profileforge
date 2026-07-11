"""Additional Backend API Tests for ProfileForge - Error paths, validation, and services"""
import pytest
import sys
import os
from unittest.mock import AsyncMock, MagicMock, patch

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))


class TestModelValidation:
    """Test Pydantic model validation edge cases"""

    def test_xp_negative_amount(self):
        from models.xp import XPTransaction
        from pydantic import ValidationError
        with pytest.raises(ValidationError):
            XPTransaction(user_id="123", amount=-50, pillar="academic", source="test")

    def test_chat_empty_message(self):
        from models.chat import ChatRequest
        chat = ChatRequest(user_id="123", message="", conversation_id="conv1")
        assert chat.message == ""

    def test_evaluation_missing_task_id(self):
        from models.evaluation import EvaluationRequest
        with pytest.raises(Exception):
            EvaluationRequest(user_id="123", text_content="essay", file_type="text")

    def test_task_valid(self):
        from models.task import TaskCreate
        task = TaskCreate(user_id="123", title="Valid Task", pillar="academic")
        assert task.title == "Valid Task"

    def test_weekly_target_valid(self):
        from models.weekly_targets import CreateWeeklyTargetRequest
        target = CreateWeeklyTargetRequest(user_id="123", title="Target", xp_reward=100)
        assert target.xp_reward == 100


class TestTaskService:
    """Test TaskService methods"""

    @pytest.mark.asyncio
    async def test_create_task(self):
        from services.tasks import TaskService
        from models.task import TaskCreate
        mock_db = AsyncMock()
        mock_db.create_task = AsyncMock(return_value={"id": "123"})
        service = TaskService(mock_db)
        task = TaskCreate(user_id="test", title="Build profile", pillar="academic")
        result = await service.create_task(task)
        assert result is not None

    @pytest.mark.asyncio
    async def test_get_user_tasks(self):
        from services.tasks import TaskService
        mock_db = AsyncMock()
        mock_db.get_user_tasks = AsyncMock(return_value=[])
        service = TaskService(mock_db)
        result = await service.get_user_tasks("test")
        assert result == []


class TestCourseService:
    """Test CourseService methods"""

    @pytest.mark.asyncio
    async def test_get_course_not_found(self):
        from services.courses import CourseService
        mock_db = AsyncMock()
        mock_cursor = AsyncMock()
        mock_cursor.fetchone = AsyncMock(return_value=None)
        mock_db.db.execute = AsyncMock(return_value=mock_cursor)
        service = CourseService(mock_db)
        result = await service.get_course("nonexistent")
        assert result is None

    @pytest.mark.asyncio
    async def test_search_courses_empty(self):
        from services.courses import CourseService
        mock_db = AsyncMock()
        mock_cursor = AsyncMock()
        mock_cursor.fetchall = AsyncMock(return_value=[])
        mock_db.db.execute = AsyncMock(return_value=mock_cursor)
        service = CourseService(mock_db)
        result = await service.search_courses("nonexistent")
        assert result == []


class TestXPService:
    """Test XPService methods"""

    @pytest.mark.asyncio
    async def test_get_xp_state_empty(self):
        from services.xp import XPService
        mock_db = AsyncMock()
        mock_cursor = AsyncMock()
        mock_cursor.fetchone = AsyncMock(return_value=None)
        mock_db.db.execute = AsyncMock(return_value=mock_cursor)
        service = XPService(mock_db)
        result = await service.get_xp_state("test")
        assert result is not None


class TestDatabaseSchema:
    """Test database schema definitions"""

    def test_database_has_tables(self):
        from services.database import Database
        db = Database()
        assert hasattr(db, 'initialize')
        assert hasattr(db, 'close')
        assert hasattr(db, 'get_user')

    def test_database_has_query_methods(self):
        from services.database import Database
        db = Database()
        methods = ['get_user', 'create_user', 'get_user_tasks', 'get_xp_state']
        missing = [m for m in methods if not hasattr(db, m)]
        assert not missing, f"Missing methods: {missing}"


class TestAPIConfig:
    """Test API configuration"""

    def test_api_config_importable(self):
        import server
        assert hasattr(server, 'app')

    def test_fastapi_app_has_routes(self):
        from server import app, API_PREFIX
        routes = [r.path for r in app.routes if hasattr(r, 'path')]
        assert f'{API_PREFIX}/health' in routes
        assert f'{API_PREFIX}/users/{{user_id}}' in routes
        assert f'{API_PREFIX}/tasks/{{user_id}}' in routes
        assert f'{API_PREFIX}/xp/{{user_id}}' in routes

    def test_fastapi_docs_url(self):
        from server import app
        assert app.docs_url == '/docs'

    def test_fastapi_redoc_url(self):
        from server import app
        assert app.redoc_url == '/redoc'


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
