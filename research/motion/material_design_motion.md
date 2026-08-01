# Material Design Motion System Research

## Duration Tokens

Material Design 3 defines four duration tiers:

| Token | Duration | Use Case |
|-------|----------|----------|
| `short1` | 50ms | Micro-interactions: checkbox toggle, icon rotation |
| `short2` | 100ms | Button press feedback, small element appear |
| `short3` | 150ms | Standard element transitions, chip select |
| `short4` | 200ms | Modal enter, tooltip appear |
| `medium1` | 250ms | Card expand, list item reorder |
| `medium2` | 300ms | Page transitions, bottom sheet rise |
| `medium3` | 350ms | Complex layout animations |
| `medium4` | 400ms | Full panel slide |
| `long1` | 450ms | Navigation rail expand |
| `long2` | 500ms | Large surface transform |
| `long3` | 550ms | Multi-element choreography |
| `long4` | 600ms | Hero transition with morphing |
| `extraLong1` | 700ms | Container transform (full) |
| `extraLong2` | 800ms | Multi-step page transition |
| `extraLong3` | 900ms | Storytelling entrance |
| `extraLong4` | 1000ms | Cinematic reveal (rare) |

**Flutter equivalent:**
```dart
const Duration short1 = Duration(milliseconds: 50);
const Duration short2 = Duration(milliseconds: 100);
const Duration short3 = Duration(milliseconds: 150);
const Duration short4 = Duration(milliseconds: 200);
const Duration medium1 = Duration(milliseconds: 250);
const Duration medium2 = Duration(milliseconds: 300);
const Duration medium3 = Duration(milliseconds: 350);
const Duration medium4 = Duration(milliseconds: 400);
const Duration long1 = Duration(milliseconds: 450);
const Duration long2 = Duration(milliseconds: 500);
const Duration long3 = Duration(milliseconds: 550);
const Duration long4 = Duration(milliseconds: 600);
const Duration extraLong1 = Duration(milliseconds: 700);
const Duration extraLong2 = Duration(milliseconds: 800);
const Duration extraLong3 = Duration(milliseconds: 900);
const Duration extraLong4 = Duration(milliseconds: 1000);
```

---

## Easing Curves

### Emphasized (Default)
The standard M3 easing curve. Accelerates then decelerates.
```
cubic-bezier(0.2, 0.0, 0, 1.0)
```
Flutter: `Curves.easeInOutCubicEmphasized` (Flutter 3.16+)

### Emphasized Decelerate
For elements entering the screen. Starts fast, ends slow.
```
cubic-bezier(0.05, 0.7, 0.1, 1.0)
```
Flutter: `Curves.easeOutCubic`

### Emphasized Accelerate
For elements exiting the screen. Starts slow, ends fast.
```
cubic-bezier(0.3, 0.0, 0.8, 0.15)
```
Flutter: `Curves.easeInCubic`

### Standard
For subtle, non-directional transitions.
```
cubic-bezier(0.2, 0.0, 0, 1.0)
```

### Standard Decelerate
Gentle enter.
```
cubic-bezier(0, 0, 0, 1)
```

### Standard Accelerate
Gentle exit.
```
cubic-bezier(0.3, 0, 1, 1)
```

**Flutter easing constants:**
```dart
// Material Design 3 easing curves in Flutter
const Curve emphasized = Curves.easeInOutCubicEmphasized;
const Curve emphasizedDecelerate = Curves.easeOutCubic;
const Curve emphasizedAccelerate = Curves.easeInCubic;
const Curve standard = Curves.easeInOut;
const Curve standardDecelerate = Curves.easeOut;
const Curve standardAccelerate = Curves.easeIn;
```

---

## Shared Axis Transition

Used for navigation between views that have a spatial/hierarchical relationship.

**Horizontal** (left-right): Views at same hierarchical level
**Vertical** (top-bottom): Views at different hierarchical levels
**Depth** (z-axis): Views with content hierarchy (folder → file)

### Flutter Implementation
```dart
import 'package:animations/animations.dart';

// Horizontal shared axis
SharedAxisTransition(
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  transitionType: SharedAxisTransitionType.horizontal,
  child: currentScreen,
)

// Full page route with shared axis
Route<dynamic> generateRoute(RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _buildPage(settings.name!);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}
```

### When to use
- Tab navigation between related content
- Multi-step forms
- Hierarchical navigation (settings → subsetting)

---

## Container Transform

A view morphs from a small element (card, button) into a large surface (detail page), maintaining spatial continuity.

### Flutter Implementation
```dart
import 'package:animations/animations.dart';

// OpenContainer wraps any widget
OpenContainer(
  transitionDuration: const Duration(milliseconds: 500),
  closedBuilder: (context, openContainer) {
    return Card(
      child: InkWell(
        onTap: openContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Hero(tag: 'item-$id', child: Image.network(url)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  },
  openBuilder: (context, closeContainer) {
    return DetailScreen(item: item, onClose: closeContainer);
  },
  // Optional: control closed/open shape
  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  openShape: const RoundedRectangleBorder(),
  closedElevation: 4,
  openElevation: 0,
  // Optional: tint overlay on closed state
  closedColor: Colors.white,
  openColor: Colors.white,
  tappable: true,
)
```

### Flutter Hero-based alternative (manual)
```dart
// Source (card)
Hero(
  tag: 'avatar-$id',
  child: CircleAvatar(backgroundImage: NetworkImage(url)),
)

// Destination (detail page)
Hero(
  tag: 'avatar-$id',
  child: CircleAvatar(
    radius: 60,
    backgroundImage: NetworkImage(url),
  ),
)
```

### When to use
- Card → detail screen
- FAB → create form
- Thumbnail → full image
- List item → detail view

---

## Fade-Through

Elements that have no direct relationship. Old element fades out, new fades in with slight upward motion. No shared element.

### Flutter Implementation
```dart
import 'package:animations/animations.dart';

FadeThroughTransition(
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  child: currentScreen,
)

// As page route transition
PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeThroughPageTransitionsBuilder(),
  },
)
```

### When to use
- Bottom navigation bar switches (no shared content)
- Disconnected screens in a flow
- Settings categories switching

---

## Transition Pattern Selection Guide

| Relationship | Pattern | Example |
|-------------|---------|---------|
| Same level, related | Shared Axis | Tab navigation, step wizard |
| Small → large | Container Transform | Card → detail, FAB → form |
| Unrelated | Fade Through | Bottom nav switches |
| Single element | Simple Fade/Slide | Dialog, snackbar, tooltip |

---

## Flutter `animations` Package

```yaml
dependencies:
  animations: ^2.0.11
```

Provides M3-ready transitions:
- `SharedAxisTransition`
- `FadeThroughTransition`
- `FadeScaleTransition`
- `OpenContainer`

Also provides Material motion page route builders:
- `FadeThroughPageTransitionsBuilder`
- `SharedAxisPageTransitionsBuilder`
- `FadeScalePageTransitionsBuilder`

---

## M3 Motion in Practice

### Principle: Motion communicates relationships
- **Spatial relationship** → Shared Axis (horizontal = peers, vertical = hierarchy)
- **Content continuity** → Container Transform
- **No relationship** → Fade Through

### Principle: Duration matches distance/complexity
- Small change, short distance → 150-200ms
- Medium change → 250-350ms
- Large change, morphing → 500-700ms
- Never exceed 1000ms for any single transition

### Principle: Easing implies direction
- Enter from offscreen → decelerate (starts fast)
- Exit to offscreen → accelerate (ends fast)
- Transform in place → emphasized (symmetric)
