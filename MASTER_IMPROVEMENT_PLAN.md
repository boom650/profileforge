# ProfileForge Master Improvement Plan (Synthesized from 22 Judges)

**Date**: 2026-07-11
**Project**: `profileforge`
**Scope**: Flutter App, FastAPI Backend, CI/CD, Docs

## 1. Master Scorecard

This table synthesizes the final scores from all 23 judge agents after Sprint 1 improvements.

| #  | Judge Category          | Before | After | Delta | Score (≥90) | Priority        | Owner Judge                                                                                           |
|----|-------------------------|--------|-------|-------|-------------|-----------------|-------------------------------------------------------------------------------------------------------|
| 3  | **Critical Errors**     | 2 Crit | 0     | ✓     | ✅          | **Must-Fix (P0)**   | Judge #3 (Critical Errors)                                                                            |
| 8  | **Backend Security**    | 68     | 74    | +6    | ⚠️          | **Must-Fix (P0)**   | Judge #8 (Backend Security)                                                                           |
| 11 | **Accessibility (a11y)**| 68     | 43    | -25   | ❌          | **Must-Fix (P0)**   | Judge #8 (Accessibility), Judge #11 (Accessibility)                                                   |
| 5  | **UI Design**           | 68     | 75    | +7    | ⚠️          | **Should-Fix (P1)** | Judge #5 (UI Design), Judge #4 (UI Design)                                                            |
| 12 | **i18n**                | 5      | 45    | +40   | ❌          | **Should-Fix (P1)** | Judge #12 (i18n)                                                                                      |
| 13 | **Testing & Coverage**  | 78     | 72    | -6    | ⚠️          | **Should-Fix (P1)** | Judge #13 (Testing)                                                                                   |
| 17 | **CI/CD**               | 38     | 85    | +47   | ↗️          | **Should-Fix (P1)** | `profileforge-ci-bugs.md`                                                                             |
| 6  | **UX Flow & Navigation**| 78     | 74    | -4    | ⚠️          | **Should-Fix (P1)** | Judge #6 (UX Flow)                                                                                    |
| 14 | **Maintainability**     | 70     | 68    | -2    | ⚠️          | **Should-Fix (P1)** | Judge #15 (Tech Debt)                                                                                 |
| 2  | **Code Quality**        | 68     | 88    | +20   | ↗️          | **Nice-to-Have (P2)**| Judge #2 (Code Quality)                                                                               |
| 7  | **Frontend Arch**       | 68     | 92    | +24   | ✅          | **Nice-to-Have (P2)**| Judge #7 (Frontend Arch)                                                                              |
| 9  | **Performance & Memory**| 68     | 94    | +26   | ✅          | **Nice-to-Have (P2)**| Judge #9 (Performance)                                                                                |
| 10 | **State Management**    | 68     | 92    | +24   | ✅          | **Nice-to-Have (P2)**| Judge #10 (State Mgmt)                                                                                |
| 15 | **Error Handling**      | 45     | 55    | +10   | ❌          | **Should-Fix (P1)** | Judge #15 (Error Handling)                                                                            |
| 16 | **Naming & Docs**       | 68     | 82    | +14   | ↗️          | **Nice-to-Have (P2)**| Judge #16 (Naming/Docs)                                                                               |
| 18 | **Dependencies**        | 40     | 72    | +32   | ⚠️          | **Should-Fix (P1)** | Judge #18 (Dependencies)                                                                              |
| 19 | **Database Design**     | 78     | 70    | -8    | ⚠️          | **Should-Fix (P1)** | Judge #19 (DB Design)                                                                                 |
| 20 | **API Design**          | 68     | 65    | -3    | ⚠️          | **Should-Fix (P1)** | Judge #20 (API Design)                                                                                |
| 1  | **App Quality**         | 92     | 95    | +3    | ✅          | **Nice-to-Have (P2)**| Judge #1 (App Quality)                                                                                |
| 21 | **Gamification**        | 68     | 68    | 0     | ⚠️          | **Should-Fix (P1)** | Judge #21 (Gamification)                                                                              |
| 22 | **Onboarding**          | 78     | 78    | 0     | ⚠️          | **Should-Fix (P1)** | Judge #22 (Onboarding)                                                                                |

---

## 2. Top 10 Cross-Cutting Improvements

These are the most critical, high-impact issues synthesized from recurring themes across multiple judge reports.

1.  **Implement Real Backend Authentication (P0)**: All endpoints are public. Implement JWT validation and apply `Depends(get_current_user)` to all routes. (Judge #8)
2.  **Fix Accessibility Contrast (P0)**: 3+ light-mode colors fail WCAG AA contrast, making the app unusable for some users. (Judge #4, #8, #11)
3.  **Add Semantic Labels Everywhere (P0)**: Over 60% of interactive elements lack semantic labels, making the app incomprehensible to screen reader users. (Judge #8, #11)
4.  **Refactor God Classes (P1)**: `GamificationService` (1247 lines) and `WeeklyTargetsScreen` (1552 lines) must be broken down to follow SRP. (Judge #15)
5.  **Enforce UI Theme Consistency (P1)**: Create shared components (`AppCard`, `AppButton`) and lint rules to prevent hardcoded colors, radii, and spacing that bypass the `AppTheme`. (Judge #5)
6.  **Add Text Scaling Support (P1)**: The app does not respond to system font size changes, a critical accessibility failure. Replace fixed `fontSize` with a scaling solution. (Judge #8, #11)
7.  **Implement Rate Limiting (P1)**: The backend has no rate limiting, leaving it vulnerable to denial-of-service and abuse. (Judge #8)
8.  **Add Integration & Widget Tests (P1)**: Test coverage is almost exclusively unit tests. Add widget and integration tests for critical user flows. (Judge #13)
9.  **Externalize All Hardcoded Config (P1)**: Move hardcoded URLs, API keys, and magic numbers to environment variables or a proper config file. (Judge #15)
10. **Fix Broken Error Handling (P1)**: Multiple backend endpoints return invalid error responses (`{"error": str(e)}, 500`), and the frontend has 34+ swallowed `catch` blocks. (Judge #15, #8)

---

## 3. Prioritized Roadmap

### Must-Fix (Blocking, Scores < 70, Critical Vulns)

| Task                                         | Judge(s)     | Files to Change                                                                      |
|----------------------------------------------|--------------|--------------------------------------------------------------------------------------|
| **1. Implement Backend JWT Auth**            | #8           | `backend/server.py`, `backend/services/auth.py`                                      |
| **2. Fix WCAG AA Contrast Failures**         | #4, #8, #11  | `lib/ui/theme/app_theme.dart` (textMuted, accentGold, unselectedItemColor)             |
| **3. Add Semantics to ALL Tappables**        | #8, #11      | 37+ files; create a reusable `AccessibleTap` widget.                                 |
| **4. Implement Backend Rate Limiting**       | #8           | `backend/server.py` (add `slowapi` middleware)                                       |
| **5. Add i18n String Extraction**            | #12          | Run `flutter gen-l10n`, extract all UI strings to `.arb` files.                      |
| **6. Fix Invalid Error Tuple Returns**       | #8, #15      | `backend/server.py` (5 endpoints)                                                    |
| **7. Remove `allow_origins=["*"]` on Bridge**| #8           | `backend/bridge_server.py`                                                           |
| **8. Move DDL out of Request Handlers**      | #8, #19      | `backend/server.py` (log_activity, set_user_goals)                                   |
| **9. Convert Dict Endpoints to Pydantic**    | #8, #20      | `backend/server.py` (6 endpoints)                                                    |

### Should-Fix (High-Impact, Scores 70-89)

| Task                                          | Judge(s)     | Files to Change                                                                        |
|-----------------------------------------------|--------------|----------------------------------------------------------------------------------------|
| **1. Refactor `GamificationService`**         | #15          | `lib/services/gamification/gamification_service.dart` -> Xp, Streak, Mission services. |
| **2. Decompose `WeeklyTargetsScreen`**        | #15          | `lib/ui/screens/targets/weekly_targets_screen.dart` -> Provider, Model, Widgets.       |
| **3. Create `AppRadius` Constants**           | #5           | `lib/ui/theme/app_theme.dart`, then replace all `BorderRadius.circular(N)`.            |
| **4. Migrate `Container` Cards to `Card`**    | #5           | Refactor manual `Container(decoration: ...)` to use the themed `Card` widget.          |
| **5. Add Widget & Integration Tests**         | #13          | `test/widgets/`, `integration_test/` directories.                                      |
| **6. Implement Text Scaling Support**         | #8, #11      | Create `AppTextStyle.scale(context, ...)` helper, replace all `fontSize`.            |
| **7. Add Visual Regression to CI**            | CI Bugs      | `.github/workflows/visual-regression.yml` (fix server start)                           |
| **8. Fix UX Flow Regression**                 | #6           | Broken `/chat` named route.                                                            |
| **9. Address `TODO` Backlog**                 | #15          | Convert 19+ TODOs into GitHub Issues.                                                  |
| **10. Pin and Scan Dependencies**             | #18          | Add `safety` or `pip-audit` to CI for backend dependencies.                            |

### Nice-to-Have (Polish, Scores 90+)

| Task                                         | Judge(s)     | Files to Change                                                                 |
|----------------------------------------------|--------------|---------------------------------------------------------------------------------|
| **1. Debounce SharedPreferences Writes**     | #9           | `OnboardingDataNotifier` and `GamificationService` `_save` methods.             |
| **2. Split Dashboard into ConsumerWidgets**  | #9           | `lib/ui/screens/home/dashboard_tab.dart` to reduce rebuilds.                    |
| **3. Add `RepaintBoundary` to `MissionCard`**| #9           | `lib/ui/widgets/mission_card.dart` for large lists.                             |
| **4. Unify Naming and Code Style**           | #2, #16      | Enforce lint rules across the codebase.                                         |
| **5. Enhance Documentation**                 | #16          | Improve `README.md` and `CONTRIBUTING.md` with new architectural decisions.   |
