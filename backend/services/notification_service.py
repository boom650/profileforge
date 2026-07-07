"""
Notification Service — Push notifications and reminders
Manages: daily reminders, weekly reports, competition alerts
Uses Hermes Telegram for delivery when available
"""

from datetime import datetime, timedelta
from typing import Optional, List
from pydantic import BaseModel


class NotificationType(str):
    DAILY_REMINDER = "daily_reminder"
    WEEKLY_REPORT = "weekly_report"
    COMPETITION_ALERT = "competition_alert"
    MILESTONE_UPDATE = "milestone_update"
    STREAK_REMINDER = "streak_reminder"
    DEADLINE_WARNING = "deadline_warning"


class Notification(BaseModel):
    id: Optional[str] = None
    user_id: str
    notification_type: str
    title: str
    message: str
    read: bool = False
    action_url: Optional[str] = None
    created_at: Optional[str] = None


# ═══════════════════════════════════════════════════════════════════════════
# DAILY REMINDER MESSAGES (India-specific, guilt-trip style)
# ═══════════════════════════════════════════════════════════════════════════

DAILY_REMINDERS = [
    {
        "title": "⏰ Your Profile Won't Build Itself",
        "message": "While you're reading this, 10,000 Indian students are working on their college applications. You have {tasks_remaining} tasks left today. Complete them or fall behind.",
        "action": "View Tasks",
    },
    {
        "title": "📊 Admission Probability Update",
        "message": "Your admission probability is {probability}%. Every task you skip drops it by 2%. Today's priority: {top_task}. Start now.",
        "action": "View Dashboard",
    },
    {
        "title": "🔥 Streak at Risk!",
        "message": "You've maintained a {streak}-day streak. Complete today's mission or lose it all. {streak} days of work wasted for one lazy evening?",
        "action": "Complete Mission",
    },
    {
        "title": "🎯 Weekly Target Check",
        "message": "This week: {completed}/{total} targets done. {xp_earned} XP earned out of {xp_available}. Your competitors are ahead.",
        "action": "View Targets",
    },
    {
        "title": "📝 Essay Deadline Warning",
        "message": "Common App deadline is {days_until_deadline} days away. You haven't started your essay yet. Start writing 300 words today or you'll be rushing at the end.",
        "action": "Start Essay",
    },
    {
        "title": "🏆 Competition Alert",
        "message": "{competition_name} registration closes in {days_left} days. Students who qualify get a massive boost to their application. Are you preparing?",
        "action": "View Competition",
    },
    {
        "title": "🔬 Research Reminder",
        "message": "Your research paper is in week {current_week} of 8. You should be {current_step} by now. Get back on track or your paper won't be ready for applications.",
        "action": "View Research",
    },
    {
        "title": "💪 Sunday Reflection",
        "message": "It's Sunday evening. Review your week: What did you accomplish? What's planned for next week? Students who plan Sunday perform 40% better.",
        "action": "Plan Week",
    },
]


# ═══════════════════════════════════════════════════════════════════════════
# WEEKLY REPORT TEMPLATES
# ═══════════════════════════════════════════════════════════════════════════

WEEKLY_REPORT_TEMPLATE = """
📊 WEEKLY PROFILE REPORT — Week {week_number}
═══════════════════════════════════════

🎯 TARGETS: {targets_completed}/{targets_total} completed ({targets_pct}%)
   XP: {xp_earned}/{xp_available} earned

🏆 COMPETITIONS: {competitions_entered}
🔬 RESEARCH: {research_step}
📝 ESSAYS: {essays_progress}
🤝 ACTIVITIES: {activities_hours} hours

📈 ADMISSION PROBABILITY: {probability}%
   Change this week: {probability_change}

🔥 STREAK: {streak} days
🏅 CURRENT LEVEL: {level} ({xp_total} total XP)

💡 NEXT WEEK PRIORITIES:
{next_week_tasks}

═══════════════════════════════════════
Keep going! Every day counts.
"""


class NotificationService:
    def __init__(self):
        self.notifications: dict[str, List[Notification]] = {}

    def get_daily_reminder(self, user_id: str, context: dict) -> Notification:
        """Generate a context-aware daily reminder"""
        import random
        template = random.choice(DAILY_REMINDERS)

        message = template["message"].format(**{
            "tasks_remaining": context.get("tasks_remaining", 3),
            "probability": context.get("probability", 65),
            "top_task": context.get("top_task", "Complete your weekly target"),
            "streak": context.get("streak", 0),
            "completed": context.get("targets_completed", 0),
            "total": context.get("targets_total", 5),
            "xp_earned": context.get("xp_earned", 50),
            "xp_available": context.get("xp_available", 200),
            "days_until_deadline": context.get("days_until_deadline", 120),
            "competition_name": context.get("competition_name", "KVPY"),
            "days_left": context.get("competition_days_left", 14),
            "current_week": context.get("research_week", 3),
            "current_step": context.get("research_step", "completing data collection"),
        })

        return Notification(
            user_id=user_id,
            notification_type=NotificationType.DAILY_REMINDER,
            title=template["title"],
            message=message,
            action_url=template["action"],
            created_at=datetime.now().isoformat(),
        )

    def get_weekly_report(self, user_id: str, stats: dict) -> Notification:
        """Generate weekly summary report"""
        message = WEEKLY_REPORT_TEMPLATE.format(**{
            "week_number": stats.get("week_number", 1),
            "targets_completed": stats.get("targets_completed", 0),
            "targets_total": stats.get("targets_total", 5),
            "targets_pct": int(stats.get("targets_completed", 0) / max(stats.get("targets_total", 1), 1) * 100),
            "xp_earned": stats.get("xp_earned", 0),
            "xp_available": stats.get("xp_available", 200),
            "competitions_entered": stats.get("competitions_entered", 0),
            "research_step": stats.get("research_step", "N/A"),
            "essays_progress": stats.get("essays_progress", "Not started"),
            "activities_hours": stats.get("activities_hours", 0),
            "probability": stats.get("probability", 65),
            "probability_change": f"+{stats.get('probability_change', 0)}%",
            "streak": stats.get("streak", 0),
            "level": stats.get("level", 1),
            "xp_total": stats.get("xp_total", 0),
            "next_week_tasks": "\n".join(
                f"   {i+1}. {t}" for i, t in enumerate(stats.get("next_week_tasks", [
                    "Complete 2 weekly targets",
                    "Work on research paper",
                    "Write 200 words of essay"
                ]))
            ),
        })

        return Notification(
            user_id=user_id,
            notification_type=NotificationType.WEEKLY_REPORT,
            title=f"📊 Weekly Report — Week {stats.get('week_number', 1)}",
            message=message,
            created_at=datetime.now().isoformat(),
        )

    def get_competition_alert(self, user_id: str, competition_name: str,
                               days_left: int, registration_url: str = "") -> Notification:
        urgency = "URGENT" if days_left <= 3 else "Reminder"
        return Notification(
            user_id=user_id,
            notification_type=NotificationType.COMPETITION_ALERT,
            title=f"🏆 {urgency}: {competition_name}",
            message=f"{competition_name} registration closes in {days_left} days. "
                    f"Students who qualify get a massive profile boost.",
            action_url=registration_url or "View Competition",
            created_at=datetime.now().isoformat(),
        )

    def get_streak_reminder(self, user_id: str, streak: int) -> Notification:
        if streak >= 7:
            msg = f"You're on a {streak}-day streak! Don't break it now. " \
                  f"You've been consistent for over a week — that's impressive."
        elif streak >= 3:
            msg = f"{streak}-day streak going strong. One more day to hit a week. " \
                  f"Most students can't even do 3 days."
        else:
            msg = f"You've only completed {streak} day(s) so far. " \
                  f"Get serious — your competition is working while you're not."

        return Notification(
            user_id=user_id,
            notification_type=NotificationType.STREAK_REMINDER,
            title="🔥 Streak Update",
            message=msg,
            action_url="Complete Mission",
            created_at=datetime.now().isoformat(),
        )


notification_service = NotificationService()
