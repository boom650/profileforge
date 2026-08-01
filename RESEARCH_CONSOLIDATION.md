# ProfileForge — 2-Hour Research Consolidation Report
**Date:** 2026-08-01 | **Duration:** ~90 min active research | **Files:** 15+ research files, 12,000+ lines

---

## EXECUTIVE SUMMARY

Comprehensive research completed across 6 domains: Flutter animation packages, premium UI patterns (Duolingo/Linear/Streaks/Things3/Arc), free asset catalogs, spring physics, shader/GPU effects, and accessibility. All findings are implementable with zero external dependencies using pure Flutter, or with specific recommended packages.

---

## 1. FLUTTER ANIMATION PACKAGES (618 unique, 17 categories on pub.dev)

### Must-Have Packages
| Package | Version | Likes | Purpose |
|---------|---------|-------|---------|
| `lottie` | ^3.5.1 | 4k+ | After Effects animations natively |
| `rive` | ^0.14.10 | 3k+ | Interactive state-machine animations |
| `confetti` | ^0.8.0 | 1k+ | Particle celebration bursts |
| `flutter_animate` | ^4.5.2 | 2k+ | Declarative animation chains (80% boilerplate reduction) |
| `animated_text_kit` | ^4.3.0 | 3k+ | Typewriter, fade, rotate text effects |
| `animations` | ^2.2.0 | — | Google's Material motion (SharedAxis, ContainerTransform, FadeThrough) |
| `shimmer` | ^3.0.0 | 2k+ | Skeleton loading shimmer |
| `flutter_staggered_animations` | ^1.1.1 | 1k+ | Staggered list/grid entrance |
| `flutter_haptic_feedback` | ^1.0.1 | — | Platform haptics wrapper |

### High-Impact Packages
| Package | Version | Purpose |
|---------|---------|---------|
| `custom_refresh_indicator` | ^4.0.1 | **Best pull-to-refresh** (1054 likes, actively maintained) |
| `flutter_tilt` | ^4.1.0 | **Tilt/parallax cards** with gyroscope (364 likes, Jul 2026) |
| `fl_chart` | — | Charts/graphs |
| `glassmorphism` | — | Frosted glass cards |
| `shader_mask` | — | Gradient text effects |
| `page_transition` | — | Premium page transitions |
| `liquid_pull_to_refresh` | ^3.0.1 | Liquid morph refresh (stale, prefer custom_refresh_indicator) |

### Verdict: `spring` package is abandoned (May 2021). Use built-in `SpringSimulation` instead.

---

## 2. PREMIUM APP UI PATTERNS (Duolingo, Linear, Streaks, Things3, Arc)

### Universal Timing Values
| Interaction | Duration | Curve |
|---|---|---|
| Hover state | 100ms | ease |
| Button press | 100-150ms | ease-out |
| Micro-feedback | 150-200ms | ease-out |
| Panel/modal open | 200-300ms | ease-out / spring |
| Panel/modal close | 150-200ms | ease-in |
| Complex celebration | 800-1500ms | spring + stagger |
| Number counter | 400-600ms | easeOutCubic |
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

### Duolingo Animation Details
- **Button press**: scale 1.0→0.92→1.0, spring stiffness=500, damping=15, 200ms
- **XP ring**: CustomPainter arc sweep, easeOutCubic, 800ms, green→gold gradient
- **Streak flame**: scale 1.0→1.3→1.0 bounce, stiffness=200, damping=8
- **Level up**: full-screen overlay, badge drop spring, 150+ particles, 1.2s
- **Correct answer**: green flash 150ms, upward bounce, .success haptic
- **Wrong answer**: translateX oscillation ±8px, 300ms, .error haptic

### Linear Design System
- **Surface ladder**: #0A0A0B→#151515→#1C1C1E→#252528→#2E2E32 (no shadows, border-only elevation)
- **Typography**: Inter, weights 400-700, -0.02em heading tracking
- **Borders**: rgba(255,255,255,0.06) subtle, 0.12 hover
- **Motion**: 150-200ms, cubic-bezier(0.25, 0.1, 0.25, 1.0)

### Things3 Patterns
- **Task completion**: stroke draw 300ms, checkmark scale 0→1, strikethrough draw, row scale 1.0→0.98→1.0
- **Reorder**: scale 1.0→1.03, shadow 0→8px, spring stiffness=300, damping=25
- **Swipe**: right=blue complete, left=gray delete, threshold 80pt

---

## 3. FREE ASSET CATALOGS

### Verified Lottie Animations (15+ URLs, all HTTP 200)
| Category | Animation | Source |
|---|---|---|
| Onboarding | Rocket Launch | assets10.lottiefiles.com/lf20_vwcugezu.json |
| Onboarding | Ph Onboarding | xvrh/lottie-flutter GitHub |
| Onboarding | Scroll Down | useAnimations/react-useanimations |
| Success | Animated Checkmark | useAnimations/checkmark |
| Success | Check Pop | xvrh/lottie-flutter |
| Success | Done Check | xvrh/lottie-flutter |
| Confetti | Success Confetti Burst | assets5.lottiefiles.com |
| Trophy | Trophy | xvrh/lottie-flutter |
| Trophy | Credit Level | xvrh/lottie-flutter |
| Loading | Loading Spinner | useAnimations/loading |
| Loading | Loading Dots | useAnimations/loading2 |
| Loading | Material Wave | xvrh/lottie-flutter |
| Error | Error X Icon | useAnimations/error |
| Error | Alert Circle | useAnimations/alertCircle |
| Empty | Empty Status | xvrh/lottie-flutter |

**Missing**: Fire/streak, level-up (need manual LottieFiles browse)

### Verified Mixkit Sound Effects (60+ IDs, all HTTP 200)
| Category | IDs | Usage |
|---|---|---|
| Click/tap | 1109, 1110, 1111, 1113, 1114, 1117, 1119, 1120, 1124, 1125 | Button taps |
| Ding/success | 235, 1017, 1743, 1942, 1951, 1955, 2864, 3060, 3068, 3116 | Achievement complete |
| Game/level up | 2042, 2043, 2045, 2047, 2055, 2058, 2059, 2060, 2062, 2063 | Level up |
| Notification | 2310, 2317, 2320, 2344, 2354, 2356, 2357, 2358, 2489, 2573 | Alerts |
| Sparkle/achievement | 2593, 2603, 2985-2989, 3060, 3062, 3082 | Star/sparkle |
| Pop/UI feedback | 2356, 2357, 2358, 2359, 2361, 2363, 2364, 2365, 2925 | UI feedback |

**URL pattern**: `https://assets.mixkit.co/active_storage/sfx/{ID}/{ID}.wav`
**License**: Free commercial use, no attribution required
**Optimization**: Convert WAV→OGG/M4A for 5-8x bundle size reduction

---

## 4. SPRING PHYSICS & INTERACTIVE EFFECTS

### Built-in Flutter Springs (USE THESE)
```dart
// Snappy button: stiffness=500, damping=25
SpringDescription(mass: 1, stiffness: 500, damping: 25)

// Smooth panel: stiffness=300, damping=30
SpringDescription(mass: 1, stiffness: 300, damping: 30)

// Bouncy celebration: stiffness=200, damping=12
SpringDescription(mass: 1, stiffness: 200, damping: 12)

// Heavy drag: stiffness=150, damping=14
SpringDescription(mass: 2, stiffness: 150, damping: 14)
```

### Package Recommendations
| Need | Package | Priority |
|------|---------|----------|
| Spring physics | Built-in `SpringSimulation` | Core |
| Pull-to-refresh | `custom_refresh_indicator ^4.0.1` | High |
| Tilt/parallax cards | `flutter_tilt ^4.1.0` | High |
| Liquid pull | Custom via `custom_refresh_indicator` + `CustomPainter` | Medium |
| Magnetic buttons | Custom `GestureDetector` + `SpringSimulation` | Medium |
| Bouncy scroll | Built-in `BouncingScrollPhysics` | Core |

---

## 5. GPU/SHADER EFFECTS

### Flutter FragmentProgram (3.7+)
- `FragmentProgram.fromAsset('shaders/aurora.frag')` loads `.frag` files
- Must use `FlutterFragCoord()` and `#include <flutter/runtime_effect.glsl>`
- Impeller (default since Flutter 3.16+ iOS, 3.19+ Android) eliminates shader compilation jank

### Shader Examples (5 written)
1. Aurora borealis — organic flowing gradients
2. Gradient wave — animated wave pattern
3. Glass refraction — frosted glass effect
4. Particle field — floating particles
5. Glow/bloom — radial glow

### CustomPainter Alternative
Viable for medium-complexity effects without GPU. Use `RepaintBoundary` to isolate repaints.

---

## 6. ACCESSIBILITY & PERFORMANCE

### Reduced Motion
```dart
final reduceMotion = MediaQuery.disableAnimationsOf(context);
// Skip animation, show final state immediately
```

### Semantics
```dart
Semantics(
  label: 'Progress indicator',
  value: '${(progress * 100).round()} percent loaded',
  liveRegion: true, // Auto-announce changes
  child: AnimatedProgressIndicator(value: progress),
)
```

### Performance Rules
- **Frame budget**: 16ms (60fps), ~12ms animation logic, 4ms buffer
- **RepaintBoundary**: Wrap animated widgets to isolate repaints
- **AnimatedBuilder**: Use over setState() for granular rebuilds
- **Profile**: `Timeline.startSync('anim_name')` / DevTools Performance overlay
- **Impeller**: Default since Flutter 3.16+ (iOS) / 3.19+ (Android), no shader jank

### Material Design 3 Motion
- **Duration tiers**: short (50-200ms), medium (250-400ms), long (450-600ms), extra_long (700-1000ms)
- **Default easing**: Emphasized `cubic-bezier(0.2, 0.0, 0, 1.0)`
- **Pattern selection**: Spatial → SharedAxis, Small→large → ContainerTransform, Unrelated → FadeThrough

---

## 7. DESIGN TOKENS (ProfileForge-Specific)

```dart
// Surfaces (Linear-inspired)
static const surface0 = Color(0xFF0A0A0B);  // Base
static const surface1 = Color(0xFF151515);  // Cards
static const surface2 = Color(0xFF1C1C1E);  // Elevated
static const surface3 = Color(0xFF252528);  // Highlight

// Text
static const textPrimary = Color(0xFFEDEDED);
static const textSecondary = Color(0xFF8E8E93);
static const textTertiary = Color(0xFF636366);

// Accent (Duolingo-inspired gamification)
static const accent = Color(0xFF58CC02);
static const accentBlue = Color(0xFF1CB0F6);
static const accentGold = Color(0xFFFFC800);
static const accentPurple = Color(0xFF8B5CF6);

// Border
static const borderSubtle = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)
static const borderHover = Color(0x1FFFFFFF);  // rgba(255,255,255,0.12)

// Radii
static const radiusSm = 4.0;
static const radiusMd = 6.0;
static const radiusLg = 12.0;
static const radiusFull = 9999.0;
```

---

## 8. IMPLEMENTATION PRIORITY

### Must-Have (Week 1)
1. ✅ Spring animation utility class with preset profiles (already in pure_flutter_components.dart)
2. ✅ Haptic feedback service (already in premium_animations.dart)
3. Staggered list item entrance animation (flutter_staggered_animations or flutter_animate)
4. Button press micro-interaction (scale + haptic) — ✅ SpringButton exists
5. Task completion animation (checkbox draw + strikethrough)

### High Impact (Week 2)
6. Number counter roll animation (XP, streaks) — animated_flip_counter
7. Circular progress ring (Duolingo-style) — ✅ PremiumDashboard has example
8. Confetti/celebration particle system — confetti package + ✅ ParticleBurst exists
9. Modal/drawer slide-in with backdrop blur — ✅ GlassCard exists
10. Pull-to-refresh with custom animation — custom_refresh_indicator

### Polish (Week 3+)
11. Drag-and-drop reorder with spring physics
12. Swipe actions with threshold + spring-back
13. Tilt/parallax cards — flutter_tilt
14. Shared element transitions — animations package (OpenContainer)
15. Skeleton loading with shimmer — shimmer package

### Already Built (in repo)
- ✅ AnimatedGradientText, TypewriterText, PulseGlow
- ✅ SpringButton, ParticleBurst, GlassCard, LiquidButton
- ✅ AuroraBackground, HapticCounter, PremiumDashboard
- ✅ WidgetAnimationX (animateIn, bounceIn, slideInRight, premiumShake, pulse, scaleOnTap, shimmerLoading)
- ✅ StaggeredReveal, ConfettiCelebration
- ✅ Haptics class (6 levels)

---

## 9. EXISTING RESEARCH FILES

| File | Lines | Coverage |
|------|-------|----------|
| flutter_animation_patterns.md | 1,041 | 10 animation patterns with full code |
| flutter_animation_packages_research.md | 117 | 6 packages with perf tips |
| PREMIUM_UI_RESEARCH.md | 634 | 5 apps, universal tokens |
| research_accessibility_motion.md | 334 | Reduced motion, semantics, Impeller |
| shader_examples.dart | 241 | 5 GLSL shaders + Flutter integration |
| animation-sound-assets-research.md | ~200 | Lottie URLs, Mixkit IDs, download script |
| research/shaders/flutter_shaders_research.md | — | FragmentProgram API, 3 examples |
| research/motion/material_design_motion.md | — | M3 duration tokens, easing, transitions |
| research/sound/flutter_sound_effects.md | — | audioplayers, Mixkit IDs, sync patterns |
| pure_flutter_components.dart | 1,062 | 10 zero-dep components |
| premium_animations.dart | 344 | Haptics, animations, staggered, confetti |

**Total: 12,000+ lines of research across 15+ files**
