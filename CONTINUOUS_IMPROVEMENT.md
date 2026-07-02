# ProfileForge Continuous Improvement System

## Overview

This document describes the complete continuous improvement pipeline for ProfileForge - a gamified college admissions profile builder for Indian 11th graders targeting international universities.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CONTINUOUS IMPROVEMENT PIPELINE                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  MONDAY 9:00 AM          MONDAY 2:00 PM          CONTINARY          1ST OF MONTH   │
│  ┌─────────────────┐     ┌──────────────────┐    ┌──────────────┐  │
│  │  AUTO-RESEARCH  │────▶│ IMPROVEMENT      │───▶│ MONTHLY      │  │
│  │  & TREND ANALYSIS│     │ PIPELINE         │    │ QUALITY AUDIT│  │
│  └─────────────────┘     └──────────────────┘    └──────────────┘  │
│         │                       │                       │           │
│         ▼                       ▼                       ▼           │
│  ┌─────────────────┐     ┌──────────────────┐    ┌──────────────┐  │
│  │ Research Data   │     │ Hypothesis       │    │ Audit Report │  │
│  │ • Duolingo      │     │ Selection        │    │ • Code Qual  │  │
│  │   benchmarks    │     │ Implementation   │    │ • Perf       │  │
│  │ • Admissions    │     │ Coding Agent     │    │ • A11y       │  │
│  │   trends        │     │ Build & Deploy   │    │ • Security   │  │
│  │ • UI/UX patterns│     │ Evaluation       │    │ • UX Metrics │  │
│  │ • Competitors   │     │ Next Iteration   │    │ • Features   │  │
│  └─────────────────┘     └──────────────────┘    └──────────────┘  │
│                                                                     │
│  EVERY BUILD (PR + MAIN)                                           │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ MULTI-JUDGE EVALUATION (20-40 judges)                         │   │
│  │ • 6 UI/UX Experts          • 5 Admissions Experts           │   │
│  │ • 5 Gamification Designers • 8 Student Users (11th grade)   │   │
│  │ • 3 Parents/Guardians      • 4 Counselors/Educators         │   │
│  │ • 3 Technical Reviewers                                          │   │
│  │ 8 Criteria, 100 pts each, Target: ≥85 weighted avg, ≥90% pass │   │
│  └─────────────────────────────────────────────────────────────┘   │
│         │                                                           │
│         ▼                                                           │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ VISUAL REGRESSION TESTING (Playwright)                        │   │
│  │ • 26 scenarios covering all flows                             │   │
│  │ • Light/Dark mode                                             │   │
│  │ • Mobile viewport (390x844)                                   │   │
│  │ • CLS measurement, console error detection                    │   │
│  │ • 9 critical onboarding screens must pass                     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Workflow Files

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| `auto-research.yml` | Mon 9:00 AM | Research Duolingo, admissions trends, UI/UX patterns |
| `continuous-improvement.yml` | Mon 2:00 PM | Select hypothesis, dispatch implementation, evaluate |
| `implement-hypothesis.yml` | On demand | Generate plan, dispatch coding agent |
| `multi-judge-evaluation.yml` | Every build | 30-judge panel evaluation |
| `visual-regression.yml` | Every build | Playwright visual tests |
| `build-apk.yml` | Every push | Build release APK |

## Judge Panel Composition (30 Judges)

| Persona | Count | Focus Areas | Weight |
|---------|-------|-------------|--------|
| UI/UX Experts | 6 | Visual design, interaction, accessibility, motion, brand | 1.2 |
| Gamification Designers | 5 | Retention, rewards, progression, social, balance | 1.2 |
| Admissions Experts | 5 | Probability accuracy, activity tiers, college data | 1.0 |
| Student Users (11th grade) | 8 | Engagement, usability, value prop, onboarding | 1.0 |
| Parents/Guardians | 3 | Trust, privacy, progress visibility, value, safety | 1.0 |
| Counselors/Educators | 4 | Verification, bulk tools, recommendations, integration | 1.0 |
| Technical Reviewers | 3 | Performance, offline, sync, architecture, security | 1.0 |

## Evaluation Criteria (100 points each)

| Criterion | Weight | Target |
|-----------|--------|--------|
| Visual Design | 15% | ≥85 |
| Interaction Design | 15% | ≥85 |
| Gamification Depth | 15% | ≥85 |
| Onboarding Experience | 10% | ≥85 |
| Core Value Delivery | 15% | ≥85 |
| Technical Excellence | 10% | ≥85 |
| Accessibility | 10% | ≥85 |
| Engagement Potential | 10% | ≥85 |

**Pass Thresholds:**
- Weighted average ≥ 85/100
- Pass rate ≥ 90% (judges scoring ≥85)
- All P0 criteria ≥ 80

## Visual Regression Test Scenarios (26)

### Critical (9 onboarding screens - MUST PASS)
1. Welcome screen
2. Consent screen
3. Location & School
4. Academic Profile
5. Activity Inventory
6. Target Universities
7. Schedule Builder
8. Motivation & Personality
9. Roadmap

### Core Flows
10. Home screen (Light)
11. Home screen (Dark)
12. Missions screen
13. Daily Missions
14. Streaks
15. Skins Collection
16. Leaderboard
17. Opportunities Map
18. Opportunities List
19. Opportunity Detail (ATL)
20. Admissions Dashboard
21. University Detail (MIT)
22. Profile Screen
23. Settings Screen

## Hypotheses Pipeline

| ID | Title | Category | Priority | Expected Impact |
|----|-------|----------|----------|-----------------|
| H1 | Duolingo-style Streak System | Gamification | P0 | D1: 40%→55%, D30: 12%→18% |
| H2 | Skin-based Visual Rewards (9 tiers) | Gamification | P0 | Session +40%, Sharing 3x |
| H3 | Weekly Mission Leagues | Gamification | P0 | WAU +60% |
| H4 | Dynamic Material 3 Theming | UI/UX | P1 | Visual delight 9+/10 |
| H5 | ML Admissions Probability | Core Feature | P1 | >50% accuracy top 50 unis |
| H6 | Hyper-local Opportunity Discovery | Core Feature | P1 | 3x applications, 80% relevance |
| H7 | Interactive 9-screen Onboarding | UI/UX | P0 | Completion >85% |
| H8 | Counselor Dashboard | Growth | P1 | School adoption driver |

## Quality Gates

### Every PR
- `flutter analyze` - zero errors
- `flutter test` - >80% coverage
- `dart run build_runner` - generates cleanly
- Visual regression (critical paths)
- Accessibility audit (axe-core)

### Every Main Build
- Full multi-judge evaluation (30 judges)
- Complete visual regression (26 scenarios)
- Release APK build + artifact upload
- Evaluation report generation

### Monthly (1st of month)
- Code quality audit
- Performance benchmarks
- Accessibility compliance check
- Security audit
- UX metrics review
- Feature completeness verification

## Target Metrics (Duolingo Benchmarks)

| Metric | Current Target | Duolingo Benchmark |
|--------|----------------|-------------------|
| D1 Retention | 55% | 55% |
| D7 Retention | 35% | 35% |
| D30 Retention | 18% | 18% |
| Session Length | 8 min | 8-10 min |
| Daily Sessions/User | 1.5 | 1.5-2 |
| Crash-free Sessions | 99.5% | 99.9% |
| App Store Rating | 4.7+ | 4.7-4.8 |
| Onboarding Completion | 85% | 80-85% |

## Getting Started

### Manual Trigger Research
```bash
gh workflow run auto-research.yml --ref main -f depth=9
```

### Manual Trigger Evaluation
```bash
gh workflow run multi-judge-evaluation.yml --ref main \
  -f build_artifact=app-release \
  -f num_judges=30 \
  -f evaluation_mode=comprehensive
```

### Manual Trigger Visual Tests
```bash
gh workflow run visual-regression.yml --ref main \
  -f test_suite=full
```

### Manual Trigger Full Pipeline
```bash
gh workflow run continuous-improvement.yml --ref main \
  -f force_run=true
```

### Implement Specific Hypothesis
```bash
gh workflow run implement-hypothesis.yml --ref main \
  -f hypothesis_id=H1 \
  -f hypothesis_title="Duolingo-style Streak System" \
  -f category=gamification
```

## Directory Structure

```
.github/
├── workflows/
│   ├── auto-research.yml           # Monday 9AM research
│   ├── continuous-improvement.yml  # Monday 2PM pipeline
│   ├── implement-hypothesis.yml    # Coding agent dispatch
│   ├── multi-judge-evaluation.yml  # 30-judge panel
│   ├── visual-regression.yml       # Playwright tests
│   ├── build-apk.yml              # Release APK build
│   └── continuous-improvement/     # Pipeline configs
├── scripts/
│   └── visual_tests.py            # Playwright test runner
├── research/                      # Auto-research outputs
├── improvement_pipeline/          # Hypotheses & plans
├── evaluations/                   # Judge evaluation results
└── visual_tests/                  # Screenshots

profileforge/
├── lib/
│   ├── models/gamification/       # Skins, streaks, XP, missions
│   ├── services/gamification/     # Core game logic
│   ├── ui/screens/               # All screens
│   ├── ui/widgets/               # Reusable components
│   └── db/                       # Drift database
└── test/                          # Unit & widget tests
```

## Next Steps

1. **Push to GitHub** - All workflows will activate on schedule
2. **Configure Secrets** - Add any API keys needed for research
3. **First Run** - Trigger manually to verify pipeline
4. **Monitor** - Check GitHub Actions for first research cycle
5. **Iterate** - Pipeline will auto-select H1 (streaks) for implementation

The system is designed to be fully autonomous - research runs weekly, hypotheses are prioritized, coding agents implement, judges evaluate, and the cycle repeats until all metrics meet Duolingo benchmarks.