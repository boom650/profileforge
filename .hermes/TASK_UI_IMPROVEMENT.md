# ProfileForge — Final UI/Design Improvement Task

## Current State (as of 2026-07-05)
- **Branch:** main
- **Latest commit:** 26a8da4 (location permission prompt)
- **CI:** APK #60 PASSED, Web #20 PASSED
- **APK:** https://github.com/boom650/profileforge/actions/runs/28752694187/artifacts/8092087553
- **Web:** https://github.com/boom650/profileforge/actions/runs/28752694190/artifacts/8092087937

## What's Done
1. GamificationService persists to SharedPreferences (XP, streak, missions, skins)
2. Dashboard shows real name, XP, streak, universities from providers
3. Check-in button wired to markDailyActive
4. Mission Start/Claim buttons wired with HapticFeedback
5. Tab navigation wired (View All → Missions, Gallery → Skins, Explore → Opportunities)
6. Opportunities work without GPS (city search fallback)
7. Location permission prompt on dashboard (Enable/Not now)
8. All hardcoded data eliminated
9. Conditional geolocator import (native/web/stub)
10. Real services: Nominatim, Overpass, NGO Darpan, Competition Calendar

## Task: Final UI/Design Improvement Run
Dispatch 3 parallel audit subagents:

### Agent 1: home_screen.dart (2066 lines)
Audit for:
- Text overflow/cut-off (missing `overflow: TextOverflow.ellipsis`, `maxLines`)
- Inconsistent padding (check all `EdgeInsets` values)
- Missing `const` constructors
- Row widgets that should use `Flexible`/`Expanded`
- Alignment issues
- Color contrast problems
- Missing error/empty states
- Layout breaks on small screens (320px width)
- Any hardcoded strings that should be dynamic

### Agent 2: All widgets + other screens
Files: lib/ui/widgets/ (streak_ring, mission_card, probability_radar, skin_showcase, opportunity_card, micro_interactions, empty_state) + lib/ui/screens/ (onboarding, privacy_screen)
Same issues as Agent 1.

### Agent 3: Theme consistency
Files: lib/ui/theme/app_theme.dart, pubspec.yaml
Check:
- Consistent font sizes (heading/body/caption)
- Consistent border radius
- Consistent spacing values
- Unused color constants
- Missing dependencies

After all 3 agents report, fix ALL issues in one commit, push, verify CI, give final links.

## How to Continue
Say: "continue" or "continue the UI improvement task"
The agent should read this file, dispatch the 3 audit agents, then fix everything.
