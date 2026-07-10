# Master Improvement Plan (Judge #23)

**Overall Completeness Score: 25/100**

This score reflects a project with foundational scaffolding in place but critical execution gaps. Many features declared in CONTINUOUS_IMPROVEMENT.md exist as file stubs only. Real user-facing functionality, test coverage, and data flow between frontend and backend are missing.

---

## Priority Categorization

- **Must-Fix** (< 50): Testing, API Design/Backend
- **Should-Fix** (30-60): UX Flow, CI/CD
- **Nice-to-Have** (> 20): i18n, Accessibility

---

## 1. Testing — 5/100 (Must-Fix)

10 test files exist across `test/`. Only `gamification_service_test.dart` has real assertions (~340 lines). All other test files are stubs. Zero widget tests. Zero integration tests. Zero backend tests.

### Specific Actionable Tasks

- **Write backend API tests** (`backend/tests/`)
  - Add pytest tests for all FastAPI endpoints in `server.py`
  - Use `httpx.AsyncClient` for async request testing
  - Cover: user creation, profile CRUD, mission sync, streak data endpoints
  - The `build.yml` has a `backend-test` job — make it pass with real tests

- **Implement widget tests** (`test/widgets/`)
  - `StreakRing` — test renders correct streak number, freeze tokens display, weekend amulet badge, onCheckIn callback fires
  - `MissionCard` — test active state (progress bar visible), completed state (Done badge), claimed state (claim button hidden)
  - `OnboardingFlow` — test navigation between 8 screens, form validation triggers for Screen2/Screen3, _nextPage blocks when invalid
  - `DashboardTab` — test streak section renders, XP progress bar, missions preview list

- **Write integration tests** (`test/integration/`)
  - Full onboarding flow: welcome → consent → quick profile → goals → activities → timetable → schedule → roadmap → complete → lands on HomeScreen
  - Daily check-in flow: tap streak check-in → XP animation shown → streak counter increments
  - Skin equip flow: navigate to skins tab → tap locked skin (no-op) → tap unlocked skin → equipped skin changes

- **Enforce coverage gates in CI**
  - Add `flutter test --coverage` threshold step in `build.yml`
  - Start at 20% line coverage, increase weekly by 10% until 80%
  - Fail PR build if coverage drops

---

## 2. API Design & Backend Integration — 15/100 (Must-Fix)

FastAPI backend (`backend/server.py`, 63KB) exists with extensive endpoints. The Flutter frontend (`lib/services/`, `lib/providers/`) is completely disconnected — providers return hardcoded stubs. The `api_service.dart` exists but is never called.

### Specific Actionable Tasks

- **Connect GamificationService to backend**
  - `lib/services/gamification/gamification_service.dart` — replace `SharedPreferences` persistence with HTTP calls to backend `/gamification/state` endpoint
  - `gamification_providers.dart` — make providers read from service's HTTP client, not from in-memory state only

- **Create API client layer** (`lib/services/api_client.dart`)
  - Use `dio` (already in `pubspec.yaml`)
  - Base URL from config, token-based auth, error interceptor
  - Models: `ApiResponse<T>`, `ApiError`

- **Implement backend ↔ frontend data contracts**
  - Align Pydantic models in `backend/server.py` with Dart model classes
  - Add `fromJson`/`toJson` serialization to match API JSON structure

- **Wire onboarding completion to backend**
  - `OnboardingFlow._completeOnboarding()` calls `ref.read(api_service_provider)` to POST `/users`
  - Store returned `userId` in secure storage (flutter_secure_storage already in deps)

---

## 3. UX Flow — 30/100 (Should-Fix)

App has 186 Dart files across extensive screen library. Core flows are broken: onboarding too long (8 screens), empty onPressed callbacks throughout (verified in code), no loading/error states on async actions, swipe gestures disabled with `NeverScrollableScrollPhysics`.

### Specific Actionable Tasks

- **Consolidate onboarding from 8 to 4 screens**
  - Merge Screen10 (SchoolTimetable) + Screen11 (FreeSlots) + Screen12 (SchoolFrequency) into single "My Schedule" screen
  - Defer subject scores to post-onboarding (Screen2QuickProfile)
  - Add "Skip for now" on non-essential fields

- **Fix all empty onPressed handlers**
  - Grep `onPressed: () {}` across `lib/ui/` — add real callbacks or at minimum `HapticHelper.light()`
  - Targeted files: `home_screen.dart`, `dashboard_tab.dart`, `opportunities_tab.dart`

- **Add loading/error/empty states to every screen**
  - `AsyncValue.when` pattern in every Riverpod consumer widget
  - Key screens missing: `OpportunitiesTab`, `MissionsTab`, `SkinsTab`, `LeaderboardScreen`

- **Enable swipe gestures**
  - Replace `NeverScrollableScrollPhysics` in `OnboardingFlow` and `HomeScreen` PageViews with `BouncingScrollPhysics`
  - Add swipe-to-dismiss on notification cards

- **Implement streak check-in visual feedback**
  - `StreakRing` `onCheckIn` → call `markDailyActiveProvider`
  - On success: animate ring fill, show XP earned toast, trigger `CelebrationOverlay` on milestones
  - On error: show `SnackBar` with retry option

- **Close mission reward loop**
  - `MissionCard`: if `isCompleted && !isClaimed`, show "Claim" button
  - Tap → `claimMissionRewardProvider` → animate XP counter → mark claimed
  - Refresh provider state after claim

---

## 4. CI/CD — 60/100 (Should-Fix)

Build workflows (`.github/workflows/`) are surprisingly comprehensive: `build.yml` has lint+test, build-matrix, web build, backend test, release, and notify jobs. `visual-regression.yml` has Playwright + axe-core scaffolds. `continuous-improvement.yml` has multi-step pipeline.

However, `visual-regression.yml` has a **broken scenario entry** (scenario 3 is missing `name` field — uses `"text=Location"` as name). `continuous-improvement.yml` has Python string concatenation bugs that would fail at runtime. Accessibility audit job in `visual-regression.yml` runs axe-core against localhost:8080 but no local server is started in that job.

### Specific Actionable Tasks

- **Fix broken scenario in `visual_tests.py`**
  - Line 36: `{"name": "text=Location", ...}` has wrong key — should be:
    ```python
    {"name": "onboarding_03_location", "path": "/#/onboarding/location", "wait_for": "text=Location", "viewport": {"width": 390, "height": 844}},
    ```
  - Validate all 24 scenarios have correct key structure (`name`, `path`, `wait_for`, `viewport`)

- **Fix continuous-improvement.yml bugs**
  - Lines 128-138: Python `>>` redirect inside `print()` doesn't write to GITHUB_OUTPUT — replace with `with open(os.environ["GITHUB_OUTPUT"], "a") as fh: fh.write(...)"`
  - Line 142: `| lower` filter not valid in GitHub Actions expression — use `$(echo "${{ steps.select.outputs.selected_hypothesis }}" | tr '[:upper:]' '[:lower:]')`

- **Fix accessibility audit job**
  - Start `python3 -m http.server 8080 &` before running `npx axe`
  - Use correct `@axe-core/cli` package name (currently `@axe-core/cli`, was `axe-core` before v4)
  - Capture exit code and fail workflow on ≥1 WCAG AA violation found

- **Add scheduled maintenance workflow**
  - Weekly `cron: '0 6 * * 0'` job that runs `flutter analyze` and posts results to issue
  - Catch lint regressions before they land on main

- **Add PR comment with test diff**
  - On PR, run `flutter test --machine` and post formatted summary
  - Show which tests passed/failed, total runtime, coverage delta

---

## 5. Internationalization (i18n) — 40/100 (Nice-to-Have)

Project has `l10n.yaml` config, `flutter_localizations` sdk dependency, `app_en.arb` with 651 strings, supported locales in `main.dart`. **However, no widget uses `AppLocalizations`** — `grep` across `lib/` shows zero references. All 9 non-English locales listed in `preferred-supported-locales` have no corresponding ARB file.

### Specific Actionable Tasks

- **Create missing ARB files**
  - Generate `app_hi.arb`, `app_ta.arb`, `app_te.arb`, `app_bn.arb`, `app_mr.arb`, `app_gu.arb`, `app_kn.arb`, `app_ml.arb`, `app_pa.arb`
  - Start with machine translation for all 651 keys, flag for review

- **Replace all hardcoded strings with AppLocalizations**
  - `lib/ui/theme/app_theme.dart` — no strings there (good)
  - `lib/ui/widgets/*.dart` — all `Text(...)` calls → `Text(AppLocalizations.of(context)!.keyName)`
  - `lib/ui/screens/**/*.dart` — same treatment
  - Priority: onboarding screens, home tab labels, settings

- **Wire locale switching in SettingsScreen**
  - Add language picker dropdown in `settings_screen.dart`
  - Store locale code in SharedPreferences
  - Wrap `MaterialApp` in `TranslatedApp` or use `localeProvider` state

---

## 6. Accessibility (a11y) — 20/100 (Nice-to-Have)

Only **1 Semantics widget** exists in entire codebase (`lib/ui/screens/home/profile_tab.dart`). `analysis_options.yaml` has some good lint rules but none specific to a11y. No screen reader labels on icon buttons. Touch targets unverified. Color contrast not measured.

### Specific Actionable Tasks

- **Add semantics labels to icons**
  - Every `IconButton` or tappable `Icon` gets `semanticLabel` or `tooltip` property
  - Grep targets: `dashboard_tab.dart`, `missions_tab.dart`, `opportunities_tab.dart`, `mission_card.dart`, `streak_ring.dart`

- **Wrap custom visual widgets in Semantics**
  - `StreakRing`: `Semantics(label: 'Current streak $currentStreak days')`
  - `ProbabilityRadar`: `Semantics(label: 'Admissions probability by pillar')`
  - `CelebrationOverlay`: `Semantics(label: 'Level up celebration')`

- **Fix minimum touch target sizes**
  - Ensure all `GestureDetector` wrapped widgets have `padding` to reach 44dp
  - Add `visualDensity` to `ThemeData` in `app_theme.dart`

- **Implement `flutter_screen_reader` or platform a11y APIs**
  - Add `MediaQuery.boldText.of(context)` handling for bold text
  - Add `MediaQuery.textScaleFactor` checks — cap readable text to avoid overflow

- **Add reduced motion support**
  - Wrap all `.animate()` calls in `if (!motionReduced(context))`
  - Create `AnimatePresence` wrapper that reads `MediaQuery.disableAnimations`
  - Check `MediaQuery.prefersReducedMotion` in `app_theme.dart` to disable parallax

- **Contrast audit**
  - Use `contrast_checker` or `dart-palette` to verify all color pairs in `app_theme.dart`
  - Fix any non-AA (4.5:1 for normal, 3:1 for large) combos
  - `profile_tab.dart` — verify icon-on-surface contrast

---

## Summary Table

| Domain | Score | Priority | Critical Action |
|--------|-------|----------|-----------------|
| Testing | 5/100 | Must-Fix | Write unit tests for services + widget tests for critical UI |
| API Design | 15/100 | Must-Fix | Connect providers to backend, stop returning stubs |
| UX Flow | 30/100 | Should-Fix | Consolidate onboarding, close gamification loops, fix empty onPressed |
| CI/CD | 60/100 | Should-Fix | Fix broken scenario defs, add coverage gate, wire a11y audit |
| i18n | 40/100 | Nice-to-Have | Create missing ARB files, replace hardcoded strings |
| Accessibility | 20/100 | Nice-to-Have | Add Semantics labels, enforce 44dp touch targets, contrast audit |
