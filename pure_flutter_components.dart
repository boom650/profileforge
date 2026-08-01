// ============================================================================
// Pure Flutter UI Components — Zero External Packages
// Flutter 3.x compatible | All animations use built-in APIs
// ============================================================================

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================
// 1. ANIMATED GRADIENT TEXT — ShaderMask + LinearGradient
// =============================================================================
class AnimatedGradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientText({
    super.key,
    required this.text,
    this.style,
    this.colors = const [Colors.purple, Colors.blue, Colors.cyan, Colors.purple],
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment(
                -1.0 + 2.0 * _controller.value,
                1.0,
              ),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style ??
                const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Required — ShaderMask masks this
                ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 2. TYPEWRITER TEXT EFFECT — AnimatedBuilder + substring
// =============================================================================
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDuration;
  final Duration pauseDuration;
  final bool loop;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDuration = const Duration(milliseconds: 80),
    this.pauseDuration = const Duration(seconds: 2),
    this.loop = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final totalDuration =
        widget.charDuration * widget.text.length + widget.pauseDuration;
    _controller = AnimationController(vsync: this, duration: totalDuration);
    if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final totalChars = widget.text.length;
        final charPhase =
            1.0 - (widget.pauseDuration.inMilliseconds /
                (_controller.duration?.inMilliseconds ?? 1));
        final visibleChars =
            (_controller.value / charPhase * totalChars)
                .clamp(0, totalChars)
                .toInt();
        final showCursor =
            visibleChars < totalChars && (_controller.value * 100).toInt() % 2 == 0;
        return Text.rich(
          TextSpan(
            text: widget.text.substring(0, visibleChars),
            style: widget.style ?? const TextStyle(fontSize: 24),
            children: [
              if (showCursor)
                const TextSpan(
                  text: '|',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// 3. GLASSMORPHISM CARD — BackdropFilter + ClipRRect
// =============================================================================
class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color borderColor;
  final BorderRadius borderRadius;
  final double borderWidth;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.borderColor = Colors.white30,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: borderWidth),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity),
                Colors.white.withOpacity(opacity * 0.5),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Usage example with background:
// Stack(
//   children: [
//     // colorful background required for blur effect
//     Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
//       ),
//     ),
//     Center(
//       child: GlassmorphismCard(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Text('Glass Card', style: TextStyle(color: Colors.white)),
//         ),
//       ),
//     ),
//   ],
// )

// =============================================================================
// 4. SHIMMER LOADING EFFECT — LinearGradient animation
// =============================================================================
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
  });

  static Widget fromBox({
    required double width,
    required double height,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return ShimmerEffect(
      baseColor: baseColor ?? const Color(0xFFE0E0E0),
      highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// =============================================================================
// 5. STAGGERED LIST ANIMATION — AnimationController + delay
// =============================================================================
class StaggeredListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final AnimationController controller;
  final Duration slideDuration;
  final Duration fadeDuration;
  final double slideOffset;

  const StaggeredListItem({
    super.key,
    required this.child,
    required this.index,
    required this.controller,
    this.slideDuration = const Duration(milliseconds: 500),
    this.fadeDuration = const Duration(milliseconds: 300),
    this.slideOffset = 50.0,
  });

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem> {
  late final Interval _slideInterval;
  late final Interval _fadeInterval;

  @override
  void initState() {
    super.initState();
    final itemCount = 20; // max visible items
    final step = 1.0 / itemCount;
    final start = (widget.index * step * 0.5).clamp(0.0, 1.0);
    _slideInterval = Interval(start, (start + 0.5).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic);
    _fadeInterval = Interval(start, (start + 0.3).clamp(0.0, 1.0),
        curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final slideAnim = _slideInterval.transform(widget.controller.value);
    final fadeAnim = _fadeInterval.transform(widget.controller.value);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnim,
          child: Transform.translate(
            offset: Offset(0, widget.slideOffset * (1 - slideAnim)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Demo wrapper that drives the stagger
class StaggeredListView extends StatefulWidget {
  final List<Widget> items;

  const StaggeredListView({super.key, required this.items});

  @override
  State<StaggeredListView> createState() => _StaggeredListViewState();
}

class _StaggeredListViewState extends State<StaggeredListView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return StaggeredListItem(
          index: index,
          controller: _controller,
          child: widget.items[index],
        );
      },
    );
  }
}

// =============================================================================
// 6. CIRCULAR PROGRESS RING — CustomPainter + animation
// =============================================================================
class CircularProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final double size;
  final Widget? child;
  final Duration duration;
  final bool animate;

  const CircularProgressRing({
    super.key,
    required this.progress,
    this.strokeWidth = 8.0,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.blue,
    this.size = 100.0,
    this.child,
    this.duration = const Duration(milliseconds: 800),
    this.animate = true,
  });

  @override
  State<CircularProgressRing> createState() => _CircularProgressRingState();
}

class _CircularProgressRingState extends State<CircularProgressRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _anim;
  double _prevProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CircularProgressRing old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _controller.reset();
      _anim = Tween<double>(begin: _prevProgress, end: widget.progress)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          );
      _prevProgress = widget.progress;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: _anim.value,
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.backgroundColor,
              progressColor: widget.progressColor,
            ),
            child: Center(child: widget.child),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // start at 12 o'clock
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// =============================================================================
// 7. FLOATING PARTICLE BACKGROUND — CustomPainter + Ticker
// =============================================================================
class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color color;
  final double minSize;
  final double maxSize;
  final double speed;
  final Widget child;

  const ParticleBackground({
    super.key,
    this.particleCount = 50,
    this.color = Colors.white,
    this.minSize = 2.0,
    this.maxSize = 6.0,
    this.speed = 0.5,
    this.child = const SizedBox.expand(),
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, _createParticle);
    _controller = AnimationController(vsync: this, duration: const Duration(hours: 1))
      ..addListener(_tick)
      ..repeat();
  }

  _Particle _createParticle(int _) {
    return _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      size: widget.minSize + _rng.nextDouble() * (widget.maxSize - widget.minSize),
      speedX: (_rng.nextDouble() - 0.5) * widget.speed * 0.002,
      speedY: -_rng.nextDouble() * widget.speed * 0.001,
      opacity: 0.3 + _rng.nextDouble() * 0.7,
    );
  }

  void _tick() {
    for (final p in _particles) {
      p.x += p.speedX;
      p.y += p.speedY;
      if (p.y < -0.05) {
        p.y = 1.05;
        p.x = _rng.nextDouble();
      }
      if (p.x < -0.05) p.x = 1.05;
      if (p.x > 1.05) p.x = -0.05;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _ParticlePainter(
              particles: _particles,
              color: widget.color,
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x, y, size, speedX, speedY, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;

  _ParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final p in particles) {
      paint.color = color.withOpacity(p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true; // always repaint
}

// =============================================================================
// 8. ANIMATED NUMBER COUNTER — Tween<double> + formatter
// =============================================================================
class AnimatedCounter extends StatefulWidget {
  final double target;
  final Duration duration;
  final TextStyle? style;
  final int decimals;
  final String prefix;
  final String suffix;
  final Curve curve;
  final String Function(double)? formatter;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1500),
    this.style,
    this.decimals = 0,
    this.prefix = '',
    this.suffix = '',
    this.curve = Curves.easeOutCubic,
    this.formatter,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.target).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.target != widget.target) {
      final current = _anim.value;
      _controller.reset();
      _anim = Tween<double>(begin: current, end: widget.target).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(double value) {
    if (widget.formatter != null) return widget.formatter!(value);
    return value.toStringAsFixed(widget.decimals);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Text(
          '${widget.prefix}${_format(_anim.value)}${widget.suffix}',
          style: widget.style ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

// =============================================================================
// 9. SMOOTH PAGE TRANSITIONS — PageRouteBuilder
// =============================================================================
class PageTransitions {
  /// Slide up from bottom (iOS-like)
  static Route<T> slideUp<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Fade + scale (Google-style)
  static Route<T> fadeScale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );
        final scaleAnim = Tween(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            child: child,
          ),
        );
      },
    );
  }

  /// Slide right (Material-style)
  static Route<T> slideRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );
        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis (Y axis, Figma-like)
  static Route<T> sharedAxisVertical<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final beginOffset = Offset(0, 0.08);
        final tween = Tween(begin: beginOffset, end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        final fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: fadeAnim, child: child),
        );
      },
    );
  }

  /// Rotate + fade (3D-like)
  static Route<T> rotateFade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnim = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final rotateAnim = Tween(begin: 0.9, end: 1.0).animate(fadeAnim);
        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: rotateAnim,
            child: child,
          ),
        );
      },
    );
  }
}

// Usage:
// Navigator.push(context, PageTransitions.slideUp(MyPage()));

// =============================================================================
// 10. HAPTIC FEEDBACK INTEGRATION — HapticFeedback class
// =============================================================================
class HapticFeedbackHelper {
  /// Light tap — UI acknowledgment (button press, toggle)
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium tap — selection change, item reorder
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy tap — critical action (delete, confirm)
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click — picker change, segmented control
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Error/vibrate — invalid input, error state
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }
}

/// Wraps a widget with haptic feedback on tap
class HapticTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final HapticType hapticType;

  const HapticTap({
    super.key,
    required this.child,
    this.onTap,
    this.hapticType = HapticType.light,
  });

  @override
  State<HapticTap> createState() => _HapticTapState();
}

enum HapticType { light, medium, heavy, selection, vibrate }

class _HapticTapState extends State<HapticTap> {
  Future<void> _trigger() async {
    switch (widget.hapticType) {
      case HapticType.light:
        await HapticFeedbackHelper.lightImpact();
      case HapticType.medium:
        await HapticFeedbackHelper.mediumImpact();
      case HapticType.heavy:
        await HapticFeedbackHelper.heavyImpact();
      case HapticType.selection:
        await HapticFeedbackHelper.selectionClick();
      case HapticType.vibrate:
        await HapticFeedbackHelper.vibrate();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _trigger,
      child: widget.child,
    );
  }
}

// Usage:
// HapticTap(
//   hapticType: HapticType.medium,
//   onTap: () => print('pressed'),
//   child: ElevatedButton(onPressed: null, child: Text('Tap')),
// )

// =============================================================================
// BONUS: Glassmorphism demo card combining multiple components
// =============================================================================
class DemoDashboard extends StatelessWidget {
  const DemoDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
              ),
            ),
          ),
          // Particles
          ParticleBackground(
            particleCount: 40,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Gradient title
                  const AnimatedGradientText(
                    text: 'Dashboard',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  // Glass card with counter
                  GlassmorphismCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('Total Users',
                              style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 8),
                          const AnimatedCounter(
                            target: 12847,
                            decimals: 0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          CircularProgressRing(
                            progress: 0.73,
                            size: 80,
                            strokeWidth: 8,
                            progressColor: Colors.cyan,
                            child: const Text('73%',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Shimmer placeholder
                  GlassmorphismCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recent Activity',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          ShimmerEffect(
                            baseColor: Colors.white12,
                            highlightColor: Colors.white24,
                            child: Column(
                              children: [
                                Container(
                                    height: 14, width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(7))),
                                const SizedBox(height: 8),
                                Container(
                                    height: 14, width: 200,
                                    decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(7))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
