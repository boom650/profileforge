# Judge 18: Gamification Evaluation

**Final Score: 45/100**

## Executive Summary
The gamification system has a functional baseline for XP, streaks, skins, and missions. However, its implementation is a monolithic `GamificationService` that tightly couples state management, business logic, and persistence. This leads to low scores in persistence, balance, and progression clarity due to the system's brittleness and lack of modularity. While the data models are well-structured using `freezed`, the service layer is a "god object" that is difficult to test, maintain, and extend. The current line count is misleading; the complexity remains high. A complete architectural refactor is required to achieve a score of 82 or higher.

---

## Scoring Breakdown

| Category | Score (1-100) | Rationale |
| :--- | :--- | :--- |
| **XP System** | 65 | **Good.** The core logic for XP calculation exists (`XPUtils`, `XPCatalog`). However, `addXP` is a large method inside the monolith, mixing concerns like level-up checks, skin unlocks, and mission tracking. The `XPCatalog` provides a clear, static definition of XP sources, which is a strong point. |
| **Streaks** | 50 | **Mediocre.** The `Streak` model is well-defined and includes humane features like grace days and freeze tokens. The implementation in `markDailyActive` is complex, hard to follow, and directly entangled with XP awards and persistence calls, making it brittle. |
| **Skins** | 60 | **Good.** The `Skin` and `SkinCatalog` models are excellent, providing a clear, extensible system for defining cosmetic rewards and their unlock criteria. The weakness is the unlock logic, which is buried inside `addXP` and manual `unlockSkin` methods, rather than being a reactive consequence of state changes. |
| **Missions** | 40 | **Needs Improvement.** `MissionTemplates` provide a solid foundation. However, the generation logic (`_generateMissionsForType`) is simplistic placeholder code. Mission progress tracking and completion are tightly coupled to the `addXP` flow and manual state management, making it hard to reason about. |
| **Persistence** | 30 | **Poor.** Relies on a single JSON blob in `SharedPreferences`. This is not robust; a crash during a write can corrupt all gamification data. Loading logic uses a `try-catch` block that swallows errors, hiding potential issues. There is no separation between the persistence layer and the business logic. |
| **Balance** | 25 | **Very Poor.** Balance is currently arbitrary. XP values are hardcoded in `XPCatalog` and mission templates. The `calculateAdmissionsReadiness` function attempts to create a balanced score but uses a hardcoded `3000.0` normalization constant and a complex, difficult-to-tune standard deviation calculation. There are no tools for simulation or analysis. |
| **Engagement Loops** | 35 | **Poor.** Core loops exist (do task -> get XP -> level up/unlock skin), but they are not cohesive. The connection between actions, missions, and rewards is implicit and buried in code. There are no clear, compelling short-term or long-term loops to keep users engaged. |
| **Progression Clarity** | 55 | **Mediocre.** The UI can display current state (level, XP), but the path to the *next* reward is not always clear. `xpToNextLevel` and `xpToNextSkin` are good, but understanding how specific actions contribute to unlocking the *next cool thing* is difficult for a user without reading the code. |

---

## Path to a 90+ Score

To achieve a score of 82 or higher, a fundamental architectural refactor is non-negotiable. The goal is to move from a monolithic service to a set of decoupled, single-responsibility components orchestrated by a state management solution.

### 1. **Introduce a Repository Layer for Persistence (Score +20)**
- **Create `GamificationRepository`:** This class is solely responsible for saving and loading the `GamificationState`. Its interface will be simple: `Future<GamificationState> loadState()` and `Future<void> saveState(GamificationState state)`.
- **Use a robust storage solution:** Replace the single JSON blob in `SharedPreferences` with a more resilient key-value store or a simple database like Hive/Isar to prevent data corruption.
- **Impact:** Decouples business logic from persistence, improves testability, and makes the system more robust.

### 2. **Decompose the Monolithic Service (Score +15)**
- Break `GamificationService` into smaller, domain-focused services:
  - `XPService`: Handles all XP calculations, leveling, and applying transactions.
  - `StreakService`: Manages streak logic, including grace days and milestones.
  - `MissionService`: Manages mission generation, progress tracking, and reward claims.
  - `SkinService`: Manages skin unlocking and equipping logic.
- Each service will take the current `GamificationState` as input, perform its logic, and return a *new, updated* `GamificationState`. They are pure, testable, and have no side effects.

### 3. **Implement a Central State Notifier (Score +15)**
- **Create `GamificationController` (as a Riverpod `StateNotifier`):** This becomes the single entry point for the UI.
- **Responsibilities:**
    1. Hold the authoritative `GamificationState`.
    2. Expose public methods (e.g., `completeActivity(String activityId)`, `useGraceDay()`).
    3. Orchestrate calls to the domain services (e.g., `XPService`, `StreakService`).
    4. Update its state with the result from the services.
    5. Persist the new state using the `GamificationRepository`.
- **Example Flow for `completeActivity`:**
    1. UI calls `ref.read(gamificationControllerProvider.notifier).completeActivity('study_session_45')`.
    2. Controller gets the `XPActivity` details from `XPCatalog`.
    3. Controller calls `xpService.addXP(currentState, amount, pillar)`.
    4. `xpService` returns a `newState`.
    5. Controller updates its own state: `state = newState`.
    6. Controller saves the state: `repository.saveState(newState)`.
    7. The UI, watching the provider, rebuilds automatically.

### 4. **Improve Balance and Progression (Score +10)**
- **Create a `BalanceSheet` singleton:** Externalize all magic numbers (XP amounts, level thresholds, mission rewards) into a single, easily-editable class. This allows for rapid iteration on game balance without digging through code.
- **Dynamic Mission Generation:** Enhance `MissionService` to generate missions based on user state. For example, if a user hasn't engaged with the 'research' pillar, generate a mission to encourage it.
- **Clearer Progression UI:** With a central state, the UI can easily subscribe to changes and show clear progress bars towards the *next unlockable skin* or *next streak milestone*, creating more compelling engagement loops.
