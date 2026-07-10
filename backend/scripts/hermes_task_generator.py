#!/usr/bin/env python3
"""
Hermes Autonomous Task Generator
Generates personalized tasks for ProfileForge users
"""

import os

BACKEND_URL = os.getenv("API_BASE_URL", "http://localhost:8080")

# Task templates based on pillars
TASK_TEMPLATES = {
    "academics": [
        {
            "title": "Complete a practice essay on {topic}",
            "description": "Write a 500-word essay on {topic}. Focus on clear structure with introduction, body paragraphs, and conclusion.",
            "category": "writing",
            "difficulty": 1,
            "xp_reward": 25
        },
        {
            "title": "Research {count} universities",
            "description": "Find {count} universities that match your interests. Note their admission requirements, deadlines, and programs.",
            "category": "research",
            "difficulty": 1,
            "xp_reward": 30
        },
    ],
    "research": [
        {
            "title": "Read and summarize a research paper",
            "description": "Find a research paper in your field of interest. Read it thoroughly and write a 300-word summary of key findings.",
            "category": "research",
            "difficulty": 2,
            "xp_reward": 40
        },
        {
            "title": "Design a mini research project",
            "description": "Create a research proposal with hypothesis, methodology, and expected outcomes. Keep it to 2 pages.",
            "category": "research",
            "difficulty": 3,
            "xp_reward": 50
        },
    ],
    "community": [
        {
            "title": "Volunteer at a local NGO",
            "description": "Find and volunteer at a local NGO for at least 2 hours. Document your experience and what you learned.",
            "category": "community",
            "difficulty": 2,
            "xp_reward": 35
        },
        {
            "title": "Organize a community clean-up",
            "description": "Gather friends and organize a neighborhood clean-up drive. Take photos and write about the impact.",
            "category": "community",
            "difficulty": 3,
            "xp_reward": 45
        },
    ],
    "leadership": [
        {
            "title": "Lead a study group session",
            "description": "Organize and lead a study group for a subject you're strong in. Prepare materials and guide the discussion.",
            "category": "leadership",
            "difficulty": 2,
            "xp_reward": 40
        },
        {
            "title": "Start a school club or initiative",
            "description": "Propose and start a new club or initiative at school. Document your plan and get at least 5 members.",
            "category": "leadership",
            "difficulty": 4,
            "xp_reward": 60
        },
    ],
    "creativity": [
        {
            "title": "Create a portfolio piece",
            "description": "Design, build, or create something that showcases your skills. It could be art, code, writing, or music.",
            "category": "creative",
            "difficulty": 2,
            "xp_reward": 35
        },
        {
            "title": "Document a creative process",
            "description": "Choose a creative project and document your process from ideation to completion. Share your learnings.",
            "category": "creative",
            "difficulty": 3,
            "xp_reward": 45
        },
    ],
}

TOPICS = [
    "climate change solutions",
    "ethical AI development",
    "renewable energy future",
    "space exploration",
    "mental health awareness",
    "digital literacy",
    "sustainable development",
    "cultural preservation"
]


def generate_task(user_id: str, pillar: str = "academics") -> dict:
    """Generate a random task for a user"""
    if pillar is None:
        pillar = random.choice(list(TASK_TEMPLATES.keys()))
    
    templates = TASK_TEMPLATES[pillar]
    template = random.choice(templates)
    
    # Fill in placeholders
    title = template["title"].format(
        topic=random.choice(TOPICS),
        count=random.randint(3, 5)
    )
    description = template["description"].format(
        topic=random.choice(TOPICS),
        count=random.randint(3, 5)
    )
    
    return {
        "user_id": user_id,
        "title": title,
        "description": description,
        "category": template["category"],
        "pillar": pillar,
        "difficulty": template["difficulty"],
        "xp_reward": template["xp_reward"]
    }


def push_tasks(tasks: list) -> dict:
    """Push tasks to backend"""
    with httpx.Client() as client:
        response = client.post(
            f"{BACKEND_URL}/api/hermes/tasks/push",
            json=tasks,
            timeout=10.0
        )
        return response.json()


def main():
    """Main task generation loop"""
    print(f"[{datetime.now().isoformat()}] Starting task generation...")
    
    # Get users from backend (placeholder - would query all users)
    # For now, we'll generate tasks for a demo user
    demo_user_id = "34c81d18-8a4a-458f-8ddc-82bd57db467a"
    
    # Generate 3 tasks across different pillars
    tasks = []
    pillars = random.sample(list(TASK_TEMPLATES.keys()), 3)
    
    for pillar in pillars:
        task = generate_task(demo_user_id, pillar)
        tasks.append(task)
    
    # Push to backend
    result = push_tasks(tasks)
    
    print(f"[{datetime.now().isoformat()}] Generated {len(tasks)} tasks: {result}")
    return result


if __name__ == "__main__":
    main()
