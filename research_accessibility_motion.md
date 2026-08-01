# Flutter Accessibility & Animation Best Practices

## 1. REDUCED MOTION SUPPORT

Flutter provides `MediaQuery.disableAnimations` to detect when the user has enabled
"Reduce Motion" in their OS settings. This is critical for accessibility.

```dart
class AccessibleAnimation extends StatelessWidget {
  final Widget child;
  const AccessibleAnimation({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimations(context);
    return reduceMotion
        ? child // No animation
        : AnimatedWidget(child: child); // Full animation
  }
}
```

### Platform-Specific Settings
- **iOS**: Settings → Accessibility → Motion → Reduce Motion
- **Android**: Settings → Accessibility → Remove animations
- **macOS**: System Preferences → Accessibility → Display → Reduce motion

### Flutter Implementation
```dart
// In your app's theme or wrapper
class AnimationWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Widget Function(Widget child, Animation<double> animation)? animatedBuilder;

  const AnimationWrapper({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.animatedBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    
    if (reduceMotion) {
      return child; // Skip animation entirely
    }

    return AnimatedSwitcher(
      duration: duration,
      child: child,
    );
  }
}
```

---

## 2. SEMANTIC LABELS FOR ANIMATED WIDGETS

Animated widgets must have proper semantics for screen readers.

```dart
// BAD: No semantic label
Lottie.asset('assets/animations/success.json')

// GOOD: With semantic label
Semantics(
  label: 'Mission completed successfully',
  child: Lottie.asset('assets/animations/success.json'),
)

// GOOD: Live region for dynamic updates
Semantics(
  liveRegion: true,
  label: 'Streak: 7 days',
  child: AnimatedCounter(value: 7),
)
```

### Key Semantics Properties
- `label`: Text description of the widget
- `hint`: Additional instructions (e.g., "Double tap to activate")
- `liveRegion: true`: Announce changes to screen readers
- `button: true`: Mark interactive elements
- `increasedValue` / `decreasedValue`: For numeric changes

---

## 3. PERFORMANCE RULES

### Animation Optimization
1. **Use `RepaintBoundary`** to isolate animated widgets
   ```dart
   RepaintBoundary(
     child: AnimatedWidget(),
   )
   ```

2. **Prefer `Transform` over `Container` decoration changes**
   - `Transform.translate` / `Transform.scale` are compositor-level (GPU)
   - `Container` width/height changes trigger layout (CPU)

3. **Use `shouldRepaint` in CustomPainter**
   ```dart
   @override
   bool shouldRepaint(covariant MyPainter oldDelegate) {
     return oldDelegate.value != value; // Only repaint if changed
   }
   ```

4. **Cache computations** in CustomPainter
   ```dart
   // BAD: Compute every frame
   paint() {
     final path = _computeComplexPath(); // Expensive!
     canvas.drawPath(path, paint);
   }

   // GOOD: Cache the path
   Path? _cachedPath;
   paint() {
     _cachedPath ??= _computeComplexPath();
     canvas.drawPath(_cachedPath!, paint);
   }
   ```

5. **Cap particle systems** at ~200 particles

### AnimationController Best Practices
- Use `TickerProviderStateMixin` for multiple controllers
- Dispose controllers in `dispose()`
- Use `Interval` for staggered animations (single controller)
- Prefer `Curves.easeOutCubic` for natural-feeling animations

### Memory Management
- Use `Lottie.asset` over `Lottie.network` when possible (cached)
- Dispose Rive controllers
- Use `const` constructors where possible

---

## 4. LOTTIE INTEGRATION PATTERNS

```dart
// Basic usage
Lottie.asset('assets/animations/success.json')

// With controller for precise control
class AnimatedCheckmark extends StatefulWidget {
  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Success checkmark animation',
      child: Lottie.asset(
        'assets/animations/checkmark.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward();
        },
        width: 150,
        height: 150,
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

### Performance Tips
- Download Lottie JSON to local assets (avoid network latency)
- Use `repeat: false` for one-shot animations
- Use `fit: BoxFit.contain` to avoid unnecessary scaling
- Pre-cache frequently used animations

---

## 5. RIVE INTEGRATION PATTERNS

```dart
// Basic usage
RiveAnimation.asset(
  'assets/animations/loader.riv',
  fit: BoxFit.cover,
)

// With state machine control
class InteractiveButton extends StatefulWidget {
  @override
  _InteractiveButtonState createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('idle');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Interactive button',
      button: true,
      child: GestureDetector(
        onTap: () {
          _controller.isActive = true;
          // Trigger state machine input
        },
        child: RiveAnimation.asset(
          'assets/animations/button.riv',
          controllers: [_controller],
        ),
      ),
    );
  }
}
```

### Rive vs Lottie
- **Rive**: Better for interactive/state-machine animations, smaller files
- **Lottie**: Better for complex illustrations, larger community assets

---

## 6. HAPTIC FEEDBACK PATTERNS

```dart
import 'package:flutter/services.dart';

// Light haptic (button tap)
HapticFeedback.lightImpact();

// Medium haptic (selection change)
HapticFeedback.mediumImpact();

// Heavy haptic (important action)
HapticFeedback.heavyImpact();

// Selection haptic (scroll snap)
HapticFeedback.selectionClick();

// Vibrate (notification)
HapticFeedback.vibrate();
```

### When to Use Each
| Action | Haptic Type |
|--------|-------------|
| Button tap | lightImpact |
| Toggle switch | mediumImpact |
| Mission complete | heavyImpact |
| Scroll snap | selectionClick |
| Error/warning | vibrate |
| Level up | heavyImpact + vibrate |

---

## 7. MATERIAL DESIGN MOTION GUIDELINES

### Easing Curves
- **Standard**: `Curves.easeInOut` — for most transitions
- **Decelerate**: `Curves.easeOut` — for elements entering screen
- **Accelerate**: `Curves.easeIn` — for elements leaving screen

### Duration Guidelines
- Micro-interactions: 100-200ms
- Page transitions: 300-500ms
- Complex animations: 500-1000ms
- Never exceed 1000ms for UI animations

### Shared Axis Transition (for navigation)
```dart
import 'package:animations/animations.dart';

PageTransitionSwitcher(
  transition: SharedAxisTransition(
    transitionType: SharedAxisTransitionType.horizontal,
    child: currentPage,
  ),
  child: currentPage,
)
```

### Fade Through Transition (for tab switching)
```dart
PageTransitionSwitcher(
  transition: FadeThroughTransition(
    child: currentTab,
  ),
  child: currentTab,
)
```

### Open Container (for FAB → detail)
```dart
OpenContainer(
  transitionType: ContainerTransitionType.fade,
  openBuilder: (context, closeContainer) => DetailPage(),
  closedBuilder: (context, openContainer) => FloatingActionButton(
    onPressed: openContainer,
    child: Icon(Icons.add),
  ),
)
```
