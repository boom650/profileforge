#!/usr/bin/env python3
"""Deep research: Flutter animation packages on pub.dev with version, description, score."""
import json
import urllib.parse
import urllib.request
import time

def search_pubdev(query, limit=5):
    url = "https://pub.dev/api/search?q=" + urllib.parse.quote(query) + "&limit=" + str(limit)
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            data = json.loads(resp.read().decode())
        return data.get("packages", [])
    except Exception as e:
        return []

def get_package_info(name):
    url = f"https://pub.dev/api/packages/{name}"
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            data = json.loads(resp.read().decode())
        latest = data.get("latest", {}).get("pubspec", {})
        score = data.get("score", {})
        return {
            "name": name,
            "version": latest.get("version", "?"),
            "description": latest.get("description", "?")[:120],
            "score": score.get("likePoints", 0),
            "popularity": score.get("popularityPoints", 0),
        }
    except Exception as e:
        return {"name": name, "error": str(e)}

# Phase 1: Comprehensive package search
queries = [
    # Core animation
    "lottie flutter",
    "rive flutter",
    "confetti flutter",
    "flutter_animate",
    "animations material motion",
    # Micro-interactions
    "spring physics flutter",
    "haptic feedback",
    "flutter_vibrate",
    # Visual effects
    "shimmer loading",
    "skeletonizer",
    "skeleton loading",
    "glow effect",
    "neon glow",
    "particle system flutter",
    "liquid glass",
    "backdrop blur glassmorphism",
    "gradient animation",
    "animated gradient text",
    # Transitions
    "page transition",
    "shared element transition",
    "hero animation",
    "circular reveal",
    "swipeable page route",
    # Onboarding
    "onboarding slider",
    "introduction screen",
    # Number/data visualization
    "animated counter number",
    "circular progress indicator",
    "step progress indicator",
    "animated chart",
    # Icons
    "animated icons",
    "lucide icons",
    # Toast/feedback
    "toast notification",
    "snackbar custom",
    # Typography
    "typewriter text",
    "typing animation",
    "text reveal animation",
    # Backgrounds
    "mesh gradient",
    "animated background",
    "aurora background",
    "bokeh particles",
    # 3D/tilt
    "3d tilt card",
    "perspective card",
    # Scroll
    "parallax scroll",
    "scroll reveal",
    "staggered list animation",
    "animated list",
    # Flip
    "flip card",
    # Pull to refresh
    "pull to refresh animation",
]

print("=== PHASE 1: COMPREHENSIVE PACKAGE SEARCH ===")
seen = set()
for q in queries:
    results = search_pubdev(q, limit=3)
    for p in results:
        name = p.get("package", "")
        if name not in seen:
            seen.add(name)
            info = get_package_info(name)
            print(f"{info.get('name', '?')} | v{info.get('version', '?')} | score={info.get('score', '?')} | pop={info.get('popularity', '?')} | {info.get('description', '?')[:80]}")
            time.sleep(0.1)

print(f"\nTotal unique packages found: {len(seen)}")
