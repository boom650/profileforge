# ProfileForge — ROADMAP

Autonomous AI-powered CV-building + hyper-scheduling platform for ambitious
high-school students targeting top international universities.

## Strategy
- **Client-first, offline-first.** All gamification + data live on-device (Drift/SQLite).
- **Clean architecture, feature-first.** `presentation / application / domain / data`.
- **CI is the only build path** (no local Flutter SDK). Every push → analyze + test +
  golden + integration + APK release.
- **30-judge harness** (`tools/judge_harness.py`) statically scores the real repo and
  drives per-category improvement until every category ≥ 85/100.

## Phases
### Phase One — Frontend Gamification Engine (H1–H8)  [IN PROGRESS]
- H1 Humane Streak System — ✅ building
- H2 Skin Reward System — ⬜
- H3 Weekly Leagues — ⬜
- H4 Buddy Accountability — ⬜
- H5 Teams — ⬜
- H6 Mission Framework — ⬜
- H7 Intelligent Onboarding — ⬜
- H8 Polish (a11y/anim/perf/retention) — ⬜

### Phase Two — Intelligence Engine (H9–H11)  [ARCHITECTED, stubbed]
- H9 Autonomous Backend (REST/WS/sync) — TODO (needs backend infra)
- H10 Calendar Intelligence — domain layer built, scheduling engine stubbed
- H11 Geo-Spatial Discovery — TODO (needs Google Maps/Places API keys)

## Retention targets (H8)
- D1 ≥ 55%, D7 ≥ 25%, D30 ≥ 18%.

## Quality gate
- No build ships red. 30-judge mean ≥ 85 before a phase is "done".
