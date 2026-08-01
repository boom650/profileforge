# Research: Flutter Shaders, Material Design Motion, and Accessibility Patterns

## 1. Flutter FragmentProgram Shader System

### Overview (Flutter 3.7+)
- `FragmentProgram` creates `Shader` objects for use with `Paint.shader`
- Shaders are GLSL files with `.frag` extension (no vertex shaders / `.vert`)
- Supported GLSL versions: 100 through 460 (recommend `#version 460 core`)
- Both Skia and Impeller backends support custom shaders
- Hot reload supported in debug mode

### Setup

**pubspec.yaml:**
```yaml
flutter:
  shaders:
    - shaders/aurora_borealis.frag
    - shaders/gradient.frag
```

**Loading at runtime:**
```dart
final program = await FragmentProgram.fromAsset('shaders/aurora_borealis.frag');
final shader = program.fragmentShader();
```

### Uniform System
- `float`, `vec2`, `vec3`, `vec4` → set via `FragmentShader.setFloat(index, value)`
- `sampler2D` → set via `FragmentShader.setImageSampler(index, image)`
- Index order follows declaration order in GLSL
- For `vec4`, must call `setFloat` 4 times (one per component)
- Uninitialized floats default to `0.0`

### Position Access
```glsl
#include <flutter/runtime_effect.glsl>
vec2 currentPos = FlutterFragCoord().xy;
```
**Important:** Use `FlutterFragCoord()`, NOT `gl_FragCoord` — latter is inconsistent across backends.

### Color Output
- No built-in color type; use `vec4` (RGBA)
- Output `fragColor` must be **normalized 0.0–1.0** with **premultiplied alpha**

### Limitations
- No UBOs/SSBOs
- Only `sampler2D` sampler type
- Only 2-arg `texture(sampler, uv)`
- No custom varying inputs
- Precision hints ignored on Skia
- No unsigned integers or booleans

### ImageFilter API (Impeller only)
```dart
BackdropFilter(
  filter: ImageFilter.shader(shader),
  child: Container(color: Colors.transparent),
)
```
- Auto-provides `sampler2D` at index 0 (input image) + `vec2` at indices 0-1 (width/height)
- Wrap in `ClipRect` to limit affected area

### Canvas Usage
```dart
canvas.drawRect(rect, Paint()..shader = shader);         // shader fills rect
canvas.drawRect(rect, Paint()..style = PaintingStyle.stroke..shader = shader);  // stroke only
```

---

## 2. Aurora Borealis GLSL Shader

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p = p * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    float t = uTime * 0.3;

    // Aurora wave layers
    float n1 = fbm(vec2(uv.x * 3.0 + t, uv.y * 1.5));
    float n2 = fbm(vec2(uv.x * 2.0 - t * 0.7, uv.y * 2.0 + t * 0.5));
    float n3 = fbm(vec2(uv.x * 4.0 + t * 0.5, uv.y * 1.0 - t * 0.3));

    // Curtain shape — stronger in upper portion
    float curtain = smoothstep(0.1, 0.6, uv.y) * (1.0 - smoothstep(0.6, 0.95, uv.y));
    curtain *= smoothstep(0.0, 0.3, n1);

    // Color bands
    vec3 green = vec3(0.1, 0.8, 0.3);
    vec3 teal = vec3(0.1, 0.6, 0.7);
    vec3 purple = vec3(0.5, 0.1, 0.8);
    vec3 pink = vec3(0.8, 0.2, 0.5);

    vec3 color = mix(green, teal, n1);
    color = mix(color, purple, n2 * 0.5);
    color = mix(color, pink, n3 * 0.3);

    // Shimmer
    float shimmer = noise(vec2(uv.x * 20.0 + t * 2.0, uv.y * 8.0)) * 0.2;

    // Final alpha
    float alpha = curtain * (0.5 + shimmer);

    fragColor = vec4(color * alpha, alpha);
}
```

**Dart usage:**
```dart
class AuroraShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;

  AuroraShaderPainter(this.shader, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);   // uSize.x
    shader.setFloat(1, size.height);  // uSize.y
    shader.setFloat(2, time);         // uTime
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant AuroraShaderPainter old) => old.time != time;
}

// Animated version
class AuroraShaderWidget extends StatefulWidget {
  @override
  State<AuroraShaderWidget> createState() => _AuroraShaderWidgetState();
}

class _AuroraShaderWidgetState extends State<AuroraShaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _loadShader();
  }

  Future<void> _loadShader() async {
    final program = await FragmentProgram.fromAsset('shaders/aurora_borealis.frag');
    setState(() => _shader = program.fragmentShader());
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: AuroraShaderPainter(_shader!, _controller.value * 10),
        size: Size.infinite,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 3. Gradient Shader with Flutter (No GLSL needed — better approach)

Flutter's `Shader` from `Gradient` is simpler for gradients:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF6442D6),  // Deep purple
        Color(0xFF9F86FF),  // Light purple
        Color(0xFF4DB6FF),  // Cyan blue
        Color(0xFF40C4AA),  // Teal
      ],
    ),
  ),
)

// Or animated gradient
ShaderMask(
  shaderCallback: (Rect bounds) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color(0xFF6442D6),
        Color(0xFF9F86FF),
        Color(0xFF4DB6FF),
        Color(0xFF40C4AA),
      ],
    ).createShader(bounds);
  },
  child: YourWidget(),
)
```

If a custom gradient shader IS needed (e.g., noise-based gradient):

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(hash(i), hash(i + vec2(1,0)), f.x),
        mix(hash(i + vec2(0,1)), hash(i + vec2(1,1)), f.x),
        f.y
    );
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    float t = uTime * 0.1;

    float n = noise(uv * 3.0 + t);

    vec3 colorA = vec3(0.39, 0.26, 0.84);  // #6442D6
    vec3 colorB = vec3(0.62, 0.53, 1.0);   // #9F86FF
    vec3 colorC = vec3(0.30, 0.71, 1.0);   // #4DB6FF
    vec3 color = mix(mix(colorA, colorB, uv.x + n * 0.2), colorC, uv.y * 0.5);

    fragColor = vec4(color, 1.0);
}
```

---

## 4. Material Design 3 Motion Guidelines

### Motion System Overview
M3 motion communicates spatial relationships, focus, and state changes. It has three pillars:

### 4a. Easing

| Token | Value | Use Case |
|-------|-------|----------|
| `emphasized` | cubic-bezier(0.2, 0, 0, 1) | Most motion — entrance/exit |
| `emphasizedDecelerate` | cubic-bezier(0.05, 0.7, 0.1, 1.0) | Element entering screen |
| `emphasizedAccelerate` | cubic-bezier(0.3, 0, 0.8, 0.15) | Element exiting screen |
| `standard` | cubic-bezier(0.2, 0, 0, 1) | Sustained motion (hover, expand) |
| `standardDecelerate` | cubic-bezier(0, 0, 0, 1) | Elements settling to rest |
| `standardAccelerate` | cubic-bezier(0.3, 0, 1, 1) | Elements leaving permanently |

### 4b. Duration

| Size | Duration | Use Case |
|------|----------|----------|
| Short1 | 50ms | Micro-interactions (hover, press) |
| Short2 | 100ms | Icon morphs, state changes |
| Short3 | 150ms | Button press, toggle, FAB press |
| Short4 | 200ms | Expand, collapse, shimmer |
| Medium1 | 250ms | List item enter, card appear |
| Medium2 | 300ms | Navigation transitions |
| Medium3 | 350ms | Modal transitions |
| Medium4 | 400ms | Bottom sheet |
| Long1 | 450ms | Screen transition |
| Long2 | 500ms | Large element transition |
| Long3 | 550ms | Complex multi-element |
| Long4 | 600ms | Full-screen transitions |
| ExtraLong1 | 700ms | Background effects |
| ExtraLong2 | 800ms | Atmospheric transitions |
| ExtraLong3 | 900ms | Dramatic reveals |
| ExtraLong4 | 1000ms | Maximum — very large surfaces |

### 4c. Transition Types (Shared Axis)

| Transition | Duration | Easing |
|-----------|----------|--------|
| **Fade Through** | 300ms | emphasized (enter), emphasizedAccelerate (exit) |
| **Shared X-Axis** | 300ms | emphasized for both |
| **Shared Y-Axis** | 300ms | emphasized for both |
| **Shared Z-Axis** | 300ms | emphasized for both |

**Flutter mapping:**
```dart
// M3 Easing as Flutter Curves
const m3Emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
const m3EmphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);
const m3EmphasizedAccelerate = Cubic(0.3, 0.0, 0.8, 0.15);
const m3Standard = Cubic(0.2, 0.0, 0.0, 1.0);
const m3StandardDecelerate = Cubic(0.0, 0.0, 0.0, 1.0);
const m3StandardAccelerate = Cubic(0.3, 0.0, 1.0, 1.0);
```

### Flutter Page Transition Example
```dart
class M3FadeThroughRoute<T> extends PageRouteBuilder<T> {
  M3FadeThroughRoute({required WidgetBuilder builder})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: m3Emphasized,
              ),
              child: child,
            );
          },
        );
}
```

---

## 5. Flutter Accessibility Patterns for Animations

### Core API

| API | Purpose |
|-----|---------|
| `MediaQuery.disableAnimationsOf(context)` | Reduced motion preference (bool) |
| `MediaQuery.accessibleNavigationOf(context)` | Screen reader active |
| `MediaQuery.highContrastOf(context)` | High contrast mode |
| `Semantics(liveRegion:, label:, button:, value:)` | Accessibility metadata |

### Reduced Motion Detection Flow
```
User toggles OS Reduce Motion
  → Platform sets flag
  → dart:ui PlatformDispatcher.accessibilityFeatures updated
  → MediaQueryData.disableAnimations updated
  → Widgets depending on MediaQuery rebuild
  → Your widget reads disableAnimations in didChangeDependencies
```

### Platform Mapping
- **iOS:** Maps to `UIAccessibility.isReduceMotionEnabled`
- **Android:** Maps to `Settings.Global.ANIMATOR_DURATION_SCALE == 0`

### Reduced Motion Gate Pattern
```dart
// WRONG: initState won't update on live toggle
@override
void initState() {
  super.initState();
  _reduceMotion = MediaQuery.disableAnimationsOf(context); // BUG
}

// RIGHT: didChangeDependencies catches live changes
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _reduceMotion = MediaQuery.disableAnimationsOf(context);
}

// Usage in build
Widget build(BuildContext context) {
  return _reduceMotion
      ? staticFallback
      : AnimatedWidget();
}
```

### Screen Reader Semantics
```dart
// Live region — auto-announces value changes
Semantics(
  liveRegion: true,
  label: 'Progress: ${(value * 100).round()}%',
  child: AnimatedProgressIndicator(value: value),
)

// Button semantics on animated icon
Semantics(
  button: true,
  label: _isOpen ? 'Close menu' : 'Open menu',
  child: AnimatedRotation(turns: _isOpen ? 0.25 : 0, child: icon),
)

// Decorative effects — hide from accessibility tree
Semantics(
  excludeSemantics: true,
  child: BackgroundParticles(),  // or shader effects
)
```

### Device Capability Tiering
```dart
enum DeviceCapability { low, medium, high }

AnimationConfig forCapability(DeviceCapability cap, bool reduceMotion) {
  if (reduceMotion) return AnimationConfig.disabled();
  switch (cap) {
    case DeviceCapability.low:    return AnimationConfig.simple();    // 150ms
    case DeviceCapability.medium: return AnimationConfig.moderate();  // 250ms
    case DeviceCapability.high:   return AnimationConfig.full();      // 300ms
  }
}
```

| Tier | Android | iOS | Budget |
|------|---------|-----|--------|
| Low | SDK < 24 | iPhone 6s | 150ms, no particles |
| Medium | SDK 24-27 | iPhone 7-8 | 250ms, stagger 40ms |
| High | SDK 28+ | iPhone X+ | 300ms, particles, shadows |

### WCAG Compliance
- **4.5:1** minimum contrast ratio text/controls vs background
- Disabled components exempt from contrast
- All interactive elements need semantic labels
- Dynamic content changes → `liveRegion: true`

### Performance Pitfalls

1. **`Opacity` widget** → GPU-expensive `saveLayer()`. Use `FadeTransition` instead.
2. **`setState` high in tree** → rebuilds subtree. Extract animation into separate widget.
3. **`AnimatedBuilder` without `child` param** → rebuilds every frame. Pass via `child`.
4. **>3 concurrent `AnimationController`** → frame drops. Stagger or reuse.
5. **Missing `mounted` check after await** → crash on disposed widget.

### Profiling
```dart
// Frame timing
WidgetsBinding.instance.addTimingsCallback((timings) {
  for (final t in timings) {
    final frameMs = t.timestampInMicroseconds(FramePhase.rasterFinish)
        - t.timestampInMicroseconds(FramePhase.buildStart);
    if (frameMs > 16670) _droppedFrames++; // >16.67ms at 60fps
  }
});

// Impeller (default Flutter 3.16+ iOS, 3.19+ Android) eliminates shader compilation jank
```

---

## Sources

- Flutter docs: https://docs.flutter.dev/ui/design/graphics/fragment-shaders
- FragmentProgram API: https://api.flutter.dev/flutter/dart-ui/FragmentProgram-class.html
- Material Design 3 Motion: https://m3.material.io/styles/motion/overview
- M3 Easing & Duration: https://m3.material.io/styles/motion/easing-and-duration
- M3 Transition Motion: https://m3.material.io/styles/motion/transition-motion
- Flutter animation-patterns skill (local)
- Flutter accessibility-animation reference (local)
