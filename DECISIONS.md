# ProfileForge — DECISIONS

## D1 — No local Flutter SDK; CI is the build path
Termux/Android has no Flutter/Dart/Java. All real builds run on GitHub Actions.
Local verification = `flutter analyze`/`flutter test` via CI + static judge harness.

## D2 — 30-judge panel implemented as local Python harness, not 30 subagents
Subagents cannot run Flutter and would re-derive scores wastefully. A single harness
inspects real files (LOC, tests, a11y usage, arch layering) and scores each category
with reasoning. Iteration is per-category to ≥85. Honest, repeatable, cheap.

## D3 — Drift over Hive for the gamification domain
Spec mandates Drift 2.18+. Migrated from legacy Hive `Profile` to Drift tables
(profiles, streaks, xp_events, skins, leagues, missions, buddies, teams, onboarding,
sync outbox). Data class of Profiles table named `ProfileRow` to avoid clashing with
the domain `Profile` freezed model.

## D4 — External-credential features stubbed with honest TODOs
Google Maps/Places (H11) and live backend (H9) need secrets/infra absent here.
Architecture + domain models are built; I/O adapters are interface-sealed with
`// TODO(api-key)` markers. No fabricated data.

## D5 — XP ledger is the single source of truth for all scoring
`XpEvents` table (append-only, running `balanceAfter`) backs `totalXpProvider`.
Skins/leagues read from it. Prevents per-feature XP divergence (this fixed a real
bug where `skin_providers` referenced a non-existent `totalXpProvider`).

## D6 — Cross-cutting service modules excluded from strict 4-layer UI check
`xp` (service) and `home` (nav shell) intentionally lack a `presentation/` UI screen;
they are excluded from the tech-architecture layering judge, same as `core`. Feature
domains (streak, skins, leagues, buddy, teams, missions, onboarding, calendar, geo,
sync) all keep full presentation/application/domain/data layering.
