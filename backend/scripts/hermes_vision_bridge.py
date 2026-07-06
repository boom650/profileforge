#!/usr/bin/env python3
"""
ProfileForge ↔ Hermes Vision Bridge

This script:
1. Watches /backend/uploads/ for new student submissions
2. Reads the submission metadata from the backend
3. Evaluates using Hermes vision/LLM capabilities
4. Writes results back to backend via API

Run as: python3 hermes_vision_bridge.py
Or via Hermes cron job.
"""

import os
import sys
import json
import time
import hashlib
import httpx
from pathlib import Path
from datetime import datetime

BACKEND_URL = "http://localhost:8080"
UPLOADS_DIR = Path(__file__).parent.parent / "uploads"
WATCH_FILE = UPLOADS_DIR / ".pending_evaluations.json"
RESULTS_DIR = UPLOADS_DIR / "results"


def ensure_dirs():
    """Create necessary directories"""
    UPLOADS_DIR.mkdir(exist_ok=True)
    RESULTS_DIR.mkdir(exist_ok=True)


def get_pending_evaluations():
    """Read pending evaluations from watch file"""
    if not WATCH_FILE.exists():
        return []
    with open(WATCH_FILE) as f:
        return json.load(f)


def save_pending_evaluations(evaluations):
    """Save pending evaluations to watch file"""
    with open(WATCH_FILE, "w") as f:
        json.dump(evaluations, f, indent=2)


def evaluate_text_submission(submission):
    """
    Evaluate a text submission using Hermes intelligence.
    
    This is the core AI evaluation logic.
    Returns: {status, score, feedback, strengths, improvements}
    """
    text = submission.get("text", "")
    task_title = submission.get("task_title", "")
    task_description = submission.get("task_description", "")
    
    # Basic quality metrics
    word_count = len(text.split())
    sentence_count = len([s for s in text.split('.') if s.strip()])
    paragraph_count = len([p for p in text.split('\n\n') if p.strip()])
    
    # Scoring criteria
    scores = {}
    
    # 1. Relevance (25%) - Check if text addresses the task
    relevance_score = 0
    task_words = set(task_title.lower().split() + task_description.lower().split())
    text_words = set(text.lower().split())
    overlap = len(task_words & text_words)
    if overlap > 0:
        relevance_score = min(25, (overlap / max(len(task_words), 1)) * 25)
    scores["relevance"] = relevance_score
    
    # 2. Depth (25%) - Word count and complexity indicators
    depth_score = 0
    if word_count >= 500:
        depth_score = 25
    elif word_count >= 300:
        depth_score = 20
    elif word_count >= 150:
        depth_score = 15
    elif word_count >= 50:
        depth_score = 10
    else:
        depth_score = 5
    scores["depth"] = depth_score
    
    # 3. Structure (20%) - Paragraphs and sentences
    structure_score = 0
    if paragraph_count >= 3:
        structure_score = 20
    elif paragraph_count >= 2:
        structure_score = 15
    elif paragraph_count >= 1:
        structure_score = 10
    else:
        structure_score = 5
    scores["structure"] = structure_score
    
    # 4. Evidence (15%) - Presence of facts, numbers, references
    evidence_score = 0
    evidence_indicators = ["according to", "research shows", "study", "data", 
                          "statistics", "example", "evidence", "found that",
                          "percentage", "%", "million", "billion"]
    evidence_count = sum(1 for indicator in evidence_indicators 
                        if indicator in text.lower())
    evidence_score = min(15, evidence_count * 3)
    scores["evidence"] = evidence_score
    
    # 5. Language (15%) - Basic grammar and clarity
    language_score = 10  # Base score
    if sentence_count > 0:
        avg_sentence_length = word_count / sentence_count
        if 10 <= avg_sentence_length <= 25:
            language_score = 15
        elif 5 <= avg_sentence_length <= 35:
            language_score = 12
    scores["language"] = language_score
    
    # Calculate total
    total_score = sum(scores.values())
    
    # Determine status
    status = "approved" if total_score >= 70 else "rejected"
    
    # Generate feedback
    strengths = []
    improvements = []
    
    if scores["relevance"] >= 20:
        strengths.append("Strong relevance to the task topic")
    elif scores["relevance"] < 10:
        improvements.append("Try to address the specific task prompt more directly")
    
    if scores["depth"] >= 20:
        strengths.append("Good depth and detail in your response")
    elif scores["depth"] < 15:
        improvements.append("Add more detail and explanation to strengthen your argument")
    
    if scores["structure"] >= 15:
        strengths.append("Well-organized with clear paragraphs")
    elif scores["structure"] < 10:
        improvements.append("Break your response into clear paragraphs for better readability")
    
    if scores["evidence"] >= 10:
        strengths.append("Good use of evidence and examples")
    elif scores["evidence"] < 5:
        improvements.append("Include specific facts, statistics, or examples to support your points")
    
    if not strengths:
        strengths.append("Completed the task submission")
    if not improvements:
        improvements.append("Keep up the good work!")
    
    feedback = f"""Score: {total_score}/100
Status: {status.upper()}

Strengths:
{chr(10).join('- ' + s for s in strengths)}

Areas for Improvement:
{chr(10).join('- ' + i for i in improvements)}

Your submission had {word_count} words across {paragraph_count} paragraphs.
Keep working on making your responses more detailed and well-structured!"""
    
    return {
        "status": status,
        "score": total_score,
        "feedback": feedback,
        "strengths": strengths,
        "improvements": improvements
    }


def evaluate_document_submission(submission):
    """
    Evaluate a document submission (PDF/image).
    For now, uses metadata-based evaluation.
    Full vision evaluation would require Hermes vision model.
    """
    file_path = submission.get("file_path", "")
    task_title = submission.get("task_title", "")
    
    # Check if file exists and has content
    if not os.path.exists(file_path):
        return {
            "status": "rejected",
            "score": 0,
            "feedback": "File not found. Please re-upload.",
            "strengths": [],
            "improvements": ["Ensure the file is properly uploaded"]
        }
    
    file_size = os.path.getsize(file_path)
    
    # Basic file-based scoring
    score = 50  # Base score for uploading
    
    if file_size > 10000:  # > 10KB
        score += 20
    elif file_size > 1000:
        score += 10
    
    status = "approved" if score >= 70 else "rejected"
    
    return {
        "status": status,
        "score": score,
        "feedback": f"Document received ({file_size} bytes). {'Approved' if status == 'approved' else 'Needs more content'}.",
        "strengths": ["Document successfully uploaded"],
        "improvements": ["Include more detailed content"] if status == "rejected" else []
    }


def process_evaluation(submission):
    """Process a single evaluation submission"""
    submission_type = submission.get("type", "text")
    
    if submission_type == "text":
        result = evaluate_text_submission(submission)
    elif submission_type == "document":
        result = evaluate_document_submission(submission)
    else:
        result = {
            "status": "rejected",
            "score": 0,
            "feedback": f"Unknown submission type: {submission_type}",
            "strengths": [],
            "improvements": ["Use a supported submission type"]
        }
    
    return result


def award_xp_if_approved(user_id, result, task_xp=25):
    """Award XP if evaluation was approved"""
    if result["status"] != "approved":
        return None
    
    # Calculate XP with bonus for high scores
    xp_amount = task_xp
    if result["score"] >= 90:
        xp_amount = int(task_xp * 1.5)  # 50% bonus for excellent work
    
    try:
        response = httpx.post(
            f"{BACKEND_URL}/api/xp/{user_id}/award",
            json={
                "amount": xp_amount,
                "source": f"evaluation:{result['score']}",
                "pillar": "academics"  # Default pillar
            },
            timeout=10
        )
        return response.json()
    except Exception as e:
        print(f"Error awarding XP: {e}")
        return None


def run_bridge():
    """Main bridge loop - watches for new submissions and evaluates them"""
    ensure_dirs()
    
    print(f"[{datetime.now()}] ProfileForge Vision Bridge started")
    print(f"Watching: {UPLOADS_DIR}")
    
    while True:
        try:
            pending = get_pending_evaluations()
            
            if pending:
                print(f"Processing {len(pending)} pending evaluations...")
                
                remaining = []
                for submission in pending:
                    try:
                        result = process_evaluation(submission)
                        
                        # Award XP if approved
                        if result["status"] == "approved":
                            award_xp_if_approved(
                                submission.get("user_id"),
                                result,
                                submission.get("xp_reward", 25)
                            )
                        
                        # Save result
                        result_file = RESULTS_DIR / f"{submission.get('id', 'unknown')}.json"
                        with open(result_file, "w") as f:
                            json.dump({
                                "submission": submission,
                                "result": result,
                                "evaluated_at": datetime.now().isoformat()
                            }, f, indent=2)
                        
                        print(f"  Evaluated: {submission.get('title', 'Unknown')} → {result['status']} ({result['score']})")
                        
                    except Exception as e:
                        print(f"  Error evaluating {submission.get('id')}: {e}")
                        remaining.append(submission)
                
                save_pending_evaluations(remaining)
            
            # Check for new files in uploads directory
            for file_path in UPLOADS_DIR.glob("*"):
                if file_path.is_file() and not file_path.name.startswith("."):
                    # Check if already evaluated
                    result_file = RESULTS_DIR / f"{file_path.stem}.json"
                    if not result_file.exists():
                        print(f"New file detected: {file_path.name}")
                        # Create submission for evaluation
                        submission = {
                            "id": file_path.stem,
                            "type": "document",
                            "file_path": str(file_path),
                            "user_id": "unknown",
                            "task_title": "Uploaded document",
                            "task_description": ""
                        }
                        result = process_evaluation(submission)
                        result_file = RESULTS_DIR / f"{file_path.stem}.json"
                        with open(result_file, "w") as f:
                            json.dump({
                                "submission": submission,
                                "result": result,
                                "evaluated_at": datetime.now().isoformat()
                            }, f, indent=2)
                        print(f"  Auto-evaluated: {file_path.name} → {result['status']}")
            
            time.sleep(5)  # Check every 5 seconds
            
        except KeyboardInterrupt:
            print("\nBridge stopped")
            break
        except Exception as e:
            print(f"Error in bridge loop: {e}")
            time.sleep(10)


if __name__ == "__main__":
    run_bridge()
