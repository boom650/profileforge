# Premium UI/UX Pattern Research: Duolingo, Linear, Streaks, Things3, Arc

Concrete animation patterns, timing values, curves, and Flutter implementation details.

---

## 1. DUOLINGO — Animation System & Gamification UI

### Animation Architecture
- **Engine**: Lottie + custom spring animations (previously used Rive for mascot)
- **Frame target**: 60fps, always. Sacrifice complexity over frame drops
- **Mascot**: "Duo" owl uses sprite-sheet animations with ~12 key poses
- **All animations use spring physics**, not tween curves

### Specific Animation Patterns

#### Button Press Micro-interaction
```
Scale: 1.0 → 0.92 (shrink on press) → 1.0 (spring back on release)
Spring stiffness: 500, damping: 15
Duration: ~200ms total
Haptic: UIImpactFeedbackGenerator(style: .medium)
```

#### Lesson Completion Celebration
```
1. Check mark draws in (stroke animation, 400ms, ease-out)
2. Circle fills with green (scale 0→1, spring stiffness=300, damping=12)
3. Confetti particles burst from center (flutter_confetti, 800ms)
4. XP counter rolls up (number roll animation, 600ms, ease-out)
5. Streak flame scales in with bounce (spring stiffness=400, damping=10)
Total sequence: ~1.5s with overlapping stages
```

#### XP Ring Animation
```
Circular progress: CustomPainter with arc drawing
Animation: sweepAngle from 0 to target, Duration: 800ms
Curve: Curves.easeOutCubic (starts fast, decelerates)
Ring width: 6-8dp
Colors: Green (#58CC02) → Gold gradient (#FFC800) at completion
```

#### Streak Flame Animation
```
On increment: flame scales 1.0 → 1.3 → 1.0 with 2 bounce peaks
Spring: stiffness=200, damping=8 (bouncy)
Color shift: orange (#FF9600) → red (#FF4B4B) on fire streak
Flame flicker: subtle sine-wave opacity 0.8-1.0, period=2s
```

#### Level Up Celebration
```
1. Full-screen overlay fades in (opacity 0→1, 200ms)
2. Level badge drops in from top with spring (stiffness=250, damping=12)
3. Particle system radiates outward (150+ particles, 1.2s)
4. Badge scales 0.5→1.05→1.0 (overshoot spring)
5. Overlay dismisses on tap (opacity 1→0, 300ms)
```

#### Path Node Animation (Learning Tree)
```
Node unlock: opacity 0→1 + scale 0.7→1.0, spring stiffness=300, damping=15
Node available: gentle pulse (scale 1.0→1.05→1.0, period=2s)
Node completed: checkmark draws in (strokeDashOffset animation, 300ms)
Connection lines: stroke dash animation from source to target, 400ms
```

#### Correct Answer Feedback
```
- Green flash: Container color transitions to green (#58CC02), 150ms
- Shake on wrong: translateX oscillation ±8px, frequency=10Hz, 300ms
- Correct: slight upward bounce (translateY -4px then spring back)
- Haptic: .success on correct, .error on wrong (iOS Taptic)
```

### Typography System
```
Heading: Nunito Bold, 24-32sp
Body: Nunito Regular, 16-18sp
Caption: Nunito Medium, 12-14sp
Line height: 1.4x
Letter spacing: +0.2
```

### Color System
```
Primary Green: #58CC02
Green Dark: #46A302
Blue: #1CB0F6
Red (error): #FF4B4B
Gold: #FFC800
Purple: #CE82FF
Background: #131F24 (dark mode)
Card BG: #1A2D35
```

### Haptic Map
```
Button tap: UIImpactFeedback(.light)
Correct answer: UINotificationFeedback(.success)
Wrong answer: UINotificationFeedback(.error)
Streak increment: UIImpactFeedback(.medium)
Level up: UINotificationFeedback(.success) + UIImpactFeedback(.heavy)
```

---

## 2. LINEAR — Surface Ladder, Typography, Color, Motion

### Surface Ladder (4 levels)
```
Layer 0 (Base):       #0A0A0B  — True black background
Layer 1 (Surface):    #151515  — Cards, sidebars
Layer 2 (Elevated):   #1C1C1E  — Dropdowns, modals
Layer 3 (Highlight):  #252528  — Hover states, active items
Layer 4 (Overlay):    #2E2E32  — Tooltips, popovers

Elevation technique: Background color + subtle border (1px rgba(255,255,255,0.06))
NO box-shadows used — Linear avoids shadows entirely
```

### Typography System
```
Font: Inter (weights 400, 500, 600, 700)
X-Large Heading:  24px / 700 / -0.02em tracking
Large Heading:     20px / 600 / -0.01em tracking
Section Title:     13px / 600 / +0.02em tracking (uppercase)
Body:              14px / 400 / normal tracking
Caption:           12px / 500 / +0.02em tracking
Mono (code/IDs):   JetBrains Mono 13px / 400

Line heights:
  Headings: 1.2
  Body: 1.5
  Labels: 1.0

Text colors:
  Primary:    #EDEDED
  Secondary:  #8E8E93
  Tertiary:   #636366
  Disabled:   #48484A
```

### Color System
```
Background:    #0A0A0B
Surface:       #151515
Border:        rgba(255,255,255,0.06) — extremely subtle
Border hover:  rgba(255,255,255,0.12)
Text primary:  #EDEDED
Text secondary:#8E8E93

Accent colors (issue status):
  Backlog:   #636366
  Todo:      #8E8E93  
  In Progress: #5E6AD2 (Linear purple)
  Done:      #5E6AD2 + checkmark
  Cancelled: #F2C94C

Priority colors:
  Urgent:    #EB5757
  High:      #F2994A
  Medium:    #F2C94C
  Low:       #636366
  No Priority: transparent

Label colors (hue wheel, 20+ colors):
  Each at 70% opacity bg, 100% text
  bg: hsla(hue, 70%, 89%, 0.15)
  text: hsla(hue, 70%, 89%, 1.0)
```

### Motion Patterns
```
All transitions: 150-200ms duration
Curve: cubic-bezier(0.25, 0.1, 0.25, 1.0) — standard ease-out

Specific timings:
  Hover state: 100ms ease
  Focus ring: 150ms ease  
  Panel slide: 200ms ease-out
  Modal open: 200ms ease-out (scale 0.98→1.0 + opacity)
  Modal close: 150ms ease-in
  Dropdown: 150ms ease-out (translateY -4px→0 + opacity)
  Sidebar collapse: 200ms ease-in-out
  Issue detail panel: 200ms ease-out, slide from right
  List reorder: 200ms spring (stiffness=300, damping=30)
  Tooltip: 100ms ease-out, 50ms delay
```

### Micro-interactions
```
Issue checkbox:
  - Check: stroke animation (Lottie), 200ms
  - Fill: color transitions from transparent to status color, 150ms
  - Strike-through text: line draws across, 200ms ease-out

Keyboard shortcut reveal:
  - Kbd badge fades in on hover, 100ms
  - Opacity: 0 → 0.6

Drag and drop:
  - Item lifts: scale 1.0→1.02, shadow introduced, 150ms
  - Drop placeholder: border pulse animation, 200ms
  - Landing: scale 1.02→1.0, 200ms spring

Command palette (Cmd+K):
  - Backdrop: opacity 0→0.5, 150ms
  - Modal: translateY 8px→0 + opacity 0→1, 200ms
  - Search results: staggered fade-in, 50ms between items
  - Item hover: background rgba(255,255,255,0.06), 100ms
```

### Scroll Behavior
```
Overscroll: rubber-band effect (platform native)
Sticky headers: background blur 12px + surface color
Scroll indicator: fades in on scroll, 200ms, fades out 500ms after stop
```

### Border Radius
```
Small (buttons, tags):  4px
Medium (cards, inputs): 6px
Large (modals):         8px
Full (avatars, pills):  9999px
```

---

## 3. STREAKS APP — Minimal Design & Visualization

### Design Philosophy
- **Zero chrome** — every pixel serves the streak
- **Single-focus layout** — one habit fills the screen
- **Color-coded habits** — each habit has a unique vivid color
- **Flat design** — no shadows, minimal depth

### Streak Calendar Visualization
```
Grid: 7 columns × variable rows (weekly calendar view)
Active day: filled circle in habit color, diameter ~20pt
Inactive day: outline circle, stroke color = habit color at 30% opacity
Today: ring outline + slight glow effect
Missed day: empty circle with subtle X or just outline

Calendar animation on completion:
  Fill animation: circle scales 0→1.1→1.0 (bounce), 300ms spring
  Haptic: .medium impact
```

### Task Completion Animation
```
1. Checkbox tap → circle fills with habit color (scale 0→1, 200ms)
2. Checkmark draws (strokeDashOffset, 250ms, ease-out)
3. Habit ring at top updates (arc sweep animation, 400ms, ease-out)
4. Confetti burst only on streak milestones (7, 30, 100, 365)
5. Streak counter increments with number roll animation (200ms)
```

### Streak Ring (Circular Progress)
```
Radius: ~60pt (main habit view)
Stroke width: 8pt
Background ring: habit color at 15% opacity
Progress ring: habit color at 100% opacity
Animation: sweepAngle from current→target, 600ms, Curves.easeOutCubic
Ring end cap: round (StrokeCap.round)
```

### Color System
```
Background: #FFFFFF (light) / #1C1C1E (dark)
Text primary: #000000 (light) / #FFFFFF (dark)
Text secondary: #8E8E93

Habit colors (user-selectable):
  #FF3B30 (red), #FF9500 (orange), #FFCC00 (yellow)
  #34C759 (green), #00C7BE (teal), #007AFF (blue)
  #5856D6 (indigo), #AF52DE (purple), #FF2D55 (pink)
  #A2845E (brown), #8E8E93 (gray)

Color usage: habit color fills progress ring + calendar dots
```

### Typography
```
SF Pro (iOS) / Roboto (Android)
Streak number: SF Pro Rounded Bold, 72sp
Habit name: SF Pro Semibold, 20sp
Time remaining: SF Pro Regular, 16sp, secondary color
Calendar day: SF Pro Medium, 12sp
```

### Haptics
```
Task complete: .medium impact
Streak milestone (7+): .heavy impact + .success notification
Streak broken: .error notification (subtle)
```

### Micro-interactions
```
Habit reorder (long press):
  - Scale up: 1.0→1.05, 150ms
  - Elevation: add subtle shadow
  - Drag: follows finger with spring physics
  
Swipe actions:
  - Swipe right: green gradient reveal (complete)
  - Swipe left: red gradient reveal (skip/delete)
  - Threshold: 30% of screen width
  - Animation: 300ms spring after release
  
Tab bar:
  - Active icon: fill animation (stroke→filled), 200ms
  - Badge pulse: 1.0→1.15→1.0, spring stiffness=400, damping=10
```

---

## 4. THINGS3 — Task Completion & List Interactions

### Design Philosophy
- **Radical simplicity** — zero unnecessary UI elements
- **Blue accent only** — all interactive elements are blue (#007AFF)
- **Generous whitespace** — 44pt minimum touch targets
- **Native iOS feel** — follows Apple HIG precisely

### Task Completion Animation (Signature Pattern)
```
1. Tap checkbox (circle outline)
2. Circle fills: stroke draws clockwise, 300ms, ease-out
3. Checkmark appears: scale 0→1 + opacity 0→1, 200ms, ease-out
4. Task text transitions:
   - Color: primary text → secondary text (#8E8E93)
   - Strikethrough: line draws from left, 300ms, ease-out
5. Entire row: slight scale (1.0→0.98) then back, 200ms
6. Row moves to "completed" section with slide animation, 300ms
7. If "Logbook" view: items slide in from right as completed

Check animation total: ~500ms
Haptic: .light impact on tap, .success on milestone
```

### List Item Interactions
```
Hover (Mac):
  - Background: transparent → rgba(0,0,0,0.03), 100ms
  - Subtle highlight, no border changes

Press:
  - Scale: 1.0 → 0.98, 100ms
  - Background intensifies slightly

Reorder (drag):
  - Lift: scale 1.0→1.03, 150ms
  - Drop shadow: 0→8px, rgba(0,0,0,0.1)
  - Other items shift with spring physics (stiffness=300, damping=25)
  - Landing: scale 1.03→1.0, shadow fades, 200ms

Swipe (iOS):
  - Right edge swipe: reveals blue "Complete" action
  - Left swipe: reveals gray "Delete" action
  - Actions slide in independently of row movement
  - Threshold: 80pt for action reveal
  - Spring-back: stiffness=200, damping=20
```

### Typography
```
SF Pro system font throughout
Task title: SF Pro Regular, 17sp (body text size)
Section header: SF Pro Semibold, 13sp, uppercase, secondary color
Due date / tags: SF Pro Regular, 13sp, tertiary color
Heading: SF Pro Semibold, 28sp

Line height: 1.3x for task titles
Note text: SF Pro Regular, 15sp, secondary color
```

### Color System
```
Background: #FFFFFF (light) / #1C1C1E (dark)
Primary text: #000000 (light) / #FFFFFF (dark)
Secondary text: #8E8E93
Tertiary text: #AEAEB2
Accent (interactive): #007AFF
Separator: rgba(60,60,67,0.12) (light) / rgba(84,84,88,0.65) (dark)
Completed text: #8E8E93 with strikethrough

Tag colors:
  Red: #FF3B30, Orange: #FF9500, Yellow: #FFCC00
  Green: #34C759, Blue: #007AFF, Purple: #AF52DE
  
  Tag chip: solid color background, white text, 3px corner radius
  Tag height: 22pt
```

### Border Radius
```
Task cards: 0 (flat, no cards)
Tag chips: 3px
Buttons: 8px
Input fields: 6px
Modals: 12px (iOS standard)
```

### Specific Animations

#### New Task Entry
```
1. Input field slides up from bottom, 250ms, ease-out
2. Keyboard appears (iOS native animation)
3. On submit: new task fades in at top, 200ms
4. Existing items shift down, 200ms, ease-out
```

#### Section Collapse/Expand
```
Toggle: chevron rotates 0→90°, 200ms, ease-in-out
Items: staggered fade-out, 30ms delay between items
Height: animated with spring (stiffness=400, damping=30)
```

#### Today View Refresh
```
Calendar dots animate in staggered, 20ms between dots
Today highlight: blue dot with subtle pulse (scale 1.0→1.1, period=3s)
```

---

## 5. ARC BROWSER — Tab Bar & Split View

### Tab Bar Animation (Signature Feature)
```
Tab strip position: sidebar (vertical) on desktop, bottom (horizontal) on mobile
Tab hover: 
  - Background: transparent → rgba(255,255,255,0.06), 100ms
  - Tab thumbnail preview: opacity 0→1 + translateY 4px→0, 150ms, ease-out
  - Preview dimensions: ~280×180px thumbnail
  - Preview shadow: 0 8px 32px rgba(0,0,0,0.3)
  
Tab selection:
  - Active tab: filled icon (stroke→fill), 200ms
  - Background: rgba(255,255,255,0.08)
  - Tab text: bold weight transition, 150ms
  
Tab close:
  1. Tab width collapses to 0, 250ms, ease-in
  2. Adjacent tabs slide over, 200ms, ease-out
  3. X button opacity: 0→1 on hover, 100ms

Tab reorder (drag):
  - Dragged tab: scale 1.05, elevation increase, 150ms
  - Other tabs shift: spring (stiffness=350, damping=25)
  - Drop: scale 1.05→1.0, 200ms
```

### Split View Transition
```
Trigger: long-press tab or Cmd+click
Animation:
  1. Current view slides left, taking 50% width, 300ms, ease-out
  2. Divider appears at center, fade in, 150ms
  3. New panel slides in from right, 300ms, ease-out (overlapping timing)
  4. Both panels settle with slight spring bounce, stiffness=300, damping=25

Divider interaction:
  - Cursor changes to col-resize
  - Drag: real-time resize, no animation delay
  - Min width per panel: 25% of window
  - Double-click divider: snap to 50/50, 200ms spring

Close split:
  - Remaining panel expands to full width, 300ms, ease-out
  - Divider fades out, 150ms
```

### Tab Bar Visual Design
```
Background: #1A1A1E (dark), transparent with backdrop blur 20px
Tab height: 36px (sidebar) / 48px (bottom)
Tab padding: 8px horizontal
Tab icon size: 16×16px
Tab text: 12px, system font (SF Pro), medium weight
Active tab: background rgba(255,255,255,0.08)
Hover: rgba(255,255,255,0.04)
Border: none (separation via spacing + background)
```

### Color System (Dark Mode)
```
Tab bar BG: rgba(26,26,30,0.85) + backdrop-blur(20px)
Page BG: #FFFFFF (web content)
Toolbar: #2C2C2E
Text primary: #FFFFFF
Text secondary: #98989D
Accent: #007AFF (links, active states)
Border: rgba(255,255,255,0.08)
Hover BG: rgba(255,255,255,0.06)

Space (profile) colors:
  Personal: #007AFF (blue)
  Work: #FF9500 (orange)
  Each Space has unique accent that tints the toolbar
```

### Space Switching Animation
```
1. Click Space icon in sidebar
2. Current Space content fades out, 150ms
3. Toolbar accent color transitions, 200ms
4. New Space content fades in + slides up 8px, 200ms, ease-out
5. Tab bar updates with Space-specific tabs, 150ms stagger
```

### Command Bar (Arc's Cmd+T replacement)
```
Open: 
  - Backdrop blur intensifies, 150ms
  - Command bar: translateY 8px→0 + scale 0.98→1.0 + opacity 0→1, 200ms
  - Focus immediately on input
  
Results:
  - Staggered fade-in, 30ms per result
  - Selected item: background rgba(255,255,255,0.08)
  - Result types: URL, history, bookmark, action
  - Each type has unique icon + color badge

Close:
  - Reverse open animation, 150ms, ease-in
```

### Boost (Pin) Animation
```
Boost: pin website to sidebar for quick access
Animation:
  1. Star icon fills (stroke→fill), 200ms
  2. Small star burst particles (5-8 particles), 300ms
  3. Icon scales 1.0→1.2→1.0, spring stiffness=400, damping=12
  4. Sidebar item slides in from left, 250ms, ease-out
```

---

## CROSS-APP PATTERN SUMMARY

### Universal Timing Values
| Interaction | Duration | Curve |
|---|---|---|
| Hover state | 100ms | ease |
| Button press | 100-150ms | ease-out |
| Micro-feedback | 150-200ms | ease-out |
| Panel/modal open | 200-300ms | ease-out / spring |
| Panel/modal close | 150-200ms | ease-in |
| Complex celebration | 800-1500ms | spring + stagger |
| Number counter | 400-600ms | ease-outCubic |
| Stagger delay | 30-50ms between items | — |

### Universal Spring Parameters
| Feel | Stiffness | Damping | Use Case |
|---|---|---|---|
| Snappy | 400-500 | 20-25 | Buttons, toggles |
| Smooth | 300 | 25-30 | Panels, modals |
| Bouncy | 200-250 | 8-12 | Celebrations, badges |
| Heavy | 200 | 30-40 | Drag-and-drop landing |

### Universal Haptic Map
| Event | iOS | Android |
|---|---|---|
| Light tap | .light | 10ms 50% amplitude |
| Selection | .selection | 5ms 40% amplitude |
| Medium action | .medium | 20ms 60% amplitude |
| Success | .success | 30ms pattern |
| Error | .error | 50ms double-pulse |
| Heavy milestone | .heavy | 30ms 80% amplitude |

### Universal Design Tokens (ProfileForge-recommended)
```
// Surfaces (Linear-inspired)
surface-0: #0A0A0B  (base)
surface-1: #151515  (cards)
surface-2: #1C1C1E  (elevated)
surface-3: #252528  (highlight)

// Text
text-primary: #EDEDED
text-secondary: #8E8E93
text-tertiary: #636366

// Accent
accent: #58CC02  (Duolingo green for gamification)
accent-blue: #1CB0F6
accent-gold: #FFC800
accent-purple: #8B5CF6

// Border
border-subtle: rgba(255,255,255,0.06)
border-hover: rgba(255,255,255,0.12)

// Radii
radius-sm: 4px
radius-md: 6-8px
radius-lg: 12px
radius-full: 9999px
```

---

## FLUTTER IMPLEMENTATION PRIORITY

### Must-Have (Week 1)
1. Spring animation utility class with preset profiles (snappy/smooth/bouncy/heavy)
2. Haptic feedback service (map events to platform haptics)
3. Staggered list item entrance animation
4. Button press micro-interaction (scale + haptic)
5. Task completion animation (checkbox draw + strikethrough)

### High Impact (Week 2)
6. Number counter roll animation (XP, streaks)
7. Circular progress ring (Duolingo-style XP ring)
8. Confetti/celebration particle system
9. Modal/drawer slide-in with backdrop blur
10. Pull-to-refresh with custom animation

### Polish (Week 3+)
11. Drag-and-drop reorder with spring physics
12. Swipe actions with threshold + spring-back
13. Tab bar with fill/stroke transition
14. Shared element transitions between pages
15. Skeleton loading with shimmer
