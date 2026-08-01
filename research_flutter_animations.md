# Flutter Animation Patterns Research

## 1. Hero Widget — How It Works

Hero widget marks its child as a candidate for hero animations. When a `PageRoute` is pushed/popped, the `HeroController` identifies matching `Hero` widgets by `tag` and animates them "flying" through the Navigator's overlay.

### Core mechanics:
- Both routes must have `Hero` widgets with matching `tag` values
- Hero must exist on the **first frame** of the new page's animation
- No duplicate tags per route
- Heroes must be **axis-aligned** (no rotation)
- During flight, widget subtree is lifted into the Navigator's Overlay Stack

### Basic Hero List → Detail:

```dart
// List screen
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      leading: Hero(
        tag: 'avatar-${item.id}',
        child: CircleAvatar(backgroundImage: NetworkImage(item.avatar)),
      ),
      title: Text(item.name),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(item: item),
        ),
      ),
    );
  },
)

// Detail screen
class DetailScreen extends StatelessWidget {
  final Item item;
  const DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'avatar-${item.id}',
                child: Image.network(item.avatar, fit: BoxFit.cover),
              ),
            ),
          ),
          // ... rest of content
        ],
      ),
    );
  }
}
```

---

## 2. Custom Hero flightShuttleBuilder

Controls what widget is rendered during the flight animation. Solves issues with `InheritedWidget` discontinuity (Theme, MediaQuery changes between routes).

```dart
Hero(
  tag: 'product-${product.id}',
  flightShuttleBuilder: (
    flightContext,
    animation,
    direction,
    fromContext,
    toContext,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Custom interpolation during flight
        final opacity = animation.value;
        return Opacity(
          opacity: opacity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              lerpDouble(16, 0, animation.value)!,
            ),
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  },
  child: Image.network(product.imageUrl, fit: BoxFit.cover),
)
```

### Custom RectTween for shape morphing:

```dart
// Define a custom rect tween for curved flight paths
class ArchRectTween extends RectTween {
  final Rect? begin;
  final Rect? end;

  ArchRectTween({required this.begin, required this.end});

  @override
  Rect lerp(double t) {
    final curve = CurvedAnimation(
      parent: AlwaysStoppedAnimation(t),
      curve: Curves.easeInOut,
    );
    final midHeight = begin!.bottom + (begin!.top - begin!.bottom) * 0.3;
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, t)!,
      lerpDouble(begin!.top, end!.top, t)! - (40 * curve.value),
      lerpDouble(begin!.right, end!.right, t)!,
      lerpDouble(begin!.bottom, end!.bottom, t)!,
    );
  }
}

// Usage
Hero(
  tag: 'card-${item.id}',
  createRectTween: (begin, end) {
    return ArchRectTween(begin: begin, end: end);
  },
  child: MyCardWidget(item: item),
)
```

---

## 3. Shared Element Transitions — List ↔ Detail

Pattern for shared element transitions where Hero alone isn't enough (e.g., within-page transitions, or when you need more control):

```dart
// Approach: PageRouteBuilder with explicit shared element
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SharedAxisPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

// Usage
Navigator.push(
  context,
  SharedAxisPageRoute(page: DetailScreen(item: item)),
);
```

---

## 4. `animations` Package — Google Material Motion

**Package:** `animations` on pub.dev (by Google)

Provides Material motion transitions as drop-in widgets:

### Install:
```yaml
dependencies:
  animations: ^2.0.11
```

### Key exports:
- `OpenContainer` — FAB/container that opens into a full screen
- `SharedAxisTransition` — X/Y/Z axis shared element motion
- `FadeThroughTransition` — Material fade-through (for bottom nav switches)
- `FadeScaleTransition` — For dialogs, modals

### Import:
```dart
import 'package:animations/animations.dart';
```

---

## 5. OpenContainer Transition

A container that expands from a small widget into a full page. Replaces manual Hero + PageRouteBuilder.

```dart
// List screen with OpenContainer
OpenContainer(
  transitionType: ContainerTransitionType.fadeThrough,
  openBuilder: (context, closeContainer) {
    return DetailScreen(item: item);
  },
  closedBuilder: (context, openContainer) {
    return Card(
      child: Column(
        children: [
          Image.network(item.imageUrl, height: 150, fit: BoxFit.cover),
          Text(item.name),
        ],
      ),
    );
  },
  closedColor: Theme.of(context).cardColor,
  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  closedElevation: 4,
  openElevation: 0,
  tappable: true,
)
```

### OpenContainer with FAB:

```dart
// Bottom FAB that opens into compose screen
OpenContainer(
  transitionType: ContainerTransitionType.fadeThrough,
  openBuilder: (_, closeContainer) => ComposeScreen(onClose: closeContainer),
  closedBuilder: (_, openContainer) => FloatingActionButton(
    onPressed: openContainer,
    child: const Icon(Icons.add),
  ),
  closedShape: const CircleBorder(),
)
```

---

## 6. SharedAxisTransition

Material Design shared axis pattern. Used for transitions between UI elements that don't share a parent-child relationship.

### X-axis (horizontal navigation):
```dart
SharedAxisTransition(
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  transitionType: SharedAxisTransitionType.horizontal,
  child: currentPage,
)
```

### Y-axis (vertical, e.g., expanding content):
```dart
SharedAxisTransition(
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  transitionType: SharedAxisTransitionType.vertical,
  child: detailContent,
)
```

### Z-axis (for depth, e.g., tab switches):
```dart
SharedAxisTransition(
  animation: animation,
  secondaryAnimation: secondaryAnimation,
  transitionType: SharedAxisTransitionType.z,
  child: tabPage,
)
```

### Full PageRoute usage:
```dart
class SharedAxisPageRoute extends PageRouteBuilder {
  final Widget page;
  final SharedAxisTransitionType transitionType;

  SharedAxisPageRoute({
    required this.page,
    this.transitionType = SharedAxisTransitionType.horizontal,
  }) : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: __,
              transitionType: transitionType,
              child: child,
            );
          },
        );
}
```

---

## 7. FadeThroughTransition

Material fade-through pattern. When switching between top-level destinations (bottom nav), the outgoing content fades out then incoming fades in with slight upward slide. Used in Google apps, Duolingo.

```dart
// In a PageRouteBuilder
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  return FadeThroughTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
},
```

### Bottom Navigation with FadeThrough:
```dart
// When switching tabs
PageView(
  controller: _pageController,
  children: [
    // Each tab wrapped in FadeThrough for smooth tab switches
    _buildTab(0, _currentIndex),
    _buildTab(1, _currentIndex),
    _buildTab(2, _currentIndex),
  ],
)

// Better approach: AnimatedSwitcher with FadeThrough
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: _tabs[_currentIndex],
  transitionBuilder: (child, animation) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: const AlwaysStoppedAnimation(0.0),
      child: child,
    );
  },
)
```

---

## 8. Duolingo / Linear Shared Element Patterns

### Duolingo patterns:
- **Lesson cards** fly open using Hero-like transitions with custom curves
- **Streak animations** use `AnimationController` with custom `CurvedAnimation`
- **Progress rings** animate using `AnimationController` with `CurvedAnimation(parent: controller, curve: Curves.easeOut)`
- Uses `AnimatedBuilder` heavily for performance (not setState)
- Tab switches use fade-through style transitions

### Linear patterns:
- **Issue cards** expand into detail views with shared element transitions
- Uses `SharedAxisTransition` (z-axis) for project/issue list → detail
- `OpenContainer` for quick-create panels
- Sidebar transitions use horizontal shared axis
- Smooth scroll-linked animations with `ScrollController` + `AnimationController`

### Key insight from both:
- Use `Hero` for the **primary** visual element (avatar, thumbnail)
- Use `SharedAxisTransition` or `FadeThroughTransition` for the **surrounding** content
- Custom `flightShuttleBuilder` for handling size mismatches between list and detail

---

## 9. Hero Animation Best Practices

### Avoiding jumps:
```dart
// BAD: Different widget trees cause visual discontinuity
// List: Hero(child: Image.network(url))
// Detail: Hero(child: CachedNetworkImage(url)) // Different widget!

// GOOD: Same widget tree structure in both locations
Hero(
  tag: 'image-$id',
  child: Image.network(url, fit: BoxFit.cover), // Same in both
)
```

### Handling different sizes:
```dart
Hero(
  tag: 'avatar-$id',
  // Ensure both heroes use the same box fit
  child: SizedBox(
    width: 48,  // Same size at both locations
    height: 48,
    child: ClipOval(
      child: Image.network(url, fit: BoxFit.cover),
    ),
  ),
)
```

### Placeholder during flight:
```dart
Hero(
  tag: 'image-$id',
  placeholderBuilder: (heroSize, child) {
    return Container(
      width: heroSize.width,
      height: heroSize.height,
      color: Colors.grey[200], // Placeholder while image is in flight
    );
  },
  child: Image.network(url, fit: BoxFit.cover),
)
```

### Avoiding flicker on rapid navigation:
```dart
// Ensure Hero tags are unique and stable across rebuilds
Hero(
  key: ValueKey('hero-${item.id}'), // Stable key
  tag: 'hero-${item.id}',           // Unique, stable tag
  child: ...
)
```

---

## 10. AnimationController Deep Patterns

### Basic setup:
```dart
class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // CRITICAL: prevent leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.scale(
            scale: _animation.value,
            child: child,
          ),
        );
      },
      child: const Text('Animated'), // Static child — avoids rebuild
    );
  }
}
```

### Multiple AnimationControllers:
```dart
class _ComplexAnimationState extends State<ComplexAnimation>
    with TickerProviderStateMixin {  // NOT SingleTicker!

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    // Each controller independent
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _animateAll() {
    // Parallel
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();

    // Or sequential
    _fadeController.forward().then((_) {
      _slideController.forward();
    }).then((_) {
      _scaleController.forward();
    });
  }
}
```

### Custom Curves:
```dart
// Built-in curves
CurvedAnimation(parent: controller, curve: Curves.easeInOut);
CurvedAnimation(parent: controller, curve: Curves.elasticOut);
CurvedAnimation(parent: controller, curve: Curves.bounceInOut);

// Custom curve class
class SteppedCurve extends Curve {
  final int steps;

  SteppedCurve(this.steps);

  @override
  double transformInternal(double t) {
    return (t * steps).floor() / steps;
  }
}

// Usage
AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1000),
  // Custom bounds
  lowerBound: 0.0,
  upperBound: 1.0,
);

CurvedAnimation(
  parent: controller,
  curve: const Interval(0.2, 0.8, curve: Curves.easeOut), // Partial range
)
```

### Chaining with CurvedAnimation:
```dart
// Staggered animation using Intervals
class _StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _scaleUp;
  late Animation<double> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Each animation occupies a portion of the total duration
    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _slideUp = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    );

    _scaleUp = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
    );

    _textSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: Transform.translate(
            offset: Offset(0, 100 * (1 - _slideUp.value)),
            child: Transform.scale(
              scale: _scaleUp.value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - _textSlide.value)),
                child: const Text('Staggered!'),
              ),
            ),
          ),
        );
      },
    );
  }

  void startAnimation() => _controller.forward();
}
```

### forward() with vsync:
```dart
// vsync ties animation to screen refresh rate
// SingleTickerProviderStateMixin: one controller
class _MyState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,  // Uses this State as TickerProvider
      duration: const Duration(seconds: 1),
    );
  }
}

// TickerProviderStateMixin: multiple controllers
class _MyState extends State<MyWidget> with TickerProviderStateMixin {
  // Can create multiple AnimationControllers
}

// forward() starts animation from lowerBound to upperBound
_controller.forward();  // 0.0 → 1.0
_controller.forward(from: 0.5);  // Start from midpoint
_controller.reverse();  // 1.0 → 0.0
_controller.repeat();  // Loop forever
_controller.repeat(reverse: true);  // Ping-pong
_controller.stop();  // Halt at current value
_controller.reset();  // Jump to lowerBound
```

### Performance: AnimatedBuilder vs setState:

```dart
// BAD: setState rebuilds entire widget tree
class _BadWidgetState extends State<BadWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {}); // Rebuilds EVERYTHING every frame
      });
  }
}

// GOOD: AnimatedBuilder rebuilds only its builder
class _GoodWidgetState extends State<GoodWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Only this subtree rebuilds
        return Opacity(
          opacity: _controller.value,
          child: child,  // Pass static content as child
        );
      },
      child: const ExpensiveChild(), // Built once, reused
    );
  }
}

// BEST: AnimatedWidget (no builder boilerplate)
class FadeInWidget extends AnimatedWidget {
  final Widget child;

  const FadeInWidget({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.value,
      child: child,
    );
  }
}
```

### Performance tips for multiple AnimationControllers:
```dart
// 1. Use TickerProviderStateMixin (not multiple SingleTickerProviderStateMixin)
// Wrong:
// class _State extends State<W> with SingleTickerProviderStateMixin { ... }

// 2. Dispose ALL controllers
@override
void dispose() {
  _controller1.dispose();
  _controller2.dispose();
  _controller3.dispose();
  super.dispose();
}

// 3. Use vsync — controllers without vsync waste battery
_controller = AnimationController(vsync: this, duration: ...);

// 4. Stop controllers when not visible
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final route = ModalRoute.of(context);
  if (route != null) {
    if (route.isCurrent) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }
}

// 5. Consider AnimationController.drive() for composition
final animation = _controller.drive(
  Tween<double>(begin: 0, end: 1).chain(
    CurveTween(curve: Curves.easeOut),
  ),
);
```

---

## 11. Combined Pattern: Hero + Custom AnimationController

```dart
// Hero with custom transition using AnimationController
class AnimatedHeroDetail extends StatefulWidget {
  final Item item;
  const AnimatedHeroDetail({required this.item});

  @override
  State<AnimatedHeroDetail> createState() => _AnimatedHeroDetailState();
}

class _AnimatedHeroDetailState extends State<AnimatedHeroDetail>
    with SingleTickerProviderStateMixin {

  late AnimationController _expandController;
  late Animation<double> _contentReveal;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _contentReveal = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );
    // Delay content reveal slightly for Hero to finish
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _expandController.forward();
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image-${widget.item.id}',
                child: Image.network(widget.item.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentReveal,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentReveal.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _contentReveal.value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(widget.item.description),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Summary of Key Packages & APIs

| What | Where |
|------|-------|
| Hero widget | `package:flutter/widgets.dart` |
| Hero.createRectTween | Custom flight path shapes |
| Hero.flightShuttleBuilder | Custom in-flight widget |
| Hero.placeholderBuilder | Placeholder behind flying hero |
| AnimationController | `package:flutter/animation.dart` |
| CurvedAnimation | Custom curve application |
| Interval | Staggered/chained animations |
| AnimatedBuilder | Efficient rebuild scoping |
| `animations` package | `package:animations/animations.dart` |
| OpenContainer | Container → full page transition |
| SharedAxisTransition | Material shared axis motion |
| FadeThroughTransition | Material fade-through (tab switches) |
| FadeScaleTransition | Dialog/modal transitions |
