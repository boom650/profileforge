#!/usr/bin/env python3
"""
ProfileForge ↔ Hermes Bridge Server

A lightweight HTTP server that:
1. Receives evaluation requests from the FastAPI backend
2. Writes them to files for Hermes to pick up
3. Returns results once Hermes has processed them

This is the bridge between the Flutter app's backend
and Hermes agent's intelligence.
"""

import json
import os
import time
import uuid
import asyncio
from pathlib import Path
from http.server import HTTPServer, BaseHTTPRequestHandler

BASE_DIR = Path("/data/data/com.termux/files/home/profileforge")
PENDING_DIR = BASE_DIR / "backend" / "data" / "pending_evaluations"
RESULTS_DIR = BASE_DIR / "backend" / "data" / "evaluation_results"
PENDING_DIR.mkdir(parents=True, exist_ok=True)
RESULTS_DIR.mkdir(parents=True, exist_ok=True)

# Also create task generation dirs
TASKS_PENDING = BASE_DIR / "backend" / "data" / "pending_tasks"
TASKS_RESULTS = BASE_DIR / "backend" / "data" / "task_results"
TASKS_PENDING.mkdir(parents=True, exist_ok=True)
TASKS_RESULTS.mkdir(parents=True, exist_ok=True)


class BridgeHandler(BaseHTTPRequestHandler):
    def _send_json(self, data, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def _read_body(self):
        length = int(self.headers.get("Content-Length", 0))
        return json.loads(self.rfile.read(length)) if length else {}

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_GET(self):
        if self.path == "/health":
            self._send_json({"status": "bridge_alive", "timestamp": time.time()})

        elif self.path.startswith("/results/"):
            # Get a specific evaluation result
            job_id = self.path.split("/results/", 1)[1]
            result_file = RESULTS_DIR / f"{job_id}.json"
            if result_file.exists():
                with open(result_file) as f:
                    result = json.load(f)
                # Clean up after reading
                result_file.unlink(missing_ok=True)
                self._send_json(result)
            else:
                self._send_json({"status": "pending"}, 202)

        elif self.path.startswith("/task-results/"):
            # Get task generation results
            job_id = self.path.split("/task-results/", 1)[1]
            result_file = TASKS_RESULTS / f"{job_id}.json"
            if result_file.exists():
                with open(result_file) as f:
                    result = json.load(f)
                result_file.unlink(missing_ok=True)
                self._send_json(result)
            else:
                self._send_json({"status": "pending"}, 202)

        elif self.path == "/pending":
            # List pending evaluations (for Hermes cron)
            pending = []
            for f in PENDING_DIR.glob("*.json"):
                with open(f) as fh:
                    pending.append(json.load(fh))
            self._send_json({"count": len(pending), "jobs": pending})

        elif self.path == "/tasks/pending":
            # List pending task generation requests
            pending = []
            for f in TASKS_PENDING.glob("*.json"):
                with open(f) as fh:
                    pending.append(json.load(fh))
            self._send_json({"count": len(pending), "jobs": pending})

        else:
            self._send_json({"error": "not found"}, 404)

    def do_POST(self):
        if self.path == "/evaluate":
            # Submit text for AI evaluation
            body = self._read_body()
            job_id = str(uuid.uuid4())[:8]

            job = {
                "job_id": job_id,
                "type": "text_evaluation",
                "user_id": body.get("user_id", ""),
                "task_id": body.get("task_id", ""),
                "content": body.get("content", ""),
                "task_title": body.get("task_title", "General submission"),
                "interests": body.get("interests", "technology, science, leadership"),
                "submitted_at": time.time(),
            }

            # Write to pending dir
            with open(PENDING_DIR / f"{job_id}.json", "w") as f:
                json.dump(job, f, indent=2)

            self._send_json({"job_id": job_id, "status": "pending", "message": "Evaluation queued for Hermes"})

        elif self.path == "/tasks/generate":
            # Request task generation
            body = self._read_body()
            job_id = str(uuid.uuid4())[:8]

            job = {
                "job_id": job_id,
                "type": "task_generation",
                "user_id": body.get("user_id", ""),
                "interests": body.get("interests", "technology, science, leadership"),
                "completed_count": body.get("completed_count", 0),
                "current_xp": body.get("current_xp", 0),
                "streak": body.get("streak", 0),
                "weak_pillars": body.get("weak_pillars", ""),
                "recent_activity": body.get("recent_activity", ""),
                "submitted_at": time.time(),
            }

            with open(TASKS_PENDING / f"{job_id}.json", "w") as f:
                json.dump(job, f, indent=2)

            self._send_json({"job_id": job_id, "status": "pending", "message": "Task generation queued for Hermes"})

        else:
            self._send_json({"error": "not found"}, 404)

    def log_message(self, format, *args):
        pass  # Suppress logs


def main():
    server = HTTPServer(("127.0.0.1", 8090), BridgeHandler)
    print("Hermes Bridge Server running on http://127.0.0.1:8090")
    print("Endpoints:")
    print("  GET  /health           — health check")
    print("  GET  /pending          — list pending evaluations")
    print("  GET  /tasks/pending    — list pending task requests")
    print("  GET  /results/{id}     — get evaluation result")
    print("  GET  /task-results/{id}— get task generation result")
    print("  POST /evaluate         — submit text for evaluation")
    print("  POST /tasks/generate   — request task generation")
    server.serve_forever()


if __name__ == "__main__":
    main()
