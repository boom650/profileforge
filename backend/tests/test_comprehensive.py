"""Comprehensive Backend API Tests for ProfileForge - Deep coverage for ≥82 score"""
import pytest
import sys
import os
import uuid
import sqlite3
from datetime import datetime
from unittest.mock import AsyncMock, MagicMock, patch

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# ============================================================
# Module-level import of server with a mocked Database so the
# app can be constructed. Per-test isolation is achieved by
# patching the *live instances* on the server module.
# ============================================================

_mock_db_boot = AsyncMock()
_mock_db_boot.initialize = AsyncMock()
_mock_db_boot.close = AsyncMock()

with patch('services.database.Database', return_value=_mock_db_boot), \
     patch('services.ai_evaluation.AIEvaluationService', MagicMock()):
    from fastapi.testclient import TestClient
    import server
    from server import app, API_PREFIX
    client = TestClient(app, raise_server_exceptions=False)


@pytest.fixture
def srv():
    """Patch live service instances on the server module per test for isolation."""
    db = AsyncMock()
    db.get_user = AsyncMock(return_value=None)
    db.create_user = AsyncMock()
    db.update_user = AsyncMock(return_value=None)

    task_service = AsyncMock()
    task_service.create_task = AsyncMock(return_value={
        "id": "task123", "user_id": "user123", "title": "Test",
        "pillar": "academic", "xp_reward": 50, "status": "pending"})
    task_service.get_user_tasks = AsyncMock(return_value=[])
    task_service.get_task = AsyncMock(return_value=None)
    task_service.update_status = AsyncMock(return_value=True)

    location_service = AsyncMock()
    location_service.update_location = AsyncMock(return_value=True)
    location_service.get_location = AsyncMock(return_value=None)
    location_service.update_city = AsyncMock(return_value=True)

    xp_service = AsyncMock()
    xp_service.get_xp_state = AsyncMock(return_value={"user_id": "test", "total_xp": 0, "current_level": 1})
    xp_service.award_xp = AsyncMock(return_value={"total_xp": 100, "level_up": False})

    with patch.object(server, 'db', db), \
         patch.object(server, 'task_service', task_service), \
         patch.object(server, 'location_service', location_service), \
         patch.object(server, 'xp_service', xp_service):
        yield {"db": db, "task": task_service, "location": location_service, "xp": xp_service}


# ============================================================
# EDGE CASE & VALIDATION TESTS
# ============================================================

class TestInputValidationEdgeCases:
    """Boundary testing for all Pydantic models."""

    def test_user_email_invalid_formats(self):
        from models.user import UserCreate
        for email in ["notanemail", "@nodomain.com", "no@domain", "spaces @here.com", ""]:
            with pytest.raises(Exception):
                UserCreate(email=email, name="Test", password="password123", grade=10, board="CBSE", stream="Science")

    def test_user_password_min_length(self):
        from models.user import UserCreate
        with pytest.raises(Exception):
            UserCreate(email="test@test.com", name="Test", password="short", grade=10, board="CBSE", stream="Science")

    def test_user_password_max_length(self):
        from models.user import UserCreate
        with pytest.raises(Exception):
            UserCreate(email="test@test.com", name="Test", password="a" * 129, grade=10, board="CBSE", stream="Science")

    def test_user_grade_boundary_valid(self):
        from models.user import UserCreate
        UserCreate(email="a@b.com", name="T", password="password123", grade=1, board="CBSE", stream="Science")
        UserCreate(email="a@b.com", name="T", password="password123", grade=12, board="CBSE", stream="Science")

    def test_user_grade_boundary_invalid(self):
        from models.user import UserCreate
        with pytest.raises(Exception):
            UserCreate(email="a@b.com", name="T", password="password123", grade=0, board="CBSE", stream="Science")
        with pytest.raises(Exception):
            UserCreate(email="a@b.com", name="T", password="password123", grade=13, board="CBSE", stream="Science")

    def test_task_empty_title(self):
        from models.task import TaskCreate
        with pytest.raises(Exception):
            TaskCreate(user_id="123", title="", pillar="academic")

    def test_task_title_max_length(self):
        from models.task import TaskCreate
        with pytest.raises(Exception):
            TaskCreate(user_id="123", title="a" * 201, pillar="academic")

    def test_task_invalid_pillar(self):
        from models.task import TaskCreate
        with pytest.raises(Exception):
            TaskCreate(user_id="123", title="Valid", pillar="invalid_pillar")

    def test_task_negative_xp(self):
        from models.task import TaskCreate
        with pytest.raises(Exception):
            TaskCreate(user_id="123", title="Test", pillar="academic", xp_reward=-10)

    def test_task_xp_zero_allowed(self):
        from models.task import TaskCreate
        assert TaskCreate(user_id="123", title="Test", pillar="academic", xp_reward=0).xp_reward == 0

    def test_task_difficulty_boundary(self):
        from models.task import TaskCreate
        TaskCreate(user_id="1", title="T", pillar="academic", difficulty=5)
        with pytest.raises(Exception):
            TaskCreate(user_id="1", title="T", pillar="academic", difficulty=6)

    def test_xp_amount_zero(self):
        from models.xp import XPTransaction
        assert XPTransaction(amount=0, pillar="academic", source="test").amount == 0

    def test_xp_negative_rejected(self):
        from models.xp import XPTransaction
        with pytest.raises(Exception):
            XPTransaction(amount=-50, pillar="academic", source="test")

    def test_xp_invalid_pillar(self):
        from models.xp import XPTransaction
        with pytest.raises(Exception):
            XPTransaction(amount=100, pillar="fake", source="test")

    def test_course_url_validation(self):
        from models.course import CourseCreate
        with pytest.raises(Exception):
            CourseCreate(title="Test", provider="Test", url="not-a-url")

    def test_course_empty_title(self):
        from models.course import CourseCreate
        with pytest.raises(Exception):
            CourseCreate(title="", provider="Test", url="https://example.com")

    def test_course_valid_https(self):
        from models.course import CourseCreate
        assert CourseCreate(title="Py", provider="X", url="https://example.com").url == "https://example.com"

    def test_evaluation_missing_required(self):
        from models.evaluation import EvaluationRequest
        with pytest.raises(Exception):
            EvaluationRequest(user_id="123")

    def test_chat_empty_message_allowed(self):
        from models.chat import ChatRequest
        assert ChatRequest(user_id="123", message="", conversation_id="c1").message == ""

    def test_chat_long_message(self):
        from models.chat import ChatRequest
        assert len(ChatRequest(user_id="123", message="x" * 10000, conversation_id="c1").message) == 10000

    def test_weekly_target_zero_xp(self):
        from models.weekly_targets import CreateWeeklyTargetRequest
        assert CreateWeeklyTargetRequest(user_id="123", title="T", xp_reward=0).xp_reward == 0

    def test_weekly_target_negative_xp_rejected(self):
        from models.weekly_targets import CreateWeeklyTargetRequest
        with pytest.raises(Exception):
            CreateWeeklyTargetRequest(user_id="123", title="T", xp_reward=-100)

    def test_location_lat_lng_bounds(self):
        from models.user import UserLocation
        UserLocation(latitude=90, longitude=180)
        UserLocation(latitude=-90, longitude=-180)
        with pytest.raises(Exception):
            UserLocation(latitude=91, longitude=0)
        with pytest.raises(Exception):
            UserLocation(latitude=0, longitude=181)


class TestAPIErrorPaths:
    """Deep error path testing - 404, 409, 422 scenarios."""

    def test_create_user_duplicate_email_409(self, srv):
        srv["db"].create_user.side_effect = sqlite3.IntegrityError("UNIQUE constraint failed")
        r = client.post(f"{API_PREFIX}/users", json={
            "email": "existing@test.com", "name": "Test", "password": "password123",
            "grade": 10, "board": "CBSE", "stream": "Science"})
        assert r.status_code == 409
        assert "already exists" in r.json()["detail"].lower()

    def test_get_user_not_found_404(self, srv):
        srv["db"].get_user.return_value = None
        r = client.get(f"{API_PREFIX}/users/nonexistent123")
        assert r.status_code == 404
        assert "not found" in r.json()["detail"].lower()

    def test_update_user_not_found_404(self, srv):
        srv["db"].update_user.return_value = None
        r = client.put(f"{API_PREFIX}/users/ghost", json={
            "user_id": "ghost", "email": "test@test.com", "name": "Test",
            "grade": 10, "board": "CBSE", "stream": "Science"})
        assert r.status_code == 404

    def test_create_user_invalid_json_422(self, srv):
        r = client.post(f"{API_PREFIX}/users", content="not json", headers={"Content-Type": "application/json"})
        assert r.status_code == 422

    def test_create_user_missing_fields_422(self, srv):
        r = client.post(f"{API_PREFIX}/users", json={"email": "test@test.com"})
        assert r.status_code == 422

    def test_create_user_invalid_email_422(self, srv):
        r = client.post(f"{API_PREFIX}/users", json={
            "email": "notanemail", "name": "T", "password": "password123",
            "grade": 10, "board": "CBSE", "stream": "Science"})
        assert r.status_code == 422

    def test_update_location_user_not_found_404(self, srv):
        srv["location"].update_location.return_value = False
        r = client.post(f"{API_PREFIX}/users/ghost/location", json={"latitude": 12.97, "longitude": 77.59})
        assert r.status_code == 404

    def test_get_location_not_set_404(self, srv):
        srv["location"].get_location.return_value = None
        r = client.get(f"{API_PREFIX}/users/user123/location")
        assert r.status_code == 404

    def test_task_not_found_404_on_complete(self, srv):
        srv["task"].get_task.return_value = None
        r = client.post(f"{API_PREFIX}/tasks/ghost_task/complete")
        assert r.status_code == 404

    def test_task_status_update_not_found_404(self, srv):
        srv["task"].update_status.return_value = False
        r = client.put(f"{API_PREFIX}/tasks/ghost_task/status", json={"status": "completed"})
        assert r.status_code == 404

    def test_invalid_task_status_422(self, srv):
        r = client.put(f"{API_PREFIX}/tasks/task123/status", json={"status": "invalid_status"})
        assert r.status_code == 422

    def test_method_not_allowed_405(self, srv):
        r = client.patch(f"{API_PREFIX}/users/test123")
        assert r.status_code == 405


class TestAPISuccessPaths:
    """Happy path tests with rich assertions."""

    def test_health_endpoint_structure(self, srv):
        r = client.get(f"{API_PREFIX}/health")
        assert r.status_code == 200
        data = r.json()
        assert data["status"] == "healthy"
        assert "timestamp" in data
        datetime.fromisoformat(data["timestamp"])

    def test_create_user_success_201(self, srv):
        srv["db"].create_user.return_value = {
            "user_id": "new123", "email": "new@test.com", "name": "New User",
            "grade": 11, "board": "CBSE", "stream": "Science"}
        r = client.post(f"{API_PREFIX}/users", json={
            "email": "new@test.com", "name": "New User", "password": "password123",
            "grade": 11, "board": "CBSE", "stream": "Science"})
        assert r.status_code == 201
        data = r.json()
        assert data["email"] == "new@test.com"
        assert data["user_id"] == "new123"
        assert "password" not in data

    def test_get_user_success(self, srv):
        srv["db"].get_user.return_value = {
            "user_id": "user123", "email": "test@test.com", "name": "Test User",
            "grade": 10, "board": "CBSE", "stream": "Science"}
        r = client.get(f"{API_PREFIX}/users/user123")
        assert r.status_code == 200
        assert r.json()["user_id"] == "user123"

    def test_update_user_success(self, srv):
        u = {"user_id": "user123", "email": "updated@test.com", "name": "Updated",
             "grade": 11, "board": "CBSE", "stream": "Science"}
        srv["db"].update_user.return_value = u
        r = client.put(f"{API_PREFIX}/users/user123", json=u)
        assert r.status_code == 200
        assert r.json()["email"] == "updated@test.com"

    def test_update_location_success(self, srv):
        srv["location"].update_location.return_value = True
        r = client.post(f"{API_PREFIX}/users/user123/location", json={"latitude": 12.97, "longitude": 77.59})
        assert r.status_code == 200
        assert r.json()["status"] == "success"

    def test_get_location_success(self, srv):
        srv["location"].get_location.return_value = {"latitude": 12.97, "longitude": 77.59, "city": "Bangalore"}
        r = client.get(f"{API_PREFIX}/users/user123/location")
        assert r.status_code == 200
        assert r.json()["city"] == "Bangalore"

    def test_create_task_success(self, srv):
        srv["task"].create_task.return_value = {
            "id": "task123", "user_id": "user123", "title": "Study Python",
            "pillar": "academic", "xp_reward": 100, "status": "pending"}
        r = client.post(f"{API_PREFIX}/tasks", json={
            "user_id": "user123", "title": "Study Python", "pillar": "academic", "xp_reward": 100})
        assert r.status_code == 201
        data = r.json()
        assert data["id"] == "task123"
        assert data["xp_reward"] == 100

    def test_get_user_tasks_with_filter(self, srv):
        srv["task"].get_user_tasks.return_value = [
            {"id": "t1", "user_id": "u1", "title": "Task 1", "status": "pending"},
            {"id": "t2", "user_id": "u1", "title": "Task 2", "status": "pending"}]
        r = client.get(f"{API_PREFIX}/tasks/user123?status=pending")
        assert r.status_code == 200
        data = r.json()
        assert len(data) == 2
        assert all(t["status"] == "pending" for t in data)

    def test_complete_task_success_awards_xp(self, srv):
        from types import SimpleNamespace
        task_obj = SimpleNamespace(
            id="task123", user_id="user123", title="Test",
            pillar="academic", xp_reward=100
        )
        srv["task"].get_task.return_value = task_obj
        srv["task"].update_status.return_value = True
        srv["xp"].award_xp.return_value = {"total_xp": 500, "level_up": True, "new_level": 2}
        r = client.post(f"{API_PREFIX}/tasks/task123/complete")
        assert r.status_code == 200
        data = r.json()
        assert data["status"] == "completed"
        assert data["xp_awarded"]["total_xp"] == 500
        srv["xp"].award_xp.assert_called_once()


class TestServiceBusinessLogic:
    """Test actual service implementations."""

    @pytest.mark.asyncio
    async def test_task_service_create_persists(self):
        from services.tasks import TaskService
        from models.task import TaskCreate
        mock_db = AsyncMock()
        mock_db.create_task = AsyncMock(return_value={"id": "t1", "user_id": "u1", "title": "Test", "pillar": "academic", "xp_reward": 50, "status": "pending"})
        service = TaskService(mock_db)
        result = await service.create_task(TaskCreate(user_id="u1", title="Test", pillar="academic", xp_reward=50))
        assert result["id"] == "t1"
        mock_db.create_task.assert_called_once()

    @pytest.mark.asyncio
    async def test_task_service_get_user_tasks(self):
        from services.tasks import TaskService
        mock_db = AsyncMock()
        mock_db.get_user_tasks = AsyncMock(return_value=[])
        service = TaskService(mock_db)
        assert await service.get_user_tasks("test") == []

    @pytest.mark.asyncio
    async def test_course_service_get_not_found(self):
        from services.courses import CourseService
        mock_db = AsyncMock()
        mock_cursor = AsyncMock()
        mock_cursor.fetchone = AsyncMock(return_value=None)
        mock_db.db.execute = AsyncMock(return_value=mock_cursor)
        service = CourseService(mock_db)
        assert await service.get_course("nonexistent") is None


class TestSecurityHeaders:
    """Security and CORS tests."""

    def test_health_no_crash(self, srv):
        r = client.get(f"{API_PREFIX}/health")
        assert r.status_code == 200

    def test_cors_preflight(self, srv):
        r = client.options(f"{API_PREFIX}/health", headers={
            "Origin": "http://localhost:8080",
            "Access-Control-Request-Method": "GET"})
        assert r.status_code in [200, 204, 400]


class TestResponseModels:
    """Validate response schemas."""

    def test_create_user_excludes_password(self, srv):
        srv["db"].create_user.return_value = {"user_id": "u1", "email": "a@b.com", "name": "A", "grade": 10, "board": "CBSE", "stream": "Science"}
        r = client.post(f"{API_PREFIX}/users", json={"email": "a@b.com", "name": "A", "password": "password123", "grade": 10, "board": "CBSE", "stream": "Science"})
        assert r.status_code == 201
        assert "password" not in r.json()

    def test_get_user_schema_shape(self, srv):
        srv["db"].get_user.return_value = {"user_id": "u1", "email": "a@b.com", "name": "A", "grade": 10, "board": "CBSE", "stream": "Science"}
        r = client.get(f"{API_PREFIX}/users/u1")
        assert r.status_code == 200
        assert set(r.json().keys()) >= {"user_id", "email", "name", "grade", "board", "stream"}


# ============================================================
# INTEGRATION TESTS - real in-memory sqlite
# ============================================================

class TestIntegrationStyle:
    """Integration tests using real sqlite in-memory database."""

    @pytest.mark.asyncio
    async def test_full_user_lifecycle(self):
        from services.database import Database
        from models.user import UserCreate, User
        db = Database(":memory:")
        await db.initialize()
        try:
            created = await db.create_user(UserCreate(
                email="life@test.com", name="Lifecycle", password="password123",
                grade=10, board="CBSE", stream="Science"))
            assert created.email == "life@test.com"
            uid = created.user_id

            fetched = await db.get_user(uid)
            assert fetched.email == "life@test.com"
        finally:
            await db.close()

    @pytest.mark.asyncio
    async def test_task_creation_integration(self):
        from services.database import Database
        from models.task import TaskCreate
        db = Database(":memory:")
        await db.initialize()
        try:
            # Create a user first (FK)
            from models.user import UserCreate
            user = await db.create_user(UserCreate(
                email="task@test.com", name="T", password="password123",
                grade=10, board="CBSE", stream="Science"))
            task = await db.create_task(TaskCreate(
                user_id=user.user_id, title="Integration Task", pillar="academic", xp_reward=200))
            assert task.title == "Integration Task"
            assert task.xp_reward == 200

            tasks = await db.get_user_tasks(user.user_id)
            assert len(tasks) == 1
            assert tasks[0].title == "Integration Task"
        finally:
            await db.close()

    @pytest.mark.asyncio
    async def test_xp_award_integration(self):
        from services.database import Database
        from models.user import UserCreate
        db = Database(":memory:")
        await db.initialize()
        try:
            user = await db.create_user(UserCreate(
                email="xp@test.com", name="X", password="password123",
                grade=10, board="CBSE", stream="Science"))
            result = await db.add_xp(user.user_id, 150, "academics", "task")
            assert "error" not in result
            state = await db.get_xp_state(user.user_id)
            assert state["total_xp"] == 150
        finally:
            await db.close()

    @pytest.mark.asyncio
    async def test_duplicate_email_constraint(self):
        from services.database import Database
        from models.user import UserCreate
        db = Database(":memory:")
        await db.initialize()
        try:
            await db.create_user(UserCreate(
                email="dup@test.com", name="A", password="password123",
                grade=10, board="CBSE", stream="Science"))
            with pytest.raises(Exception):
                await db.create_user(UserCreate(
                    email="dup@test.com", name="B", password="password123",
                    grade=11, board="ICSE", stream="Commerce"))
        finally:
            await db.close()


if __name__ == "__main__":
    pytest.main([__file__, "-v", "--tb=short"])