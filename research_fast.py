#!/usr/bin/env python3
"""Fast pub.dev search - batch all queries."""
import json, urllib.parse, urllib.request, time, sys

def search(q, limit=3):
    url = "https://pub.dev/api/search?q=" + urllib.parse.quote(q) + "&limit=" + str(limit)
    try:
        with urllib.request.urlopen(url, timeout=8) as r:
            return [p["package"] for p in json.loads(r.read())["packages"]]
    except:
        return []

# All research categories
categories = {
    "ANIMATION_CORE": ["lottie", "rive", "confetti", "flutter_animate", "animations"],
    "SPRING_PHYSICS": ["sprung", "spring", "flutter_physics"],
    "HAPTICS": ["flutter_haptic_feedback", "haptic_feedback", "flutter_vibrate", "haptic_kit", "advanced_haptics"],
    "SHIMMER_SKELETON": ["shimmer", "skeletonizer", "auto_shimmer", "advanced_shimmer", "skeletonizer_plus"],
    "PARTICLES": ["particle_flow", "newton_particles", "flutter_optimized_particles", "particles_network"],
    "GLASS_GLOW": ["glow_effects", "neon_text", "liquid_glass", "backdrop_blur"],
    "GRADIENT_TEXT": ["animated_gradient_text", "flutter_gradient_animation_text", "glossy_text", "gradient_glow_border"],
    "TRANSITIONS": ["page_transition", "shared_element", "heroine", "morph_route", "circular_reveal_animation"],
    "ONBOARDING": ["onboarding_slider", "flutter_sliding_tutorial", "introduction_slider"],
    "COUNTERS": ["number_flow_flutter", "animated_flip_counter", "animated_number_flow", "fancy_counter", "animated_count_text"],
    "CHARTS": ["fl_chart", "syncfusion_flutter_charts", "awesome_circular_chart", "animated_fl_chart"],
    "ICONS": ["flutter_animated_icons", "flutter_lucide_animated", "icon_animated", "animated_icon_button"],
    "TOAST": ["toastification", "cherry_toast_msgs", "flutter_nice_toast", "motion_snackbar", "smart_snack"],
    "TEXT_ANIMATION": ["animated_text_kit", "typewriters_flutter", "animated_text_effects"],
    "BACKGROUND": ["bokeh_lava_gradient", "mesh", "aurora_background", "cool_background_animation", "flutter_moving_background"],
    "PARALLAX": ["flutter_parallax", "flutter_tilt", "parallax_cards", "parallax_sensors_bg"],
    "FLIP_CARD": ["flutter_flip_card", "flip_card_plus", "animated_flip_widget"],
    "STAGGERED": ["flutter_staggered_animations", "animate_x", "motion_kit", "flutter_sequence_animation"],
    "3D_CARD": ["hover_card", "perspective_space", "gyroscopic_card", "flutter_rotating_shining_card"],
    "LIST_ANIM": ["animated_list", "staggered_grid", "flutter_staggered_grid_view"],
    "PULL_REFRESH": ["liquid_pull_to_refresh", "shimmer_pull_to_refresh", "pull_to_refresh"],
}

results = {}
for cat, queries in categories.items():
    print(f"\n=== {cat} ===")
    for q in queries:
        pkgs = search(q)
        for p in pkgs:
            if p not in results:
                results[p] = cat
                print(f"  {p} ({cat})")

print(f"\n\n=== TOTAL UNIQUE PACKAGES: {len(results)} ===")
