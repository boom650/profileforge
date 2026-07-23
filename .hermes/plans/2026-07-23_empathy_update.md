# Plan: The Empathy Update (Anti-Procrastination)

## Goal
Transform ProfileForge from a generic mission app into a creative, psychology-driven companion that helps students overcome laziness through social pressure (AI Body Double) and financial/XP consequences (XP Debt). Reach 60MB+ build size by adding high-quality audio and visual assets.

## Core Features

### 1. AI Body Double (Focus Buddy)
- **Concept**: A persistent 2D character on the Timer Screen that "studies" with the user.
- **Psychology**: Taps into the "Body Doubling" effect (social facilitation) which is proven to help ADHD and procrastinators.
- **Implementation**:
  - `BodyDoubleWidget` on `TimerScreen`.
  - Animates based on timer state (Writing, Reading, Sleeping when paused).
  - High-quality 2D sprites (PNG/SVG) to increase app weight and visual polish.

### 2. XP Debt System
- **Concept**: Missed daily quests or broken streaks don't just "reset"—they incur **Debt**.
- **Psychology**: Loss Aversion. People work harder to avoid a penalty than to gain a reward.
- **Implementation**:
  - `XpDebt` Drift table: `id, profileId, amount, type, createdAt`.
  - Notification when debt is incurred.
  - "Debt Repayment" missions (2x intensity, 0.5x XP until paid).

### 3. Ambient Focus Soundscapes
- **Concept**: Integrated audio player on the timer screen.
- **Implementation**:
  - 4-5 high-quality MP3 tracks (~10MB each): Lo-Fi, Rain, Coffee Shop, White Noise.
  - This directly hits the 60MB target while adding massive value.

## Files to Change
- `lib/core/data/tables.dart`: Add `XpDebt` table.
- `lib/features/timer/presentation/timer_screen.dart`: Integrate Body Double and Audio Player.
- `lib/features/xp/application/xp_providers.dart`: Add debt logic to XP calculations.
- `lib/features/buddy/`: Expand to include visual state management.

## Asset Targets
- `assets/audio/ambient/`: lofi.mp3, rain.mp3, library.mp3 (target ~45MB).
- `assets/images/buddy/`: High-res character sprites (target ~5MB).

## Risks
- **Asset Loading**: Ensure MP3s are compressed enough to play smoothly but large enough to meet target.
- **Complexity**: Keep the "Debt" UI simple so it doesn't feel like a chore.
