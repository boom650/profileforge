"""Backend API Tests for ProfileForge"""
import pytest
import sys
import os

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Mock database BEFORE importing server
from unittest.mock import AsyncMock, MagicMock, patch

# Patch Database class to return mock instance
mock_db_instance = AsyncMock()
mock_db_instance.initialize = AsyncMock()
mock_db_instance.close = AsyncMock()
mock_db_instance.get_user = AsyncMock(return_value=None)
mock_db_instance.create_user = AsyncMock()
mock_db_instance.get_tasks = AsyncMock(return_value=[])
mock_db_instance.get_xp_state = AsyncMock(return_value={"user_id": "test", "total_xp": 0, "current_level": 1})
mock_db_instance.get_skins = AsyncMock(return_value=[])
mock_db_instance.get_conversations = AsyncMock(return_value=[])
mock_db_instance.get_weekly_targets = AsyncMock(return_value=[])
mock_db_instance.search_opportunities = AsyncMock(return_value=[])
mock_db_instance.search_courses = AsyncMock(return_value=[])
mock_db_instance.get_course_detail = AsyncMock(return_value=None)
mock_db_instance.get_user_courses = AsyncMock(return_value=[])
mock_db_instance.get_course_stats = AsyncMock(return_value={})

# Also mock the db connection
mock_db_instance.db = AsyncMock()
mock_db_instance.db.execute = AsyncMock()
mock_db_instance.db.fetch_one = AsyncMock()
mock_db_instance.db.fetch_all = AsyncMock()

# Mock other services
mock_wts = AsyncMock()
mock_wts.ensure_tables = AsyncMock()
mock_chat_service = AsyncMock()
mock_chat_service.close = AsyncMock()

# Mock Course service to match new structure
mock_course_service = AsyncMock()
mock_course_service.get_all_courses = AsyncMock(return_value=[])
mock_course_service.get_course = AsyncMock(return_value=None)
mock_course_service.search_courses = AsyncMock(return_value=[])
mock_course_service.create_course = AsyncMock()
mock_course_service.enroll_user = AsyncMock()
mock_course_service.get_user_enrollments = AsyncMock(return_value=[])

mock_xp_service = AsyncMock()
mock_xp_service.get_xp_state = AsyncMock(return_value={"user_id": "test", "total_xp": 0, "current_level": 1})


with patch('services.database.Database', return_value=mock_db_instance), \
     patch('server.weekly_targets_service', mock_wts), \
     patch('server.chat_service', mock_chat_service), \
     patch('server.course_service', mock_course_service), \
     patch('server.xp_service', mock_xp_service), \
     patch('services.ai_evaluation.AIEvaluationService', MagicMock()):
    
    from fastapi.testclient import TestClient
    from server import app, API_PREFIX
    client = TestClient(app, raise_server_exceptions=False)


class TestHealthEndpoints:
    """Test basic health endpoints"""

    def test_health_endpoint(self):
        response = client.get(f"{API_PREFIX}/health")
        assert response.status_code == 200
        assert response.json()["status"] == "healthy"


class TestEndpointExistence:
    """Test that all major endpoints exist and don't return 405 (method not allowed)"""

    def test_users_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/users/nonexistent")
        assert response.status_code != 405, f"Endpoint missing (got 405). Status: {response.status_code}"

    def test_create_user_endpoint_exists(self):
        response = client.post(f"{API_PREFIX}/users", json={})
        assert response.status_code != 405

    def test_tasks_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/tasks/test123")
        assert response.status_code != 405

    def test_tasks_pending_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/tasks/test123/pending")
        assert response.status_code != 405

    def test_xp_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/xp/test123")
        assert response.status_code != 405

    def test_skins_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/skins/test123")
        assert response.status_code != 405

    def test_chat_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/chat/conv1/history")
        assert response.status_code != 405

    def test_weekly_targets_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/weekly-targets/test123")
        assert response.status_code != 405

    def test_opportunities_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/opportunities/search?query=test")
        assert response.status_code != 405

    def test_courses_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/courses/search/test")
        assert response.status_code != 405

    def test_courses_detail_endpoint_exists(self):
        response = client.get(f"{API_PREFIX}/courses/test123")
        assert response.status_code != 405


class TestErrorHandling:
    """Test error responses"""

    def test_invalid_json(self):
        response = client.post(
            f"{API_PREFIX}/users",
            content="not json",
            headers={"Content-Type": "application/json"}
        )
        assert response.status_code == 422

    def test_method_not_allowed(self):
        response = client.patch(f"{API_PREFIX}/users/test123")
        assert response.status_code == 405


class TestModels:
    """Test Pydantic models"""

    def test_task_model(self):
        from models.task import TaskCreate
        task = TaskCreate(user_id="123", title="Test Task", pillar="academic")
        assert task.title == "Test Task"

    def test_xp_model(self):
        from models.xp import XPTransaction
        xp = XPTransaction(user_id="123", amount=100, pillar="academic", source="task")
        assert xp.amount == 100
        assert xp.pillar == "academic"

    def test_course_model(self):
        from models.course import CourseCreate
        course = CourseCreate(title="Python 101", provider="Coursera", url="https://example.com")
        assert course.title == "Python 101"

    def test_chat_model(self):
        from models.chat import ChatRequest
        chat = ChatRequest(user_id="123", message="Hello", conversation_id="conv1")
        assert chat.message == "Hello"

    def test_user_model(self):
        from models.user import UserCreate
        user = UserCreate(email="test@example.com", name="Test", grade=16)
        assert user.email == "test@example.com"
        assert user.grade == 16

    def test_evaluation_model(self):
        from models.evaluation import EvaluationRequest
        eval_req = EvaluationRequest(user_id="123", task_id="task1", text_content="Test essay", file_type="text")
        assert eval_req.text_content == "Test essay"

    def test_weekly_target_model(self):
        from models.weekly_targets import CreateWeeklyTargetRequest
        target = CreateWeeklyTargetRequest(user_id="123", title="Test Target", xp_reward=500)
        assert target.xp_reward == 500


if __name__ == "__main__":
    pytest.main([__file__, "-v"])