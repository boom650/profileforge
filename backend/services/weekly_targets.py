"""
Weekly Targets Service
Manages weekly targets and research paper milestones.
Provides auto-generation of research paper pipelines.
"""

import uuid
from datetime import datetime, timedelta
from typing import Optional, List
import aiosqlite

from models.weekly_targets import (
    WeeklyTarget, WeeklyTargetsResponse, CreateWeeklyTargetRequest,
    UpdateMilestoneRequest, ResearchPaperMilestone,
    MilestoneStatus, MilestoneType,
)


# ── Research paper milestone templates ──────────────────────────────────────

RESEARCH_PAPER_PIPELINE = [
    {
        "step_name": "Topic Selection & Scoping",
        "description": "Choose a specific, researchable topic. Define scope, research question, and hypotheses.",
        "order": 1,
        "xp_reward": 10,
        "due_offset_days": 2,
    },
    {
        "step_name": "Literature Review",
        "description": "Read 8-15 relevant papers. Summarize findings, identify gaps. Create annotated bibliography.",
        "order": 2,
        "xp_reward": 20,
        "due_offset_days": 7,
    },
    {
        "step_name": "Research Design & Methodology",
        "description": "Define methods, data collection plan, ethical considerations. Write methodology section.",
        "order": 3,
        "xp_reward": 15,
        "due_offset_days": 10,
    },
    {
        "step_name": "Data Collection / Experimentation",
        "description": "Conduct experiments, surveys, or data analysis. Document results systematically.",
        "order": 4,
        "xp_reward": 25,
        "due_offset_days": 21,
    },
    {
        "step_name": "Draft v1 (Full Paper)",
        "description": "Write complete first draft: Abstract, Introduction, Methods, Results, Discussion, Conclusion.",
        "order": 5,
        "xp_reward": 30,
        "due_offset_days": 28,
    },
    {
        "step_name": "Peer Review & Feedback",
        "description": "Share with mentors, teachers, or peers. Collect feedback on methodology and writing.",
        "order": 6,
        "xp_reward": 10,
        "due_offset_days": 33,
    },
    {
        "step_name": "Revision & Final Draft",
        "description": "Incorporate feedback. Polish writing, fix citations, format per journal/conference guidelines.",
        "order": 7,
        "xp_reward": 20,
        "due_offset_days": 38,
    },
    {
        "step_name": "Submission / Publication",
        "description": "Submit to journal, conference, or science fair. Prepare presentation if needed.",
        "order": 8,
        "xp_reward": 50,
        "due_offset_days": 45,
    },
]


class WeeklyTargetsService:
    def __init__(self, db):
        self.db = db

    async def ensure_tables(self):
        """Create weekly targets tables if they don't exist."""
        await self.db.db.execute("""
            CREATE TABLE IF NOT EXISTS weekly_targets (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                title TEXT NOT NULL,
                description TEXT,
                category TEXT,
                milestone_type TEXT DEFAULT 'standard',
                pillar TEXT,
                xp_reward INTEGER DEFAULT 25,
                status TEXT DEFAULT 'not_started',
                week_number INTEGER,
                year INTEGER,
                due_date TEXT,
                completed_at TEXT,
                progress_pct INTEGER DEFAULT 0,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        """)

        await self.db.db.execute("""
            CREATE TABLE IF NOT EXISTS research_milestones (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                target_id TEXT,
                paper_title TEXT NOT NULL,
                step_name TEXT NOT NULL,
                step_order INTEGER NOT NULL,
                description TEXT,
                status TEXT DEFAULT 'not_started',
                due_date TEXT,
                completed_at TEXT,
                notes TEXT,
                xp_reward INTEGER DEFAULT 10,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id),
                FOREIGN KEY (target_id) REFERENCES weekly_targets(id)
            )
        """)

        await self.db.db.commit()

    # ── Weekly Targets CRUD ─────────────────────────────────────────────────

    async def create_target(self, req: CreateWeeklyTargetRequest) -> WeeklyTarget:
        """Create a new weekly target, optionally with research milestones."""
        now = datetime.now()
        target_id = str(uuid.uuid4())

        # Default to current week if not specified
        week_num = now.isocalendar()[1]
        year = now.year

        await self.db.db.execute("""
            INSERT INTO weekly_targets
                (id, user_id, title, description, category, milestone_type,
                 pillar, xp_reward, status, week_number, year, due_date, progress_pct, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            target_id, req.user_id, req.title, req.description,
            req.category, req.milestone_type.value, req.pillar,
            req.xp_reward, MilestoneStatus.NOT_STARTED.value,
            week_num, year, req.due_date, 0, now.isoformat(),
        ))

        milestones = []
        if req.generate_research_milestones and req.paper_title:
            milestones = await self._create_research_pipeline(
                user_id=req.user_id,
                target_id=target_id,
                paper_title=req.paper_title,
                base_date=now,
            )

        await self.db.db.commit()

        return WeeklyTarget(
            id=target_id,
            user_id=req.user_id,
            title=req.title,
            description=req.description,
            category=req.category,
            milestone_type=req.milestone_type,
            pillar=req.pillar,
            xp_reward=req.xp_reward,
            status=MilestoneStatus.NOT_STARTED,
            week_number=week_num,
            year=year,
            due_date=req.due_date,
            progress_pct=0,
            milestones=milestones if milestones else None,
        )

    async def get_weekly_targets(
        self, user_id: str, week_number: Optional[int] = None, year: Optional[int] = None
    ) -> WeeklyTargetsResponse:
        """Get all targets for a specific week."""
        now = datetime.now()
        week_num = week_number or now.isocalendar()[1]
        yr = year or now.year

        cursor = await self.db.db.execute(
            "SELECT * FROM weekly_targets WHERE user_id = ? AND week_number = ? AND year = ? ORDER BY created_at",
            (user_id, week_num, yr),
        )
        rows = await cursor.fetchall()

        targets = []
        total_xp = 0
        completed = 0

        for row in rows:
            target = WeeklyTarget(
                id=row[0], user_id=row[1], title=row[2],
                description=row[3], category=row[4],
                milestone_type=MilestoneType(row[5]) if row[5] else MilestoneType.STANDARD,
                pillar=row[6], xp_reward=row[7],
                status=MilestoneStatus(row[8]) if row[8] else MilestoneStatus.NOT_STARTED,
                week_number=row[9], year=row[10],
                due_date=row[11], completed_at=row[12],
                progress_pct=row[13] if row[13] else 0,
            )

            # Attach milestones if research paper
            if target.milestone_type == MilestoneType.RESEARCH_PAPER:
                target.milestones = await self._get_milestones(user_id, target.id)

            targets.append(target)
            total_xp += target.xp_reward
            if target.status == MilestoneStatus.COMPLETED:
                completed += 1

        total = len(targets)
        overall_pct = (
            sum(t.progress_pct for t in targets) // total if total > 0 else 0
        )

        return WeeklyTargetsResponse(
            user_id=user_id,
            week_number=week_num,
            year=yr,
            targets=targets,
            total_xp_available=total_xp,
            completed_count=completed,
            total_count=total,
            overall_progress_pct=overall_pct,
        )

    async def update_target_status(
        self, target_id: str, status: MilestoneStatus
    ) -> Optional[WeeklyTarget]:
        """Update a target's status."""
        now = datetime.now().isoformat()
        completed_at = now if status == MilestoneStatus.COMPLETED else None

        await self.db.db.execute(
            "UPDATE weekly_targets SET status=?, completed_at=?, progress_pct=? WHERE id=?",
            (status.value, completed_at, 100 if status == MilestoneStatus.COMPLETED else 0, target_id),
        )
        await self.db.db.commit()
        return await self._get_target(target_id)

    async def get_all_milestones(self, user_id: str) -> List[ResearchPaperMilestone]:
        """Get all research milestones for a user across all papers."""
        cursor = await self.db.db.execute(
            "SELECT * FROM research_milestones WHERE user_id = ? ORDER BY step_order",
            (user_id,),
        )
        rows = await cursor.fetchall()
        return [self._row_to_milestone(r) for r in rows]

    async def update_milestone(
        self, milestone_id: str, req: UpdateMilestoneRequest
    ) -> Optional[ResearchPaperMilestone]:
        """Update a milestone's status."""
        now = datetime.now().isoformat()
        completed_at = now if req.status == MilestoneStatus.COMPLETED else None

        await self.db.db.execute(
            "UPDATE research_milestones SET status=?, completed_at=?, notes=? WHERE id=?",
            (req.status.value, completed_at, req.notes, milestone_id),
        )
        await self.db.db.commit()

        # Update parent target progress
        cursor = await self.db.db.execute(
            "SELECT target_id FROM research_milestones WHERE id=?", (milestone_id,)
        )
        row = await cursor.fetchone()
        if row and row[0]:
            await self._recalc_target_progress(row[0])

        # Fetch updated milestone
        cursor = await self.db.db.execute(
            "SELECT * FROM research_milestones WHERE id=?", (milestone_id,)
        )
        updated = await cursor.fetchone()
        return self._row_to_milestone(updated) if updated else None

    async def delete_target(self, target_id: str) -> bool:
        """Delete a target and its associated milestones."""
        await self.db.db.execute(
            "DELETE FROM research_milestones WHERE target_id=?", (target_id,)
        )
        cursor = await self.db.db.execute(
            "DELETE FROM weekly_targets WHERE id=?", (target_id,)
        )
        await self.db.db.commit()
        return cursor.rowcount > 0

    # ── Research Pipeline Helpers ───────────────────────────────────────────

    async def _create_research_pipeline(
        self, user_id: str, target_id: str, paper_title: str, base_date: datetime
    ) -> List[ResearchPaperMilestone]:
        """Auto-generate the 8-step research paper pipeline."""
        milestones = []
        for step in RESEARCH_PAPER_PIPELINE:
            ms_id = str(uuid.uuid4())
            due = (base_date + timedelta(days=step["due_offset_days"])).isoformat()

            await self.db.db.execute("""
                INSERT INTO research_milestones
                    (id, user_id, target_id, paper_title, step_name, step_order,
                     description, status, due_date, xp_reward, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                ms_id, user_id, target_id, paper_title,
                step["step_name"], step["order"],
                step["description"], MilestoneStatus.NOT_STARTED.value,
                due, step["xp_reward"], base_date.isoformat(),
            ))

            milestones.append(ResearchPaperMilestone(
                id=ms_id, user_id=user_id, target_id=target_id,
                paper_title=paper_title, step_name=step["step_name"],
                step_order=step["order"], description=step["description"],
                status=MilestoneStatus.NOT_STARTED, due_date=due,
                xp_reward=step["xp_reward"],
            ))

        return milestones

    async def _get_milestones(
        self, user_id: str, target_id: Optional[str] = None
    ) -> List[ResearchPaperMilestone]:
        """Get milestones for a target."""
        if target_id:
            cursor = await self.db.db.execute(
                "SELECT * FROM research_milestones WHERE user_id = ? AND target_id = ? ORDER BY step_order",
                (user_id, target_id),
            )
        else:
            cursor = await self.db.db.execute(
                "SELECT * FROM research_milestones WHERE user_id = ? ORDER BY step_order",
                (user_id,),
            )
        rows = await cursor.fetchall()
        return [self._row_to_milestone(r) for r in rows]

    async def _recalc_target_progress(self, target_id: str):
        """Recalculate target progress based on milestone completion."""
        cursor = await self.db.db.execute(
            "SELECT status FROM research_milestones WHERE target_id = ?",
            (target_id,),
        )
        rows = await cursor.fetchall()
        if not rows:
            return

        total = len(rows)
        done = sum(1 for r in rows if r[0] == MilestoneStatus.COMPLETED.value)
        pct = (done * 100) // total

        new_status = MilestoneStatus.COMPLETED if pct == 100 else (
            MilestoneStatus.IN_PROGRESS if pct > 0 else MilestoneStatus.NOT_STARTED
        )

        await self.db.db.execute(
            "UPDATE weekly_targets SET progress_pct=?, status=? WHERE id=?",
            (pct, new_status.value, target_id),
        )
        await self.db.db.commit()

    async def _get_target(self, target_id: str) -> Optional[WeeklyTarget]:
        """Fetch a single target."""
        cursor = await self.db.db.execute(
            "SELECT * FROM weekly_targets WHERE id=?", (target_id,)
        )
        row = await cursor.fetchone()
        if not row:
            return None
        return WeeklyTarget(
            id=row[0], user_id=row[1], title=row[2],
            description=row[3], category=row[4],
            milestone_type=MilestoneType(row[5]) if row[5] else MilestoneType.STANDARD,
            pillar=row[6], xp_reward=row[7],
            status=MilestoneStatus(row[8]) if row[8] else MilestoneStatus.NOT_STARTED,
            week_number=row[9], year=row[10],
            due_date=row[11], completed_at=row[12],
            progress_pct=row[13] if row[13] else 0,
        )

    @staticmethod
    def _row_to_milestone(row) -> ResearchPaperMilestone:
        return ResearchPaperMilestone(
            id=row[0], user_id=row[1], target_id=row[2],
            paper_title=row[3], step_name=row[4], step_order=row[5],
            description=row[6],
            status=MilestoneStatus(row[7]) if row[7] else MilestoneStatus.NOT_STARTED,
            due_date=row[8], completed_at=row[9],
            notes=row[10], xp_reward=row[11],
        )
