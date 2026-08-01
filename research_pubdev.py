#!/usr/bin/env python3
"""Research pub.dev for animation/UI packages relevant to ProfileForge."""
import json
import urllib.parse
import urllib.request

queries = [
    "flutter haptic feedback",
    "flutter sound effects game",
    "flutter particle system",
    "flutter glow effect neon",
    "flutter shimmer skeleton loading",
    "flutter animated counter number",
    "flutter liquid glass",
    "flutter mesh gradient background",
    "flutter blur background effect",
    "flutter shared element transition",
    "flutter hero animation page",
    "flutter morphing page route",
    "flutter onboarding slider",
    "flutter animated chart",
    "flutter circular progress custom",
    "flutter step progress indicator",
    "flutter animated icons",
    "flutter confetti party",
    "flutter spring physics",
    "flutter staggered animation",
    "flutter 3d tilt card",
    "flutter parallax",
    "flutter animated gradient text",
    "flutter ripple button",
    "flutter draw attention",
    "flutter reveal animation",
    "flutter flip card animation",
    "flutter typing indicator",
    "flutter toast notification",
    "flutter snackbar custom",
]

for q in queries:
    url = "https://pub.dev/api/search?q=" + urllib.parse.quote(q) + "&limit=5"
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            data = json.loads(resp.read().decode())
        names = [p["package"] for p in data.get("packages", [])]
        print(f"{q}: {names}")
    except Exception as e:
        print(f"{q}: ERROR {e}")
