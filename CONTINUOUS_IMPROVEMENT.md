# ProfileForge — CONTINUOUS IMPROVEMENT

This file is the living status of the autonomous improvement loop.

## Loop
1. `tools/judge_harness.py` scores the repo across 30 categories.
2. Categories < 85 produce concrete code tasks (see TASKS.md).
3. Implement highest-impact fix → commit → push → CI builds APK.
4. Re-run harness; repeat until all ≥ 85.
5. Every commit updates ROADMAP/CHANGELOG/DECISIONS/TECH_DEBT.

## Current mean score
See `tools/judge_harness.py` output (`judge_report.json`). Baseline captured at
foundation commit.

## Hypotheses (next highest-impact)
- H: Humane streak recovery > strict streaks for D30 retention.
- H: Pillar-aligned skins increase profile-completion rate.
- H: Weekly leagues with shields reduce bottom-tier churn.
