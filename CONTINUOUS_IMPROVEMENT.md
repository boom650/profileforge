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

---

## Phase Two: Agent-Client Intelligence & Real-World Integration (H9-H11)

*These hypotheses extend the pipeline beyond Duolingo-level engagement into active intelligent agent-client architecture and real-world spatial grounding. They activate sequentially after H8 clears the quality gates.*

| ID | Title | Category | Priority | Expected Impact |
|----|-------|----------|----------|-----------------|
| H9 | Autonomous Hermes Agent Connectivity & Background Sync | Architecture | P0 | Seamless AI-task injection, zero-touch sync |
| H10 | Dynamic Calendar Logistics & Backlog Salvage Engine | Core Feature | P0 | +40% task completion, zero backlog rot |
| H11 | Geolocated Discovery Layer (External API Integration) | Core Feature | P0 | 3x hyper-local opportunity relevance |

### H9: Autonomous Hermes Agent Connectivity & Background Sync

**Objective**: Establish a bi-directional communication layer between the local Flutter client app and the remote Hermes research agent.

**Technical Specifications**:
- **New Service**: `lib/services/api/hermes_client.dart` — Secure REST/WebSocket client with exponential backoff, request signing, and token rotation.
- **Background Layer**: `flutter_background_service` (Android WorkManager / iOS BGTaskScheduler) — 15-min sync interval, battery-aware, network-aware.
- **Sync Protocol**:
  1. **Upstream** (Client → Hermes): Silent upload of profile deltas (interest shifts, target university changes, schedule drift, pillar XP velocity, streak health, league tier).
  2. **Downstream** (Hermes → Client): Fresh AI-scouted tasks (opportunities, micro-habits, research prompts, essay prompts) written atomically into local Drift SQLite via `TaskInboxTable`.
  3. **Conflict Resolution**: Last-write-wins with server-authoritative timestamps; local-only mutations queued for next sync.
- **Security**: Ed25519 request signing, per-device RSA key pair provisioned at first launch, TLS 1.3 pinned certs.
- **Observability**: Local sync log (max 100 entries) surfaced in Settings → Diagnostics; server-side sync latency SLA < 2s p95.

**Quality Gates**:
- Sync success rate ≥ 99.5% over 7 days
- Battery impact < 1% per day (Android Battery Historian)
- Zero UI thread blockage (sync runs in isolate)
- Zero data loss on app kill / OS reclaim

---

### H10: Dynamic Calendar Logistics & Backlog Salvage Engine

**Objective**: Bind task allocation strictly to calendar telemetry, enabling accurate micro-task injection and backlog recycling.

**Technical Specifications**:

**1. Calendar Telemetry Ingestion**
- **Source**: Device calendar (Android CalendarProvider / iOS EventKit) — read-only, user-granted permission.
- **Parsing Engine** (`lib/services/calendar/calendar_logistics.dart`):
  - Normalize events to UTC, collapse overlapping/recurring series.
  - Detect "open slots" ≥ 15 min between events, respecting user-defined focus buffers (default 15 min before/after).
  - Slot classification: `deep_work` (≥ 90 min), `shallow_work` (30-90 min), `micro` (15-30 min), `transit` (< 15 min).
- **User Preferences** (`CalendarSettings`): Working hours, focus buffers, sleep window, preferred deep-work days.

**2. Task-to-Slot Matching Algorithm**
- Each task carries `estimatedDuration` (minutes) and `energyLevel` (deep/shallow/micro).
- **Greedy Best-Fit**: Sort open slots by start time; for each task, pick earliest slot where `slot.duration ≥ task.duration + buffer` and `slot.classification ≥ task.energyLevel`.
- **Fallback**: If no exact fit, fragment task across consecutive micro-slots (max 2 fragments).
- **Output**: `ScheduledTask` entries written to `TaskScheduleTable` with `slotStartUtc`, `slotEndUtc`, `sourceSlotId`.

**3. Backlog Loop (Salvage Engine)**
- **Detection**: Daily cron (02:00 local) scans `TaskInboxTable` for tasks with `dueDate < now` and `status != completed`.
- **Penalty Score**: `penalty = daysOverdue * 10 + priorityWeight * 5 - completionStreak * 2`.
- **Motivator Protocol**:
  - **Phase 1 (Day 1-3)**: Gentle nudge via check-in ("You missed X — want to reschedule?").
  - **Phase 2 (Day 4-7)**: Auto-fragment into micro-tasks, inject into next 3 open slots.
  - **Phase 3 (Day 8+)**: Demote to "Someday" list, surface only during empty calendar weeks.
- **Recycle**: Completed backlogged tasks grant `backlogClearXP` (2x base) and restore `priorityWeight`.

**Data Model Extensions** (`lib/db/tables/all_tables.dart`):
```dart
// TaskBacklogTable
IntColumn get penaltyScore => integer().withDefault(const Constant(0))();
IntColumn get overdueDays => integer().withDefault(const Constant(0))();
IntColumn get recycleCount => integer().withDefault(const Constant(0))();
BoolColumn get isDemoted => boolean().withDefault(const Constant(false))();

// TaskScheduleTable
IntColumn get slotStartUtc => integer()();
IntColumn get slotEndUtc => integer()();
TextColumn get sourceSlotId => text().nullable()();
IntColumn get fragmentIndex => integer().withDefault(const Constant(0))();
IntColumn get fragmentCount => integer().withDefault(const Constant(1))();
```

**Quality Gates**:
- Slot match rate ≥ 85% for tasks with duration ≤ slot duration
- Backlog clearance rate ≥ 70% within 7 days
- Zero double-booked slots
- Calendar read latency < 500ms

---

### H11: Geolocated Discovery Layer (External API Integration)

**Objective**: Ground task suggestions in the physical world using production-grade spatial mapping.

**Technical Specifications**:

**1. Google Maps Platform Integration**
- **APIs**: Places API (New), Geocoding API, Distance Matrix API, Maps Static API.
- **Service Layer**: `lib/services/discovery/google_places_service.dart` — Retry logic, quota management (daily budget guard), response caching (24h TTL).
- **Keys**: Stored in Android Keystore / iOS Keychain; never in repo. Injected via `--dart-define=GMAPS_API_KEY=` at build time.

**2. Spatial Query Engine** (`lib/services/discovery/spatial_query.dart`)
- **Input**: User's home lat/lng (from onboarding), optional campus lat/lng, travel radius (default 25 km), transport mode (transit/walking/driving).
- **Queries**:
  - **NGO Volunteering**: `type=ngo` + `keyword=volunteer` + `radius=25000`
  - **Student Hackathons**: `type=establishment` + `keyword=hackathon` + `radius=50000`
  - **Design Workshops**: `type=establishment` + `keyword=design workshop` + `radius=30000`
  - **Seminars/Talks**: `type=establishment` + `keyword=seminar` + `radius=25000`
  - **ATL Labs / Makerspaces**: `type=establishment` + `keyword=atl lab|makerspace` + `radius=30000`
- **Filters**: Opening hours (must be open during user's free slots), rating ≥ 4.0, wheelchair accessible if needed.
- **Enrichment**: For each place, fetch details (phone, website, photos, reviews) and compute travel time via Distance Matrix API for user's preferred transport mode.

**3. Opportunity Injection Pipeline**
- **Deduplication**: Place ID + name + address hash → skip if exists in `OpportunityTable` within 90 days.
- **Scoring**: `relevance = 0.4*rating + 0.3*proximity + 0.2*categoryMatch + 0.1*recency`.
- **Injection**: Top 20 scored opportunities/week written to `OpportunityInboxTable` with `source=geolocated`, `verifiedAt=now`, `metadata={placeId, travelTime, transportMode, openingHours}`.
- **UI Surfacing**: "Near You" section on Opportunities screen with map clustering (`flutter_map` + `supercluster`).

**4. Map UI Integration**
- **Widget**: `OpportunitiesMapScreen` — `flutter_map` with `supercluster` for marker clustering.
- **Markers**: Custom icons per category (NGO, hackathon, workshop, seminar, ATL).
- **Clustering**: Zoom-based; cluster count badge; tap cluster → zoom to bounds.
- **Offline Cache**: `flutter_map` tile cache (100 MB) + place metadata cached in Drift for 7 days.

**Quality Gates**:
- API quota usage < 80% daily budget
- Place detail fetch latency < 2s p95
- Deduplication rate > 95%
- Map render time < 1s (cold), < 200ms (cached)
- Travel time accuracy within 15% of Google Maps baseline

---

### Phase Two Execution Protocol

1. **Activation Trigger**: After H8 evaluation report shows all quality gates green (judge score ≥ 85, pass rate ≥ 90%, visual regression 0 critical failures).
2. **Dispatch Order**: H9 → H10 → H11 (sequential; each must clear its own quality gates before next dispatches).
3. **Documentation**: Each hypothesis appends its implementation plan, API contracts, and test results to `improvement_pipeline/H{9,10,11}_plan.md`.
3. **Rollback**: If any hypothesis fails quality gates 3× consecutively, auto-revert to previous stable build and flag for manual review.

---

### API Key Requirements (User Action Required)

| Hypothesis | Key | Source | Purpose | Input Method |
|------------|-------------|--------------|
| H11 | Google Maps Platform (Places, Geocoding, Distance Matrix, Static Maps) | Provide via `--dart-define=GMAPS_API_KEY=` at build time; stored in Android Keystore / iOS Keychain at runtime |

**Action**: Please provide the Google Maps API key when ready for H11 implementation. The key must have Places API (New), Geocoding API, Distance Matrix API, and Maps Static API enabled.

---

### Updated Pipeline Diagram (Phase One + Phase Two)

```
┌─────────────────────────────────────────────────────────────────────┐
│              CONTINUOUS IMPROVEMENT PIPELINE (PHASE 1 + 2)         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  MON 9AM          MON 2PM          CONTINUOUS          1ST OF MONTH │
│  ┌───────────┐   ┌──────────────┐   ┌────────────┐  ┌──────────┐  │
│  │ AUTO-     │──▶│ IMPROVEMENT  │──▶│ MULTI-JUDGE│─▶│ MONTHLY  │  │
│  │ RESEARCH  │   │ PIPELINE     │   │ EVAL (30)  │  │ AUDIT    │  │
│  └───────────┘   └──────────────┘   └────────────┘  └──────────┘  │
│       │                │                   │              │         │
│       ▼                ▼                   ▼              ▼         │
│  ┌───────────┐   ┌──────────────┐   ┌────────────┐  ┌──────────┐  │
│  │ H1-H8     │   │ H9→H10→H11   │   │ 30 Judges  │  │ Quality  │  │
│  │ ENGAGE-   │   │ AGENT/       │   │ 8 Criteria │  │ Gate     │  │
│  │ MENT LOOP │   │ SPATIAL LOOP │   │ ≥85 avg    │  │ Review   │  │
│  └───────────┘   └──────────────┘   └────────────┘  └──────────┘  │
│                                                                     │
│  EVERY BUILD                                                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ VISUAL REGRESSION (26 Playwright) + APK BUILD + EVAL REPORT │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Updated Quality Gates (Phase Two Additions)

| Gate | H9 | H10 | H11 |
|------|-----|-----|-----|
| Sync success rate | ≥ 99.5% | — | — |
| Battery impact | < 1%/day | — | — |
| Slot match rate | — | ≥ 85% | — |
| Backlog clearance | — | ≥ 70%/7d | — |
| Calendar read latency | — | < 500ms | — |
| API quota usage | — | — | < 80% |
| Place detail latency | — | — | < 2s p95 |
| Deduplication rate | — | — | > 95% |
| Map render time | — | — | < 1s cold / 200ms cached |

---

### Next Actions

1. **Commit this document** to `CONTINUOUS_IMPROVEMENT.md`.
2. **Wait for H8 evaluation** to clear (monitor GitHub Actions).
3. **Provide Google Maps API key** when ready for H11 (reply with key or "skip H11 for now").
3. **Pipeline will auto-dispatch H9** once H8 gates clear — no manual trigger needed.

The Phase Two roadmap is now formally appended to the continuous improvement ledger. The system will proceed autonomously from H8 → H9 → H10 → H11.