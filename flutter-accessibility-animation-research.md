# Flutter Accessibility & Animation Performance Best Practices

## Research Summary

Concrete patterns, API references, and implementation guidance for making Flutter animations accessible and performant.

---

## 1. Reduced Motion Preferences (`MediaQuery.disableAnimations`)

### How It Works

Flutter reads the platform's accessibility setting (iOS: `UIAccessibility.isReduceMotionEnabled`, Android: `Settings.Global.ANIMATOR_DURATION_SCALE == 0`) and exposes it as:

```dart
MediaQuery.disableAnimationsOf(context)  // bool
```

The value originates from `dart:ui.PlatformDispatcher.accessibilityFeatures`.

### Implementation Pattern

```dart
class AccessibleAnimatedWidget extends StatelessWidget {
  final Widget child;
  const AccessibleAnimatedWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    if (reduceMotion) {
      // Skip animation, show final state immediately
      return child;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1.0,
      child: child,
    );
  }
}
```

### Wrapper Utility

```dart
/// Returns either the animated child or a static fallback.
Widget buildWithReducedMotion({
  required BuildContext context,
  required Widget animatedChild,
  required Widget staticChild,
}) {
  return MediaQuery.disableAnimationsOf(context)
      ? staticChild
      : animatedChild;
}
```

### Listening to Changes

```dart
class _MyState extends State<MyWidget> {
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mq = MediaQuery.of(context);
    _reduceMotion = mq.disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) {
      return const StaticVersion();
    }
    return AnimatedVersion();
  }
}
```

**Key point:** `MediaQueryData` is inherited, so rebuilding `MediaQuery` (e.g., via `MediaQueryData.fromView`) propagates changes. No manual listener needed for most cases.

---

## 2. Making Animations Accessible (Semantics & Screen Readers)

### Semantics Widget

Use `Semantics` to describe animated state changes to screen readers (TalkBack/VoiceOver):

```dart
Semantics(
  label: 'Progress indicator',
  value: '${(progress * 100).round()} percent loaded',
  liveRegion: true, // Announce changes automatically
  child: AnimatedProgressIndicator(value: progress),
)
```

### Announce Dynamic Content Changes

For content that updates via animation:

```dart
Semantics(
  liveRegion: true,
  label: 'Order status: $statusLabel',
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: Text(
      statusLabel,
      key: ValueKey(statusLabel),
    ),
  ),
)
```

**`liveRegion: true`** triggers screen reader announcements when the child changes. Essential for animated status updates, counters, notifications.

### Semantic Labels on Interactive Animations

```dart
GestureDetector(
  onTap: () => _toggleMenu(),
  child: Semantics(
    button: true,
    label: _isMenuOpen ? 'Close menu' : 'Open menu',
    child: AnimatedRotation(
      turns: _isMenuOpen ? 0.25 : 0,
      duration: const Duration(milliseconds: 200),
      child: const Icon(Icons.menu),
    ),
  ),
)
```

### Hiding Decorative Animations from Screen Readers

```dart
Semantics(
  excludeSemantics: true, // Don't announce decorative elements
  child: ParticleEffectAnimation(),
)
```

### Testing with SemanticsDebugger

Wrap your app with `SemanticsDebugger` in debug mode to visualize the semantic tree:

```dart
MaterialApp(
  home: SemanticsDebugger(
    labelStyle: const TextStyle(color: Colors.red, fontSize: 12),
    child: MyAnimatedScreen(),
  ),
)
```

### Contrast Ratio

Flutter docs recommend minimum **4.5:1** contrast ratio between text/controls and background (WCAG AA). Disabled components are exempt.

---

## 3. Platform-Specific Animation Optimizations

### iOS

- Core Animation handles compositing. Flutter's raster thread uses Impeller (default since Flutter 3.16+).
- iOS 16+ supports `UIAccessibility.isReduceMotionEnabled` — Flutter exposes this via `MediaQuery.disableAnimations`.
- No shader compilation jank on iOS with Impeller (precompiled shaders).

### Android

- Impeller is default on Android since Flutter 3.19+ (eliminates shader compilation jank).
- Older Android devices without Impeller: first-time shader compilation causes frame drops.
- `PlatformDispatcher.accessibilityFeatures` reads `Settings.Global.ANIMATOR_DURATION_SCALE`.
- When `ANIMATOR_DURATION_SCALE == 0`, `MediaQuery.disableAnimations == true`.

### Impeller vs Skia

```dart
// Impeller (default, no shader jank):
// Flutter >= 3.16 iOS, >= 3.19 Android
// Check in Profile/Release mode

// Force Impeller on Android (if needed):
// --enable-impeller flag in AndroidManifest.xml or:
// flutter run --enable-impeller

// Check at runtime:
import 'dart:io';
import 'package:flutter/foundation.dart';

bool get usesImpeller {
  // Impeller is default on iOS and recent Android
  if (Platform.isIOS) return true;
  if (Platform.isAndroid) {
    // Check Android version or use platform channel
    return true; // Flutter 3.19+ uses Impeller by default
  }
  return false;
}
```

### Platform-Channel Device Info

```dart
import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isLowEndDevice() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    // Android SDK < 26 or RAM < 3GB = low-end
    return androidInfo.version.sdkInt < 26;
  }

  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    // Check if device model is old
    // e.g., iPhone 6s and earlier are low-end
    final machine = iosInfo.utsname.machine;
    return machine.contains('iPhone8') ||
        machine.contains('iPhone7') ||
        machine.contains('iPhone6');
  }

  return false;
}
```

---

## 4. Low-End Device Detection & Animation Fallback Strategies

### Device Capability Class

```dart
enum DeviceCapability { low, medium, high }

class DeviceCapabilityDetector {
  static DeviceCapability? _cached;

  static Future<DeviceCapability> detect() async {
    if (_cached != null) return _cached!;

    final deviceInfo = DeviceInfoPlugin();
    DeviceCapability capability = DeviceCapability.high;

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      final sdkInt = info.version.sdkInt;
      // Rough heuristic
      if (sdkInt < 24) {
        capability = DeviceCapability.low;
      } else if (sdkInt < 28) {
        capability = DeviceCapability.medium;
      }
    }

    _cached = capability;
    return capability;
  }
}
```

### Animation Tier System

```dart
class AnimationConfig {
  final bool enableComplexAnimations;
  final bool enableParticles;
  final bool enableShadows;
  final Duration defaultDuration;
  final Duration staggerDelay;

  const AnimationConfig({
    required this.enableComplexAnimations,
    required this.enableParticles,
    required this.enableShadows,
    required this.defaultDuration,
    required this.staggerDelay,
  });

  factory AnimationConfig.forCapability(DeviceCapability cap, bool reduceMotion) {
    if (reduceMotion) {
      return const AnimationConfig(
        enableComplexAnimations: false,
        enableParticles: false,
        enableShadows: false,
        defaultDuration: Duration.zero,
        staggerDelay: Duration.zero,
      );
    }

    switch (cap) {
      case DeviceCapability.low:
        return const AnimationConfig(
          enableComplexAnimations: false,
          enableParticles: false,
          enableShadows: false,
          defaultDuration: Duration(milliseconds: 150),
          staggerDelay: Duration.zero,
        );
      case DeviceCapability.medium:
        return const AnimationConfig(
          enableComplexAnimations: true,
          enableParticles: false,
          enableShadows: false,
          defaultDuration: Duration(milliseconds: 250),
          staggerDelay: Duration(milliseconds: 40),
        );
      case DeviceCapability.high:
        return const AnimationConfig(
          enableComplexAnimations: true,
          enableParticles: true,
          enableShadows: true,
          defaultDuration: Duration(milliseconds: 300),
          staggerDelay: Duration(milliseconds: 80),
        );
    }
  }
}
```

### Usage with Provider/InheritedWidget

```dart
class AnimationConfigProvider extends InheritedWidget {
  final AnimationConfig config;
  const AnimationConfigProvider({
    super.key,
    required this.config,
    required super.child,
  });

  static AnimationConfig of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AnimationConfigProvider>()!
        .config;
  }

  @override
  bool updateShouldNotify(AnimationConfigProvider oldWidget) =>
      config != oldWidget.config;
}

// In widget:
final config = AnimationConfigProvider.of(context);
if (config.enableParticles) {
  // Show confetti
}
```

---

## 5. Performance Profiling Tools

### DevTools Performance View

- **Flutter Frames Chart:** Shows per-frame timing (UI thread + Raster thread).
- **Frame Analysis Tab:** Detailed breakdown of a selected frame.
- **Timeline Events Trace:** Full Dart/Flutter event timeline.
- **Important:** Use `--profile` mode, NOT `--debug` for accurate measurements.

```bash
flutter run --profile
```

### In-App Performance Overlay

```dart
MaterialApp(
  showPerformanceOverlay: true, // Green = UI thread, Red = Raster thread
  // Bars > 16ms = dropped frame (jank)
)
```

### `PerformanceOverlayLayer.checkerboardOffscreenLayers`

```dart
MaterialApp(
  showPerformanceOverlay: true,
  // In debug mode, this enables checkerboard for saveLayer() calls
  // Identify expensive saveLayer usage
)
```

### Debug Flags

```dart
import 'package:flutter/foundation.dart';

// Rebuild debug banner
debugPaintSizeEnabled = false;

// Disable animations for profiling
debugDisableAnimations = false; // Don't use — defeats purpose of profiling

// Check if running in debug vs profile
if (kDebugMode) {
  print('Running in debug mode — performance numbers unreliable');
}
if (kProfileMode) {
  print('Running in profile mode — accurate performance numbers');
}
```

### DevTools Inspector Visual Debugging

- **Slow Animations:** Runs animations 5x slower for fine-tuning.
- **Highlight Repaints:** Shows repainted regions (flashing colors).
- **Highlight Oversized Images:** Flags oversized image assets.
- **Show Guidelines:** Layout baselines and padding visualization.

### Timeline API (Custom Markers)

```dart
import 'dart:developer';

// Add custom timeline events for specific animations
Timeline.startSync('MyAnimation_Start');
await _animationController.forward();
Timeline.finishSync();

// Or use Timeline Sync/Async wrappers
Timeline.sync('animation_forward', () {
  _animationController.forward();
});
```

---

## 6. Benchmarking Animation Frame Rates

### Frame Timing API

```dart
import 'dart:ui' as ui;

class FrameRateMonitor {
  final List<double> _frameTimes = [];
  int _lastFrameTimestamp = 0;
  bool _isMonitoring = false;

  void startMonitoring() {
    _isMonitoring = true;
    _frameTimes.clear();

    // Use SchedulerBinding for frame callbacks
    WidgetsBinding.instance.addTimingsCallback((List<ui.FrameTiming> timings) {
      if (!_isMonitoring) return;

      for (final timing in timings) {
        final buildStart = timing.timestampInMicroseconds(FramePhase.rasterFinish) -
            timing.timestampInMicroseconds(FramePhase.buildStart);
        _frameTimes.add(buildStart / 1000.0); // Convert to ms
      }
    });
  }

  FrameRateReport stopMonitoring() {
    _isMonitoring = false;

    if (_frameTimes.isEmpty) {
      return const FrameRateReport(
        avgFrameTime: 0,
        fps: 0,
        droppedFrames: 0,
        p95FrameTime: 0,
      );
    }

    _frameTimes.sort();
    final avg = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
    final p95Index = (_frameTimes.length * 0.95).floor();
    final dropped = _frameTimes.where((t) => t > 16.67).length; // >16.67ms = dropped at 60fps

    return FrameRateReport(
      avgFrameTime: avg,
      fps: 1000 / avg,
      droppedFrames: dropped,
      p95FrameTime: _frameTimes[p95Index],
    );
  }
}

class FrameRateReport {
  final double avgFrameTime;
  final double fps;
  final int droppedFrames;
  final double p95FrameTime;

  const FrameRateReport({
    required this.avgFrameTime,
    required this.fps,
    required this.droppedFrames,
    required this.p95FrameTime,
  });

  @override
  String toString() =>
      'FPS: ${fps.toStringAsFixed(1)} | Avg: ${avgFrameTime.toStringAsFixed(1)}ms | '
      'P95: ${p95FrameTime.toStringAsFixed(1)}ms | Dropped: $droppedFrames';
}
```

### Usage

```dart
final monitor = FrameRateMonitor();
monitor.startMonitoring();

// ... run animation ...

final report = monitor.stopMonitoring();
print(report); // FPS: 59.2 | Avg: 16.9ms | P95: 18.3ms | Dropped: 2
```

### DevTools CLI Profiling

```bash
# Record a performance trace
flutter run --profile --trace-startup

# Analyze with dart:convert
# Or export from DevTools timeline viewer as JSON
```

---

## 7. Memory Management for Animations

### Dispose Pattern (Critical)

```dart
class _AnimatedScreenState extends State<AnimatedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // CRITICAL — prevents memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeIn, child: widget.child);
  }
}
```

### Multiple Controllers

```dart
class _MultiAnimState extends State<MultiAnim>
    with TickerProviderStateMixin { // NOT SingleTickerProviderStateMixin
  late AnimationController _controllerA;
  late AnimationController _controllerB;

  @override
  void initState() {
    super.initState();
    _controllerA = AnimationController(vsync: this, duration: 200.ms);
    _controllerB = AnimationController(vsync: this, duration: 400.ms);
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    super.dispose();
  }
}
```

### Check `mounted` Before setState

```dart
Future<void> _animateAfterDelay() async {
  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return; // Widget may have been disposed during delay

  setState(() {
    _showOverlay = true;
  });
}
```

### Controller Reuse / Pooling

```dart
/// Pool of reusable controllers — avoids creating/disposing repeatedly.
class AnimationControllerPool {
  final Map<String, AnimationController> _pool = {};
  final TickerProvider _tickerProvider;

  AnimationControllerPool(this._tickerProvider);

  AnimationController acquire({
    required String key,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _pool.putIfAbsent(
      key,
      () => AnimationController(vsync: _tickerProvider, duration: duration),
    );
  }

  void disposeAll() {
    for (final controller in _pool.values) {
      controller.dispose();
    }
    _pool.clear();
  }
}
```

### Cancel Timers and Subscriptions

```dart
class _MyState extends State<MyWidget> {
  Timer? _debounce;
  StreamSubscription? _streamSub;

  @override
  void initState() {
    super.initState();
    _debounce = Timer.periodic(const Duration(seconds: 1), _onTick);
    _streamSub = someStream.listen(_onData);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _streamSub?.cancel();
    super.dispose();
  }
}
```

### RepaintBoundary for Isolated Animation

```dart
// Prevent animation repaints from triggering parent rebuilds
RepaintBoundary(
  child: AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return CustomPaint(
        painter: _ParticlePainter(progress: _controller.value),
        child: child,
      );
    },
  ),
)
```

---

## 8. Best Practices for Animation Performance on Older Devices

### Avoid Expensive Operations

| Operation | Cost | Alternative |
|-----------|------|-------------|
| `Opacity` widget | Calls `saveLayer()` | Use `FadeTransition` |
| `ClipRRect`/`ClipOval` | Calls `saveLayer()` | Use `AnimatedPhysicalModel` or pre-masked images |
| Large `setState()` | Rebuilds entire subtree | `ValueListenableBuilder`, extract widgets |
| Nested `AnimatedOpacity` | Multiple `saveLayer()` | Flatten opacity animations |
| `Stack` with `Positioned` | Full layout each frame | Use `Transform` for positioning |

### Transform Over Layout

```dart
// BAD: Triggers layout pass on every frame
Transform.translate(
  offset: Offset(100 * _controller.value, 0),
  child: myWidget,
)

// BETTER: Avoids layout entirely — just paint transform
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.translate(
      offset: Offset(100 * _controller.value, 0),
      child: child,
    );
  },
  child: myWidget, // Rebuilt once, not per frame
)
```

### Use `AnimatedBuilder` Correctly

```dart
// CORRECT: child rebuilt once, builder called per frame
AnimatedBuilder(
  animation: _controller,
  child: ExpensiveWidget(), // Built once, reused
  builder: (context, child) {
    return Transform.scale(
      scale: _controller.value,
      child: child,
    );
  },
)

// BAD: ExpensiveWidget rebuilds every frame
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.scale(
      scale: _controller.value,
      child: ExpensiveWidget(), // Rebuilt 60x/sec
    );
  },
)
```

### Limit Animation Count

- Max 2-3 concurrent `AnimationController` instances for smooth 60fps.
- Stagger list animations (don't animate all items simultaneously).
- Use `TickerMode.of(context) == false` to skip animations in offscreen tabs.

### Prefer Implicit Animations

```dart
// Implicit animations (AnimatedContainer, AnimatedOpacity, etc.)
// are simpler and auto-dispose controllers:
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  height: _expanded ? 200 : 100,
)
```

### Image Animation Optimization

```dart
// Cache images used in animations
CachedNetworkImage(
  imageUrl: url,
  fit: BoxFit.cover,
  memCacheWidth: 300, // Limit memory cache size
)

// Avoid animating large images — use thumbnails
```

### Shader Compilation (Pre-Impeller)

```dart
// Warm up shaders at app start (pre-Impeller only)
import 'package:flutter/material.dart';

class ShaderWarmUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.red, Colors.blue],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### Checklist for Older Devices

1. **Detect capability** via `device_info_plus` (SDK version, RAM).
2. **Respect `disableAnimations`** — skip all non-essential motion.
3. **Reduce stagger count** — fewer simultaneous animations.
4. **Simplify curves** — linear or `easeInOut` instead of elastic/bounce.
5. **Skip particle effects** on low-end.
6. **Use `RepaintBoundary`** to isolate animation regions.
7. **Profile with `--profile` mode** — never trust debug mode timings.
8. **Set `itemExtent`** on `ListView`/`GridView` for scroll performance.
9. **Avoid `saveLayer()`** — replace `Opacity` with `FadeTransition`.
10. **Cache images** with `memCacheWidth` limits.

---

## Key API References

| API | Purpose |
|-----|---------|
| `MediaQuery.disableAnimationsOf(context)` | Check reduced motion preference |
| `MediaQuery.accessibleNavigationOf(context)` | Check if screen reader active |
| `MediaQuery.highContrastOf(context)` | Check high contrast mode |
| `Semantics(label:, liveRegion:, button:, value:)` | Add accessibility metadata |
| `SemanticsDebugger` | Visualize semantic tree in debug |
| `AnimationController(vsync: this, duration:)` | Core animation controller |
| `SingleTickerProviderStateMixin` | One controller per State |
| `TickerProviderStateMixin` | Multiple controllers per State |
| `RepaintBoundary` | Isolate repaint regions |
| `AnimatedBuilder` | Efficient per-frame rebuilds |
| `DeviceInfoPlugin` | Device capability detection |
| `SchedulerBinding.instance.addTimingsCallback` | Frame timing benchmarks |
| `showPerformanceOverlay: true` | In-app frame timing bars |
| `devtools` / Timeline | Full performance profiling |

---

## Sources

- Flutter Docs: https://docs.flutter.dev/ui/accessibility
- Flutter Docs: https://docs.flutter.dev/perf/best-practices
- Flutter Docs: https://docs.flutter.dev/tools/devtools/performance
- Flutter Docs: https://docs.flutter.dev/tools/devtools/inspector
- API: `MediaQueryData.disableAnimations` — https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html
- API: `AnimationController` — https://api.flutter.dev/flutter/animation/AnimationController-class.html
- API: `Semantics` — https://api.flutter.dev/flutter/widgets/Semantics-class.html
- API: `SemanticsDebugger` — https://api.flutter.dev/flutter/widgets/SemanticsDebugger-class.html
- pub.dev: `device_info_plus` — https://pub.dev/packages/device_info_plus
