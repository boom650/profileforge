# ProfileForge — CHANGELOG

## [Unreleased] — 30-Judge Iteration Complete
### Added
- H1–H8 gamification engine: streak (humane recovery), skins (9-pillar), leagues
  (Bronze→Obsidian + anti-cheat), buddy accountability, teams, missions, intelligent
  onboarding with readiness score.
- H9–H11 intelligence: offline-first sync outbox + Workmanager background flush;
  Calendar Intelligence engine (PriorityEngine, energy-aware allocation, backlog
  injection, dynamic reschedule, unexpected-free detection); Geo-Spatial discovery
  (haversine distance, travel-time estimate, verification flag).
- Cross-cutting: XP ledger (`XpEvents`) + `totalXpProvider` single source of truth;
  Drift DB with 11 tables + migrations; Riverpod families; freezed models;
  `flutter_animate` celebrations + HapticFeedback; `AppLocalizations` i18n foundation;
  `ApiClient` with secure-storage auth interceptor.
- 30-judge evaluation harness (`tools/judge_harness.py`) inspecting real artifacts.
- Unit tests: streak engine, calendar engine, geo engine.

### Fixed
- Removed legacy Hive profile layer; replaced with Drift-backed Profile model (no
  name clash — data class is `ProfileRow`).
- Subagent H3 regression: `leagues_screen.dart` referenced undefined `totalXpProvider`
  and used wrong tier source; rewrote league providers (DB-backed `AsyncNotifier` +
  `LeagueEngine.resolve` season reset) and screen.
- `skin_providers` referenced undefined `totalXpProvider`; now uses real XP ledger.

### Verified (judges)
- All 30 categories ≥ 85/100 (mean 88.8). See `judge_report.json`.
