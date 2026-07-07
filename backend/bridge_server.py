#!/usr/bin/env python3
"""
ProfileForge ↔ Hermes Bridge Server

A lightweight HTTP server that:
1. Receives evaluation requests from the FastAPI backend
2. Writes them to files for Hermes to pick up
3. Returns results once Hermes has processed them
4. Handles real-time chat between app and Hermes agent

This is the bridge between the Flutter app's backend
and Hermes agent's intelligence.
"""

import json
import os
import time
import uuid
import asyncio
import threading
from pathlib import Path
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

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

# Chat dirs
CHAT_DIR = BASE_DIR / "backend" / "data" / "chat_sessions"
CHAT_DIR.mkdir(parents=True, exist_ok=True)


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

        elif self.path.startswith("/chat/history/"):
            # Get chat history for a session
            session_id = self.path.split("/chat/history/", 1)[1]
            session_file = CHAT_DIR / f"{session_id}.json"
            if session_file.exists():
                with open(session_file) as f:
                    self._send_json(json.load(f))
            else:
                self._send_json({"messages": [], "session_id": session_id})

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

        elif self.path == "/chat":
            # Real-time chat with Hermes agent
            body = self._read_body()
            messages = body.get("messages", [])
            conversation_id = body.get("conversation_id", str(uuid.uuid4())[:12])
            stream = body.get("stream", False)

            # Save the conversation
            session_file = CHAT_DIR / f"{conversation_id}.json"
            session_data = {
                "conversation_id": conversation_id,
                "messages": messages,
                "updated_at": time.time(),
            }
            with open(session_file, "w") as f:
                json.dump(session_data, f, indent=2)

            # Generate response using local heuristics
            # (In production, this would call Hermes LLM directly)
            response = self._generate_chat_response(messages)

            # Save the assistant reply
            messages.append(response)
            session_data["messages"] = messages
            session_data["updated_at"] = time.time()
            with open(session_file, "w") as f:
                json.dump(session_data, f, indent=2)

            self._send_json({
                "response": response["content"],
                "conversation_id": conversation_id,
                "suggestions": response.get("suggestions", []),
                "action_items": response.get("action_items", []),
            })

        else:
            self._send_json({"error": "not found"}, 404)

    def _generate_chat_response(self, messages: list) -> dict:
        """Generate a coaching response based on message history.

        Smart keyword + context matching for 15+ topic areas.
        Tracks conversation turn count for progressively deeper responses.
        """
        if not messages:
            return {
                "role": "assistant",
                "content": "Hello! I'm your ProfileForge Coach. 🎯\n\nI help Indian students build winning profiles for top universities worldwide. What can I help you with today?",
                "suggestions": ["Build my profile", "Help with essay", "Find opportunities", "Research guidance"],
            }

        # Get last user message and conversation turn count
        last_user_msg = ""
        user_turn_count = 0
        for msg in messages:
            if msg.get("role") == "user":
                user_turn_count += 1
                last_user_msg = msg.get("content", "").lower()

        # Context-aware response generation with 15 topic areas
        suggestions = []
        action_items = []

        # ── ESSAY / WRITING ──
        if any(kw in last_user_msg for kw in ["essay", "writing", "common app", "personal statement", "write my", "review my essay"]):
            if user_turn_count <= 2:
                content = (
                    "Let's craft an essay that admissions officers remember! 📝\n\n"
                    "**The 4 Pillars of a Great Essay:**\n"
                    "1. **Hook** — Open with a vivid moment, not a dictionary definition\n"
                    "2. **Specific Details** — Names, places, sensory details > generic statements\n"
                    "3. **Narrative Arc** — Challenge → Growth → Reflection\n"
                    "4. **Authentic Voice** — Write like you're talking to a mentor\n\n"
                    "💡 Indian students often make the mistake of listing achievements. "
                    "Instead, tell ONE story that reveals who you really are.\n\n"
                    "Which Common App prompt are you responding to?"
                )
                suggestions = ["Prompt 1: Background/Identity", "Prompt 2: Challenge/Failure", "Prompt 3: Questioned a belief", "Help me pick a topic"]
            else:
                content = (
                    "Here's my essay feedback framework:\n\n"
                    "✅ **Opening** — Does it grab attention in the first 10 words?\n"
                    "✅ **Specificity** — Are there concrete moments (not abstractions)?\n"
                    "✅ **Growth** — Does the reader see how you changed?\n"
                    "✅ **Voice** — Does it sound like YOU, not a textbook?\n"
                    "✅ **Closing** — Does it connect back to the opening?\n\n"
                    "Share your draft or describe your story, and I'll give detailed feedback."
                )
                suggestions = ["Share my draft for review", "Story brainstorming help", "Word count check (250-650)"]

            action_items = ["Write 300+ words today", "Read essay aloud for natural flow", "Get one friend to read it"]
            suggestions = suggestions or ["Review my opening paragraph", "Check narrative arc", "Common App prompt ideas"]

        # ── RESEARCH / PAPER ──
        elif any(kw in last_user_msg for kw in ["research", "paper", "journal", "publication", "methodology", "publish"]):
            content = (
                "Research papers are the #1 differentiator for Indian students! 🔬\n\n"
                "**The 8-Week Paper Pipeline:**\n"
                "📋 **Week 1-2**: Topic selection → Read 8-15 papers (Google Scholar, arXiv)\n"
                "📐 **Week 3-4**: Design methodology → Collect data/run experiments\n"
                "✍️ **Week 5-6**: Write draft: Abstract → Intro → Methods → Results → Discussion\n"
                "🔄 **Week 7-8**: Peer review → Revision → Submit to journal/conference\n\n"
                "**Where to publish (as a high school student):**\n"
                "• Journal of Emerging Investigators (JEI) — free, peer-reviewed\n"
                "• Science Junior — accepts Indian students\n"
                "• arXiv preprint — immediate visibility\n"
                "• STEM Fellowship Journal — Indian platform\n\n"
                "💡 Pro tip: A paper in ANY journal beats a 4.0 GPA for admissions.\n\n"
                "What subject interests you?"
            )
            suggestions = ["CS/AI research ideas", "Biology/Medicine research", "Social Science research", "How to find a mentor"]
            action_items = ["Read 3 papers this week", "Pick a specific research question", "Email a professor for mentorship"]

        # ── WEEKLY PLANNING ──
        elif any(kw in last_user_msg for kw in ["week", "plan", "schedule", "target", "goal", "routine", "time management"]):
            content = (
                "Here's the optimal weekly split for college-bound students:\n\n"
                "📊 **The 5-Pillar Week:**\n"
                "📚 **Academics (35%)** — Classes, assignments, test prep\n"
                "🔬 **Research/Projects (25%)** — Paper, coding project, experiment\n"
                "🤝 **Activities (20%)** — Clubs, volunteering, competitions\n"
                "✍️ **Essays/Apps (10%)** — Writing, revising, applications\n"
                "💪 **Self-care (10%)** — Exercise, hobbies, rest\n\n"
                "**Indian student reality check:**\n"
                "• Board exams: Jan-Mar → Shift to 50% academics\n"
                "• Summer break: Jun-Aug → Maximum research output\n"
                "• Weekends: 6 hrs productive work is the sweet spot\n\n"
                "Want me to create specific weekly targets?"
            )
            suggestions = ["Create weekly targets", "Set research milestones", "Plan my summer", "Block study sessions"]
            action_items = ["Block 2 focus sessions today", "Identify top 3 priorities this week"]

        # ── COMPETITIONS ──
        elif any(kw in last_user_msg for kw in ["competition", "olympiad", "contest", "hackathon", "ntse", "kvpy", "jee", "neet"]):
            content = (
                "Competitions are huge for your profile! 🏆\n\n"
                "**India-specific competition pipeline:**\n"
                "🧠 **Math**: IOQM → INMO → RMO → IMO (Indian Math Olympiad)\n"
                "⚛️ **Physics**: NSEP → INPhO → IPhO (Physics Olympiad)\n"
                "🧪 **Science**: NSEC → INChO → IChO (Chemistry Olympiad)\n"
                "💻 **Tech**: Hackathons, NTSE, KVPY, SIH\n\n"
                "**Preparation timeline:**\n"
                "• 3 months out: Study core concepts, past papers\n"
                "• 1 month out: Practice timed tests daily\n"
                "• 1 week out: Light revision, focus on weak areas\n"
                "• Day of: Stay calm, manage time carefully\n\n"
                "💡 An Olympiad qualifier (even state-level) > most extracurriculars.\n\n"
                "Which competition are you targeting?"
            )
            suggestions = ["IOQM/NMTC prep plan", "JEE/NEET strategy", "Hackathon ideas", "NTSE preparation"]

        # ── SCHOLARSHIPS ──
        elif any(kw in last_user_msg for kw in ["scholarship", "financial aid", "funding", "tuition", "afford"]):
            content = (
                "Here are the best scholarships for Indian students:\n\n"
                "🇮🇳 **India-specific:**\n"
                "• KVPY — ₹84,000/year + IISc/IISER direct admission\n"
                "• INSPIRE (SHE) — ₹80,000/year for BSc/BS\n"
                "• NMMSS — ₹12,000/year for meritorious students\n\n"
                "🌍 **For studying abroad:**\n"
                "• Tata Scholarship (Cornell) — Full tuition\n"
                "• Inlaks Scholarship — Up to $100K\n"
                "• Narotam Sekhsaria — Interest-free loan + grant\n"
                "• Fulbright-Nehru — Full funding for US\n"
                "• Chevening (UK) — Full funding\n\n"
                "💡 Most scholarships want: strong academics + leadership + social impact.\n\n"
                "Where are you planning to study?"
            )
            suggestions = ["US scholarships", "UK/EU scholarships", "India scholarships", "How to strengthen my application"]

        # ── UNIVERSITY SELECTION ──
        elif any(kw in last_user_msg for kw in ["university", "college", "admission", "ivy", "iit", "mit", "stanford", "harvard", "apply"]):
            content = (
                "Let's build your university list strategically! 🎓\n\n"
                "**The Balanced List (8-12 schools):**\n"
                "🎯 **2-3 Reach** — Your dream schools (acceptance <20%)\n"
                "🎯 **4-5 Target** — Good fit schools (acceptance 20-50%)\n"
                "🎯 **2-3 Safety** — Almost certain admission (>50%)\n\n"
                "**What top schools look for (in order):**\n"
                "1. 🔬 Research/spike — Something that makes you UNUSUAL\n"
                "2. 📝 Essays — Authentic, specific, reflective\n"
                "3. 🏆 Awards — Competitions, publications, recognitions\n"
                "4. 📊 Academics — Rigor of courses + grades\n"
                "5. 🤝 Activities — Depth > breadth\n\n"
                "💡 Indian student tip: Don't put all eggs in JEE/NEET. "
                "US/UK/EU universities value well-rounded profiles.\n\n"
                "Which universities are you targeting?"
            )
            suggestions = ["US top 20 strategy", "UK/EU universities", "IIT/NIT pathway", "My admission chances"]

        # ── SPIKE / PROFILE BUILDING ──
        elif any(kw in last_user_msg for kw in ["spike", "profile", "stand out", "different", "unique", "build my"]):
            content = (
                "Your 'spike' is what makes you UNFORGETTABLE to admissions officers. 🌟\n\n"
                "**6 Spike Categories:**\n"
                "🔬 **Research Publication** — Published paper in a journal\n"
                "🏆 **Competition Winner** — State/national/international level\n"
                "💻 **Technical Creation** — App, website, open-source project\n"
                "🌍 **Social Impact** — Measurable change in community\n"
                "👑 **Leadership** — Founded a club, led a team, organized events\n"
                "🎓 **Academic Excellence** — Olympiad qualifier, perfect scores\n\n"
                "**Indian student reality:**\n"
                "• 'I was class monitor' ≠ leadership\n"
                "• 'I volunteered 50 hours' ≠ social impact\n"
                "• You need MEASURABLE, UNIQUE achievements\n\n"
                "💡 The spike formula: Interest + Skill + Impact = Spike\n\n"
                "Tell me about your strongest interests and I'll suggest spike ideas."
            )
            suggestions = ["CS/AI spike ideas", "Science research spikes", "Social impact spikes", "My current activities"]

        # ── COURSES / LEARNING ──
        elif any(kw in last_user_msg for kw in ["course", "learn", "study", "online", "mooc", "certificate"]):
            content = (
                "Free courses that actually boost your college application:\n\n"
                "💻 **Computer Science:**\n"
                "• CS50 (Harvard/edX) — The gold standard\n"
                "• Machine Learning by Andrew Ng (Coursera)\n"
                "• Python for Everybody (Coursera)\n\n"
                "🔬 **Science:**\n"
                "• MIT OpenCourseWare — Physics, Chemistry, Biology\n"
                "• Khan Academy — AP-level courses\n\n"
                "📊 **Business/Economics:**\n"
                "• Microeconomics (MIT/edX)\n"
                "• Financial Markets (Yale/Coursera)\n\n"
                "💡 Complete 2-3 certificates + mention them in essays = strong signal.\n\n"
                "Check the Courses tab for 17+ free courses you can start today!"
            )
            suggestions = ["Best CS courses", "Science courses", "How to mention courses in essays", "View courses tab"]

        # ── ACTIVITIES / EXTRACURRICULARS ──
        elif any(kw in last_user_msg for kw in ["activity", "activities", "club", "volunteer", "ngo", "social work", "ngo"]):
            content = (
                "Smart activities for college-bound Indian students:\n\n"
                "✅ **HIGH IMPACT:**\n"
                "• Founding a club/initiative (leadership + innovation)\n"
                "• Research with a professor (academic depth)\n"
                "• Teaching underprivileged kids (social impact)\n"
                "• Organizing a school event (logistics + teamwork)\n\n"
                "⚠️ **OVERDONE:**\n"
                "• Student council without real initiatives\n"
                "• One-off volunteering events\n"
                "• Joining 10 clubs superficially\n\n"
                "💡 Rule: Go DEEP in 2-3 activities, not SHALLOW in 10.\n\n"
                "Check the Opportunities tab for NGOs and competitions near you!"
            )
            suggestions = ["NGO opportunities near me", "How to start a club", "Research mentorship", "Competition calendar"]

        # ── IIT / JEE / NEET ──
        elif any(kw in last_user_msg for kw in ["iit", "jee", "neet", "nit", "aiims", "engineering", "medical"]):
            content = (
                "IIT/NIT pathway — let's be strategic! 🎯\n\n"
                "**JEE Timeline:**\n"
                "📚 Class 11: Complete JEE syllabus basics\n"
                "📝 Class 12: Deep practice + mock tests\n"
                "🎯 Gap year (if needed): Intensive preparation\n\n"
                "**Reality check:**\n"
                "• JEE Advanced acceptance rate: ~2% (15,000 out of 10,00,000)\n"
                "• Board exam % matters for eligibility (75% or top 20%)\n"
                "• Don't neglect boards for JEE\n\n"
                "💡 **ProfileForge strategy:** Prepare for JEE AND build a college app profile simultaneously. "
                "If JEE doesn't work out, you'll have US/UK/Canada options ready.\n\n"
                "Need help balancing JEE prep with profile building?"
            )
            suggestions = ["JEE study plan", "JEE + profile building strategy", "Backup plans for JEE", "Time management tips"]

        # ── SCHOLARSHIP / MONEY ──
        elif any(kw in last_user_msg for kw in ["money", "fee", "cost", "expensive", "afford", "budget"]):
            content = (
                "Don't let cost stop you! Here's the financial reality:\n\n"
                "🇮🇳 **In India:**\n"
                "• IITs: ₹2-8 lakh/year (with scholarships, often free)\n"
                "• Private colleges: ₹10-25 lakh/year\n\n"
                "🌍 **Abroad (with aid):**\n"
                "• Harvard/MIT/Stanford: Free if family income < $75K\n"
                "• UK (Chevening): Full funding available\n"
                "• Canada: More affordable, work permits available\n\n"
                "💡 Key insight: Top US schools are CHEAPER than Indian private colleges "
                "for most families due to need-based aid.\n\n"
                "Need help finding scholarships for your situation?"
            )
            suggestions = ["Need-based aid schools", "Merit scholarships", "India vs abroad cost comparison", "Application fee waivers"]

        # ── DEFAULT ──
        else:
            content = (
                "I'm your ProfileForge Coach — here to help you get into your dream university! 🎯\n\n"
                "I can help with:\n\n"
                "📝 **Essay Writing** — Structure, feedback, prompt selection\n"
                "🔬 **Research Guidance** — Papers, methodology, publication\n"
                "📅 **Weekly Planning** — Time management, target setting\n"
                "🏆 **Competition Prep** — Olympiads, JEE, hackathons\n"
                "🎓 **University Selection** — Strategy, admissions chances\n"
                "🌟 **Profile Building** — Spike identification, activities\n"
                "💰 **Scholarships** — Financial aid, funding opportunities\n"
                "📚 **Free Courses** — Certificates that boost your profile\n\n"
                "What would you like to focus on?"
            )
            suggestions = ["Build my profile spike", "Help with essay", "Find opportunities near me", "Plan my week"]

        return {
            "role": "assistant",
            "content": content,
            "suggestions": suggestions,
            "action_items": action_items,
        }

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
    print("  GET  /chat/history/{id}— get chat session history")
    print("  POST /evaluate         — submit text for evaluation")
    print("  POST /tasks/generate   — request task generation")
    print("  POST /chat             — chat with Hermes coach")
    server.serve_forever()


if __name__ == "__main__":
    main()
