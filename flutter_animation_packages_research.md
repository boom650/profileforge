# Premium Flutter Animation Packages — Research Summary

## 1. Lottie (`lottie: ^3.5.1`)
- **What**: Renders After Effects animations natively. Pure Dart implementation.
- **Repo**: https://github.com/xvrh/lottie-flutter
- **Requires**: Flutter >=3.44.0, Dart ^3.12.0
- **Dependencies**: archive, http, path, vector_math
- **Use cases**: Icon animations, loading states, onboarding illustrations, success/error micro-interactions
- **Performance tips**:
  - Pre-cache Lottie files (avoid network fetch on each play)
  - Use `Lottie.asset()` over `Lottie.network()` for critical animations
  - Limit concurrent playing animations (each runs on UI thread)
  - Use `LottieCompositionProvider` for efficient caching
  - Set `fit: BoxFit.contain` to avoid unnecessary repaints
  - Avoid Lottie for simple shape morphing — use Flutter's built-in `AnimatedContainer` instead
- **Best practice**: Design animations at 30fps max, keep shape count < 200 per composition
- **Also consider**: `dotlottie_flutter` for compressed .lottie format (smaller payloads)

## 2. Rive (`rive: ^0.14.10`)
- **What**: Runtime for Rive interactive animations. State-machine driven.
- **Repo**: https://github.com/rive-app/rive-flutter
- **Requires**: Flutter >=3.28.0, Dart >=3.6.0
- **Dependencies**: rive_native (C++ engine via FFI)
- **Use cases**: Interactive characters, buttons with states, loading indicators, game-like UI, complex state-driven animations
- **Performance tips**:
  - Rive runs on a native C++ engine — hardware-accelerated, excellent perf
  - Use Artboard-level caching when switching between states
  - Keep artboard complexity reasonable (< 500 shapes)
  - Use `RiveAnimation.asset()` with `autoplay: false` and control via StateMachineController
  - Batch state changes to avoid per-frame recomposition
  - For web: Rive uses CanvasKit renderer — heavier than HTML but consistent
- **Best practice**: Design with performance budgets. Use the Rive editor's runtime stats panel. State machines > artboard switching for interactivity.
- **Edge**: Only premium tool with real-time interactivity (user input drives animation state)

## 3. Confetti (`confetti: ^0.8.0`)
- **What**: Particle confetti explosions for celebrations/achievements.
- **Repo**: https://github.com/funwithflutter/flutter_confetti
- **Requires**: Flutter >=3.0.0, Dart >=2.17.0
- **Dependencies**: vector_math only
- **Use cases**: Achievement unlocks, order completion, level-up celebrations, onboarding success
- **Performance tips**:
  - Confetti bursts are short-lived — low impact on perf
  - Use `ConfettiController` to trigger programmatically, dispose when done
  - Limit particle count (< 100) for mobile; higher for web/desktop
  - Use `blastDirectionality: BlastDirectionality.explosive` for radial bursts
  - Set `shouldLoop: false` for one-shot celebrations
- **Best practice**: Wrap in `Visibility` widget, show only during animation lifetime

## 4. Flutter Animations (`animations: ^2.2.0`)
- **What**: Google's official Material motion transitions package.
- **Repo**: https://github.com/flutter/packages/tree/main/packages/animations
- **Requires**: Flutter >=3.35.0, Dart ^3.9.0
- **Dependencies**: Flutter SDK only
- **Use cases**: Container transforms, fade-through transitions, shared axis transitions, open container animations
- **Performance tips**:
  - Zero external dependencies — uses Flutter's built-in animation controllers
  - `SharedAxisTransition` for multi-page flows (tab transitions)
  - `FadeThroughTransition` for top-level navigation
  - `ContainerTransform` for FAB-to-detail transitions
  - All use standard `AnimationController` — no extra overhead
- **Best practice**: Follow Material motion guidelines. Use `OpenContainer` for hero-like transitions without the complexity of custom Hero animations.

## 5. Flutter Animate (`flutter_animate: ^4.5.2`)
- **What**: Declarative animation builder chain API. Drop-in animated effects.
- **Repo**: https://github.com/gskinner/flutter_animate
- **Use cases**: Staggered list animations, fade/slide/scale combos, shimmer effects, animated text
- **Performance tips**:
  - Chained `.animate()` calls are efficient — single controller per chain
  - Use `.animate()` on widgets to avoid separate `AnimationController` boilerplate
  - `Animate.when()` for conditional animations
  - Set `duration` at chain level to avoid per-effect overhead
  - For lists: use `staggerList()` utility for efficient staggered reveals
- **Best practice**: Replace scattered `AnimationController`+`StatefulWidget` combos with declarative chains. Reduces boilerplate 80%.

## 6. Animated Text Kit (`animated_text_kit: ^4.3.0`)
- **What**: Pre-built text animation effects (typewriter, fade, rotate, scale).
- **Use cases**: Loading text, hero text reveals, typewriter effects, glitch text
- **Performance tips**:
  - Lightweight — no external dependencies beyond Flutter
  - Dispose `AnimatedTextKit` controller when widget unmounts
  - Use `isRepeatingAnimation: false` for one-shot effects

---

## General Performance Guidelines for Premium Animation Feel

### Frame Budget
- Target 16ms per frame (60fps). Budget: ~12ms animation logic, 4ms buffer.
- Use `Timeline` class to profile: `Timeline.startSync('anim_name')` / `Timeline.finishSync()`
- Monitor with Flutter DevTools > Performance overlay

### Architecture
- Use `RepaintBoundary` around animated widgets to isolate repaint regions
- Prefer `AnimatedBuilder` over `setState()` for granular rebuilds
- Use `ImplicitlyAnimatedWidget` subclasses (AnimatedContainer, etc.) for simple property animations
- For complex sequences: `AnimationController` + `TweenSequence` > manual interpolation
- `Ticker` provider: use `TickerProviderStateMixin` only when multiple controllers needed; otherwise use `SingleTickerProviderStateMixin`

### Premium Feel Principles
- **Micro-interactions**: Every tap, toggle, success state should animate (100-300ms)
- **Easing**: Use `Curves.easeOutCubic` or `Curves.easeOutExpo` for natural deceleration. Avoid linear.
- **Stagger**: Delay child animations by 50-80ms for cascade effects
- **Spring physics**: Use `SpringSimulation` for organic feel (damping ratio 0.7-0.9)
- **Overshoot**: `Curves.elasticOut` for playful bounces (use sparingly)
- **Duration sweet spots**: Micro: 100-200ms. Standard: 200-400ms. Page transitions: 300-500ms. Hero: 300-400ms

### Asset Pipeline
- Lottie: Export at 2x, use Bodymovin plugin, minimize keyframes
- Rive: Design at 60fps, use state machines, export minimal artboard
- Preload critical animations in splash screen
- Cache animation compositions in memory for repeated plays

### Platform Considerations
- **Android**: Skia-based, good perf. Profile with `flutter run --profile`
- **iOS**: Metal renderer, excellent perf
- **Web**: CanvasKit mode (consistent but heavier), HTML renderer (lighter but limited effects)
- **Desktop**: Full GPU acceleration, can handle complex animations
