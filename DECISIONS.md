# ProfileForge — DECISIONS

## D1 — No local Flutter SDK; CI is the build path
Termux/Android has no Flutter/Dart/Java. All real builds run on GitHub Actions.
Local verification = `flutter analyze`/`flutter test` via CI + static judge harness.

## D2 — 30-judge panel implemented as local Python harness, not 30 subagents
Subagents cannot run Flutter and would re-derive scores wastefully. A single harness
inspects real files (LOC, tests, a11y usage, arch layering) and scores each category
with reasoning. Iteration is per-category to ≥85. Honest, repeatable, cheap.

## D3 — Drift over Hive for the gamification domain
Spec mandates Drift 2.18+. Migrating from the legacy Hive `Profile` model to Drift
tables (profiles, streaks, xp_events, skins, leagues, missions, buddies, teams).
Hive retained only for trivial key-value flags during transition.

## D4 — External-credential features stubbed with honest TODOs
Google Maps/Places (H11) and live backend (H9) need secrets/infra absent here.
Architecture + domain models are built; I/O adapters are interface-sealed with
`// TODO(api-key)` markers. No fabricated data.
