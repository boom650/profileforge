#!/usr/bin/env python3
"""
Hermes Evaluation Processor

Reads pending evaluations from the bridge server,
evaluates them using Python heuristics (as a fallback),
and writes results back.

This script is called by the Hermes cron job.
The cron job's LLM intelligence handles the actual evaluation.
This script just manages the file I/O.
"""

import json
import os
import sys
import re
import time
from pathlib import Path

BASE_DIR = Path("/data/data/com.termux/files/home/profileforge")
PENDING_DIR = BASE_DIR / "backend" / "data" / "pending_evaluations"
RESULTS_DIR = BASE_DIR / "backend" / "data" / "evaluation_results"
TASKS_PENDING = BASE_DIR / "backend" / "data" / "pending_tasks"
TASKS_RESULTS = BASE_DIR / "backend" / "data" / "task_results"

RESULTS_DIR.mkdir(parents=True, exist_ok=True)
TASKS_RESULTS.mkdir(parents=True, exist_ok=True)


def evaluate_text(job):
    """Evaluate a text submission using multi-criteria scoring."""
    content = job.get("content", "")
    task_title = job.get("task_title", "General")

    if not content or len(content.strip()) < 10:
        return {"status": "rejected", "score": 0.0, "feedback": "Too short or empty."}

    word_count = len(content.split())
    sentences = [s.strip() for s in re.split(r'[.!?]+', content) if s.strip()]
    paragraphs = [p.strip() for p in content.split('\n\n') if p.strip()]
    if not paragraphs:
        paragraphs = [content]  # Single paragraph

    # Vocabulary richness
    words = [w.lower().strip('.,!?;:()') for w in content.split() if len(w) > 2]
    unique_ratio = len(set(words)) / max(len(words), 1)

    # Evidence indicators
    evidence_terms = ["according to", "research shows", "study found", "data indicates",
                      "statistics", "example", "evidence", "found that", "demonstrates",
                      "%", "million", "billion", "survey", "analysis", "published",
                      "journal", "university", "professors", "researchers"]
    evidence_count = sum(1 for t in evidence_terms if t in content.lower())

    # Structure indicators
    transitions = ["first", "second", "third", "finally", "in conclusion",
                   "moreover", "furthermore", "however", "therefore", "thus",
                   "additionally", "consequently", "for instance"]
    transition_count = sum(1 for t in transitions if t in content.lower())

    # Analysis indicators
    analysis_terms = ["because", "therefore", "however", "although",
                      "consequently", "this means", "as a result", "in contrast"]
    analysis_count = sum(1 for t in analysis_terms if t in content.lower())

    # Numbers/stats
    numbers = re.findall(r'\d+', content)

    # === SCORING ===
    # Relevance (25 points)
    relevance = 20 if word_count >= 100 else 12

    # Depth (25 points)
    if word_count >= 500:
        depth = 23
    elif word_count >= 300:
        depth = 20
    elif word_count >= 150:
        depth = 17
    elif word_count >= 80:
        depth = 14
    elif word_count >= 50:
        depth = 10
    else:
        depth = 4
    depth = min(25, depth + analysis_count * 3)

    # Structure (20 points)
    if len(paragraphs) >= 5:
        structure = 14
    elif len(paragraphs) >= 3:
        structure = 13
    elif len(paragraphs) >= 2:
        structure = 11
    else:
        structure = 8
    structure = min(20, structure + transition_count * 3)
    if len(sentences) > 3:
        s_lens = [len(s.split()) for s in sentences]
        if len(set(s_lens)) > 1:
            structure = min(20, structure + 3)

    # Evidence (15 points)
    evidence = min(12, evidence_count * 3)
    if len(numbers) >= 3:
        evidence = min(15, evidence + 3)
    elif len(numbers) >= 1:
        evidence = min(15, evidence + 1)

    # Language (15 points)
    language = 10
    if unique_ratio >= 0.7:
        language = 15
    elif unique_ratio >= 0.6:
        language = 13
    elif unique_ratio >= 0.5:
        language = 11

    total = relevance + depth + structure + evidence + language
    score = total / 100.0

    if total >= 70:
        status = "approved"
    elif total >= 50:
        status = "conditional"
    else:
        status = "rejected"

    breakdown = f"relevance:{relevance} depth:{depth} structure:{structure} evidence:{evidence} language:{language}"
    feedback = f"Score: {total}/100 ({breakdown})\nStatus: {status.upper()}\n\nWords: {word_count}, Paragraphs: {len(paragraphs)}, Sentences: {len(sentences)}\nVocabulary richness: {unique_ratio:.0%}\nEvidence indicators: {evidence_count}, Transitions: {transition_count}"

    return {"status": status, "score": score, "feedback": feedback, "total": total}


def generate_tasks(job):
    """Generate basic tasks (placeholder for Hermes LLM-powered generation)."""
    interests = job.get("interests", "technology, science")
    weak = job.get("weak_pillars", "balanced")

    tasks = [
        {
            "title": f"Research one competition in {interests}",
            "description": f"Find a real competition or opportunity related to {interests} that you can register for.",
            "pillar": "academic",
            "xp_reward": 15,
            "difficulty": "easy",
            "deadline_days": 3,
        },
        {
            "title": f"Complete a {weak} activity",
            "description": f"Do something that builds your {weak} pillar. This could be volunteering, research, or a project.",
            "pillar": weak.split(",")[0].strip() if weak != "balanced" else "community",
            "xp_reward": 25,
            "difficulty": "medium",
            "deadline_days": 5,
        },
    ]

    return {
        "tasks": tasks,
        "weekly_theme": f"Focus on {interests}",
        "motivation": "Keep building your profile!",
    }


def process_pending():
    """Process all pending evaluations."""
    processed = 0

    # Process evaluations
    for f in sorted(PENDING_DIR.glob("*.json")):
        try:
            with open(f) as fh:
                job = json.load(fh)

            if job.get("type") == "text_evaluation":
                result = evaluate_text(job)
            elif job.get("type") == "document_evaluation":
                result = {"status": "conditional", "score": 0.5, "feedback": "Document evaluation requires manual review."}
            else:
                result = {"status": "error", "feedback": f"Unknown job type: {job.get('type')}"}

            result["job_id"] = job["job_id"]
            result["processed_at"] = time.time()

            with open(RESULTS_DIR / f"{job['job_id']}.json", "w") as fh:
                json.dump(result, fh, indent=2)

            f.unlink()  # Remove from pending
            processed += 1
            print(f"  Processed {job['job_id']}: {result['status']}")

        except Exception as e:
            print(f"  Error processing {f.name}: {e}")

    # Process task generation
    for f in sorted(TASKS_PENDING.glob("*.json")):
        try:
            with open(f) as fh:
                job = json.load(fh)

            result = generate_tasks(job)
            result["job_id"] = job["job_id"]
            result["processed_at"] = time.time()

            with open(TASKS_RESULTS / f"{job['job_id']}.json", "w") as fh:
                json.dump(result, fh, indent=2)

            f.unlink()
            processed += 1
            print(f"  Generated tasks {job['job_id']}")

        except Exception as e:
            print(f"  Error generating tasks {f.name}: {e}")

    return processed


if __name__ == "__main__":
    print("Hermes Evaluation Processor")
    print("=" * 40)
    count = process_pending()
    print(f"\nProcessed: {count} jobs")
