# Premium UI/UX Design Patterns Research
## Focus: Duolingo, Linear, Streaks — Micro-Interactions, Spring Physics, Haptics, Gamification

---

## 1. Duolingo — Gamification UI Patterns

### Auth Flow Architecture (Post-Onboarding Model)
- **Critical pattern**: Auth AFTER onboarding, not before. Users invest in app first, sign up to save progress.
- Flow: `Splash → Onboarding (5 steps) → Auth Prompt ("Save your progress") → Home`
- Conversion driver: "save your progress" converts better than "sign up"
- Guest mode keeps users in app without auth

### Onboarding Pattern
- **5 steps max.** Each step = one decision. Swipe between steps.
- Step 1: Goal (3 large cards with icon + title + subtitle + radio)
- Step 2: Targets (horizontal chip grid, tap to toggle)
- Step 3: Profile (name input + grade selector + interest chips)
- Step 4: Schedule (slider + peak time chips)
- Step 5: Launch (summary card + celebration animation)
- **Progress dots** (not a bar) — animated width change for active dot
- Back button on every step (except first), skip on every step
- Each step: icon (48px container) → title → subtitle → content
- CTA at bottom: full-width, gradient, always visible
- **Confetti on completion**

### Home Page Layout
- **Maximum 4 visible sections.** Force priority. Each section = 1 clear action.
- Fixed header: Avatar | Level | XP
- Gradient Hero: Level ring + progress + streak
- Daily missions: 3 mission cards max
- Bottom nav: 4 items max (Home | Missions | Profile | Shop)

### Gamification Elements
- XP rings (circular progress indicators)
- Streak counters (flame icons, daily checkmarks)
- League tiers with color-coded badges
- Celebration animations: confetti, "+100 XP!" floating text, scale bounce
- Sound design: satisfying "ding" on task completion, ascending pitch for streaks

### Micro-Interactions
- **Task completion**: Checkmark fills with animation → XP counter increments with number roll → ring progress updates
- **Streak maintenance**: Flame icon pulses, counter animates upward
- **Wrong answer**: Shake animation + red flash, no penalty sound (keep it positive)
- **Level up**: Full-screen overlay with burst animation, badge reveal, confetti
- **Hearts/lives**: Counter decrements with scale bounce, color shift from green to red

---

## 2. Linear — Dark UI & Precision Patterns

### Surface Ladder (Depth Without Shadows)
- **Never use pure `#000000`** — use `#0A0A0B` (Linear-style near-black)
- 3-4 progressively lighter surfaces, each ~8-10% lighter:
  - `#0A0A0B` → scaffold background
  - `#0F1629` → card surface
  - `#151D33` → elevated elements
  - `#1C2541` → tooltips, popovers
- **No drop shadows on dark** — depth from surface contrast + hairline borders
- Border: `#1E293B` (subtle), `#334155` (emphasized)

### Typography System
- Display: weight 800, letterSpacing: -1.5 (tight)
- Headline: weight 700, letterSpacing: -0.5
- Body: weight 400, height: 1.5
- Label: weight 600, letterSpacing: 0.5
- **Never default font weights** — always set explicit per text level
- Tabular figures (`tnum`) on every numeric cell

### Color Strategy
- One accent used scarcely — primary actions, focus, brand mark
- Near-black text: `#F8FAFC` primary, `#94A3B8` secondary, `#64748B` tertiary
- Semantic colors quarantined: success green, error red — never repurposed
- Purple accent reserved for premium features only

### Motion/Interaction Patterns
- **Default 150-200ms ease on hover/focus**
- Press feedback: `transform: scale(0.95)` — one-notch darken
- Focus: border brightens / accent swap (not generic glow ring)
- Disabled: hairline bg + muted text
- Fade images in on load to avoid pop-in
- **Consistent transition durations across entire product**

### Component States
- Every state defined: hover, pressed, focus, disabled, loading, empty, error
- Featured cards distinguished by **inversion** (dark fill, white text) or **2px accent border** — never bigger shadow
- Real icons (Lucide, Phosphor, Heroicons) — never emoji-as-icon

---

## 3. Streaks — Habit Tracking & Minimal Design

### Core Loop Design
- **Single-screen focus**: One habit per screen during active tracking
- Minimal chrome: habit name + streak count + completion toggle
- Progress visualization: simple dot grid (calendar heatmap style)
- Color: each habit gets unique color, consistent across all views

### Streak Visualization
- **Flame icon with gradient** (orange → red) for active streaks
- Streak count displayed prominently, not buried
- **"Don't break the chain"** visual: connected filled dots on calendar
- Gray/empty dots for missed days create visual pressure

### Completion Animation
- **Tap to complete**: circle fills with color + subtle bounce
- **Counter increment**: number rolls up with spring physics
- **Haptic feedback**: light tap on completion (iOS Taptic Engine)
- **Streak milestone**: brief flash + haptic double-tap at 7, 30, 100 days

### Minimal UI Philosophy
- **No unnecessary decoration** — whitespace is the design
- Typography does the heavy lifting
- Single accent color per habit, muted palette otherwise
- Cards with subtle rounded corners (12-16px), no drop shadows
- 1px hairline borders for separation, not dividers

---

## 4. Spring Physics Implementation Patterns

### Motion Token System (Reference Implementation)
```ts
// Duration tokens
{
  instant: 0.08,  // Tooltip show/hide, badge update
  fast:    0.18,  // Button feedback, icon swap, chip toggle
  normal:  0.35,  // Modal open, card expand, page element enter
  slow:    0.6,   // Hero entrance, full-page transition
  crawl:   1.0,   // Deliberate storytelling
}

// Easing curves
{
  smooth: [0.22, 1, 0.36, 1],  // General purpose
  sharp:  [0.4, 0, 0.2, 1],    // Quick transitions
  bounce: [0.34, 1.56, 0.64, 1], // Playful bounce
  linear: [0, 0, 1, 1],        // Mechanical/progress
}

// Spring presets (THE KEY PRESETS)
{
  snappy:  { type: "spring", stiffness: 300, damping: 30 },   // Default UI — buttons, chips, nav
  gentle:  { type: "spring", stiffness: 120, damping: 14 },   // Cards, modals landing softly
  bouncy:  { type: "spring", stiffness: 400, damping: 10 },   // Playful — empty states, onboarding
  instant: { type: "spring", stiffness: 600, damping: 35 },   // Tooltips, popovers, dropdowns
  release: { type: "spring", stiffness: 200, damping: 20, restDelta: 0.001 }, // Drag release
}
```

### Scale Tokens
```ts
{
  subtle: 0.98,  // Hover micro-feedback
  press:  0.95,  // Active/pressed state
  pop:    1.04,  // Attention draw, success
}
```

### Distance Tokens
```ts
{
  xs: 4,   // Tooltip shift
  sm: 8,   // Small element enter
  md: 16,  // Card/panel enter
  lg: 24,  // Section enter
  xl: 48,  // Hero/full-page
}
```

### When to Use Each Spring
| Preset | Use Case | Feel |
|--------|----------|------|
| `snappy` | Buttons, chips, nav items | Quick, decisive, professional |
| `gentle` | Cards, modals, panels | Soft landing, premium feel |
| `bouncy` | Onboarding, celebrations | Playful, engaging, fun |
| `instant` | Tooltips, popovers | Near-instant, responsive |
| `release` | Drag/swipe release | Natural physics, intuitive |

---

## 5. Haptics Integration Patterns

### iOS Taptic Engine Tiers
| Impact | When to Use | Pattern |
|--------|-------------|---------|
| `UIImpactFeedbackGenerator(style: .light)` | Toggle switches, chip selection, navigation tap | Single light tap |
| `UIImpactFeedbackGenerator(style: .medium)` | Task completion, button press, form submit | Confirmed action |
| `UIImpactFeedbackGenerator(style: .heavy)` | Destructive action confirmation, level-up | Weighty moment |
| `UIImpactFeedbackGenerator(style: .rigid)` | Error, invalid input, constraint violation | Sharp, jarring |
| `UIImpactFeedbackGenerator(style: .soft)` | Success, streak increment, positive feedback | Warm, satisfying |
| `UINotificationFeedbackGenerator(style: .success)` | Achievement unlocked, streak milestone | Double-tap pattern |
| `UINotificationFeedbackGenerator(style: .error)` | Streak broken, critical error | Triple-pulse warning |
| `UISelectionFeedbackGenerator()` | Picker scroll, segment change | Ticking through options |

### Haptic-to-Animation Sync Rule
- Haptic fires AT THE MOMENT the animation reaches its peak/punch point
- Button press: haptic on `scale(0.95)` landing (not on release)
- Task complete: haptic + visual fill + counter increment — all simultaneous
- Streak milestone: haptic pattern (double-tap) + visual celebration + optional sound

### Cross-Platform Haptics
- Android: `HapticFeedbackConstants` (KEYBOARD_TAP, LONG_PRESS, REJECT, CONFIRM)
- Flutter: `HapticFeedback` class (lightImpact, mediumImpact, heavyImpact, selectionClick)
- Web: No native haptics — fall back to visual/audio feedback only
- Rule: **Never make haptic the ONLY feedback channel.** Always pair with visual + optional audio

---

## 6. Gamification UI Design Patterns

### Progress Visualization Hierarchy
1. **XP Ring/Circle** — circular progress around avatar or central element
2. **Streak Counter** — flame icon + number, always visible
3. **Level Badge** — tier icon with color coding
4. **Leaderboard Position** — relative rank within league
5. **Achievement Grid** — collection of earned badges

### Reward Dopamine Loop
```
Action → Immediate Feedback (haptic + animation) → Reward Display (XP + streak)
→ Progress Update (ring fills) → Social Proof (leaderboard move) → Next Goal Preview
```

### Celebration Hierarchy
| Event | Visual | Haptic | Duration |
|-------|--------|--------|----------|
| Task complete | Checkmark fill + XP float | Light tap | 300ms |
| Daily streak | Flame pulse + counter roll | Medium tap | 500ms |
| Weekly milestone | Confetti burst | Double-tap success | 800ms |
| Level up | Full-screen overlay + badge reveal | Heavy + success | 1200ms |
| Achievement | Particle explosion + card slide-in | Triple success | 1500ms |

### Retention Mechanics (UI Expression)
- **Daily reward calendar**: Grid of days, completed = filled, missed = outlined
- **Streak freeze indicator**: Shield icon when protection is active
- **Come-back prompt**: "Don't lose your streak!" with flame icon + countdown
- **Social comparison**: "3 friends passed you this week" with avatars
- **Progress momentum**: "You're 80% to your next level!" with bar

### Onboarding Gamification
- **First lesson = instant win** — always succeed on first interaction
- **Early rewards are frequent** — XP every 2-3 actions for first week
- **Progress visualized immediately** — ring fills on first action
- **Streak starts counting from day 1** — "You're already on a 1-day streak!"
- **Social hooks**: "Join 50K+ learners" badge during auth

---

## 7. Micro-Interaction Implementation Patterns

### Button Interaction Stack
```
1. Hover:   scale(1.02) + shadow lift        — 150ms spring
2. Press:   scale(0.95) + darken 5%          — 100ms spring
3. Release: scale(1.0) spring back           — snappy spring
4. Success: scale(1.04) + color flash        — 200ms spring
```

### Card Interaction Stack
```
1. Hover:     translateY(-2px) + shadow       — 200ms gentle spring
2. Press:     scale(0.98)                     — 100ms spring
3. Expand:    height animation + content fade  — 350ms gentle spring
4. Collapse:  height + content fade            — 250ms sharp ease
```

### List Item Entrance (Stagger)
```
Container: staggerChildren: 0.08s, delayChildren: 0.1s
Each item:
  hidden:  { opacity: 0, y: 16 }
  visible: { opacity: 1, y: 0 }  — gentle spring transition
```

### Notification/Toast Pattern
```
Enter:  slide from right + scale(0.98) + opacity 0→1  — snappy spring
Exit:   slide to right + scale(0.98) + opacity 1→0    — snappy spring
Stack:  AnimatePresence mode="sync" — stacked, overlap OK
```

### Scroll Reveal
```
viewport: { once: true, margin: "-80px" }
Enter:   opacity 0→1 + y: 24→0
Duration: slow (0.6s) with smooth easing
```

---

## 8. Performance Rules for Motion

### Non-Negotiable Constraints
1. **Animate ONLY `transform` and `opacity`** — never `width`, `height`, `top`, `left`
2. **`initial` must match server output** — no hydration mismatches
3. **Reduced motion overrides everything** — `prefers-reduced-motion: reduce`
4. **All token values from shared system** — no hardcoded durations/easings
5. **`"use client"` required** on every file importing motion/react
6. **Never read `window`/`navigator` at module level** — guard with typeof check

### Device Adaptation
- Low-end detection: `navigator.hardwareConcurrency <= 4`
- Low-end: reduce duration to `instant`, skip non-essential animations
- Reduced motion: opacity-only fades at ≤ 0.2s, no transforms

### Performance Budget
- LCP < 2.5s — hero image must be priority/preloaded
- INP < 200ms — heavy work off main thread
- CLS < 0.1 — reserve space for images, fonts, embeds
- Animate only `transform` and `opacity` — GPU composited
- Use `will-change: transform` sparingly

---

## 9. Key Takeaways for Implementation

### The Premium Feel Formula
1. **Surface ladder over shadows** (dark UI) — 3-4 progressive surfaces
2. **Spring physics over linear easing** — snappy for UI, gentle for panels
3. **Haptic + visual sync** — both fire at animation peak
4. **Celebration hierarchy** — scale response to event importance
5. **One accent color, used sparingly** — reserved for primary actions
6. **Never pure black/white** — tint everything, `#0A0A0B` is the floor
7. **Tight display tracking** — `-1.5px to -3px` at 48-80px size
8. **Auth after onboarding** — investment before commitment
9. **Maximum 4 sections visible** — force priority
10. **Every state defined** — hover, pressed, focus, disabled, loading, empty, error

### Anti-Patterns to Avoid
- Generic gray drop shadows (the #1 AI design tell)
- Pure `#000` / `#FFF` backgrounds
- Competing accent colors
- `window.addEventListener('scroll')` — use `useScroll()` or ScrollTrigger
- Inline `stiffness`/`damping` values — use spring presets
- Animating layout properties (`width`, `height`)
- Missing `AnimatePresence` key on conditional renders
- Haptic as sole feedback channel
- Auth before onboarding investment
- More than 3 equal feature cards in a row

---

*Research compiled from: advanced-design skill, design-taste-frontend skill, motion-foundations skill, motion-patterns skill, flutter-premium-ui reference, Duolingo/Linear/Streaks UI analysis.*
