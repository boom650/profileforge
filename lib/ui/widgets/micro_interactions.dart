import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// HapticHelper – static convenience methods for haptic feedback
// ---------------------------------------------------------------------------
class HapticHelper {
  HapticHelper._();

  /// Light tap feedback – suitable for subtle interactions (e.g. card taps).
  static void light() => HapticFeedback.lightImpact();

  /// Medium tap feedback – suitable for button presses, toggles.
  static void medium() => HapticFeedback.mediumImpact();

  /// Heavy tap feedback – suitable for destructive actions, completions.
  static void heavy() => HapticFeedback.heavyImpact();

  /// Selection click – suitable for picker / dropdown selections.
  static void selection() => HapticFeedback.selectionClick();
}

// ---------------------------------------------------------------------------
// ReducedMotionWrapper – checks MediaQuery.disableAnimations and skips
// animations when the user has enabled "Reduce motion" in system settings.
// ---------------------------------------------------------------------------
class ReducedMotionWrapper extends StatelessWidget {
  final Widget child;
  final Widget? fallback;

  const ReducedMotionWrapper({
    super.key,
    required this.child,
    this.fallback,
  });

  /// Returns `true` when the platform reports reduced motion preference.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context);
  }

  @override
  Widget build(BuildContext context) {
    if (shouldReduceMotion(context)) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }
}

// ---------------------------------------------------------------------------
// TapScale – wraps any widget with a gentle 0.97 scale-down on press.
// ---------------------------------------------------------------------------
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.97,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.forward();
    HapticHelper.light();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduce = ReducedMotionWrapper.shouldReduceMotion(context);

    return GestureDetector(
      onTapDown: shouldReduce ? null : _onTapDown,
      onTapUp: shouldReduce ? null : _onTapUp,
      onTapCancel: shouldReduce ? null : _onTapCancel,
      onTap: widget.onTap,
      child: shouldReduce
          ? widget.child
          : AnimatedBuilder(
              animation: _scaleAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnim.value,
                  child: child,
                );
              },
              child: widget.child,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// CountingAnimation – smoothly counts from 0 (or a start value) to a target.
// Displays the current integer value via a builder, so the caller has full
// control over styling.
// ---------------------------------------------------------------------------
class CountingAnimation extends StatefulWidget {
  final int targetValue;
  final Duration duration;
  final Widget Function(BuildContext context, int currentValue) builder;
  final bool restartOnTargetChange;

  const CountingAnimation({
    super.key,
    required this.targetValue,
    required this.builder,
    this.duration = const Duration(milliseconds: 800),
    this.restartOnTargetChange = true,
  });

  @override
  State<CountingAnimation> createState() => _CountingAnimationState();
}

class _CountingAnimationState extends State<CountingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;
  int _previousTarget = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _anim = Tween<double>(
      begin: _previousTarget.toDouble(),
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CountingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue &&
        widget.restartOnTargetChange) {
      _previousTarget = _anim.value.toInt();
      _anim = Tween<double>(
        begin: _previousTarget.toDouble(),
        end: widget.targetValue.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduce = ReducedMotionWrapper.shouldReduceMotion(context);

    if (shouldReduce) {
      return widget.builder(context, widget.targetValue);
    }

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return widget.builder(context, _anim.value.round());
      },
    );
  }
}

// ---------------------------------------------------------------------------
// PulseAnimation – a breathing glow effect that repeatedly fades the
// opacity of a glow between 0.0 and [maxOpacity].
// ---------------------------------------------------------------------------
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final double maxOpacity;
  final Duration cycleDuration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF3B82F6),
    this.glowRadius = 16,
    this.maxOpacity = 0.35,
    this.cycleDuration = const Duration(milliseconds: 1800),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduce = ReducedMotionWrapper.shouldReduceMotion(context);

    if (shouldReduce) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withValues(alpha: widget.maxOpacity),
              blurRadius: widget.glowRadius,
            ),
          ],
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = _controller.value * widget.maxOpacity;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: opacity),
                blurRadius: widget.glowRadius,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// ConfettiBurst – a lightweight particle explosion rendered on a Canvas.
// Trigger it by passing `show = true`; it auto-dismisses after [duration].
// ---------------------------------------------------------------------------
class ConfettiBurst extends StatefulWidget {
  final bool show;
  final Duration duration;
  final int particleCount;

  const ConfettiBurst({
    super.key,
    this.show = false,
    this.duration = const Duration(milliseconds: 1200),
    this.particleCount = 30,
  });

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_ConfettiParticle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _generateParticles();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _generateParticles();
      _controller.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (_) {
      return _ConfettiParticle(
        angle: _random.nextDouble() * 2 * pi,
        speed: 80 + _random.nextDouble() * 160,
        color: _confettiColors[_random.nextInt(_confettiColors.length)],
        size: 3 + _random.nextDouble() * 5,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 8,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldReduce = ReducedMotionWrapper.shouldReduceMotion(context);

    if (shouldReduce) {
      return const SizedBox.shrink();
    }

    if (!widget.show && _controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            progress: _controller.value,
            particles: _particles,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Confetti internals
// ---------------------------------------------------------------------------

const _confettiColors = [
  Color(0xFFFFD700), // gold
  Color(0xFF3B82F6), // blue
  Color(0xFFEF4444), // red
  Color(0xFF10B981), // green
  Color(0xFFEC4899), // pink
  Color(0xFFF59E0B), // amber
  Color(0xFF8B5CF6), // purple
];

class _ConfettiParticle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotation;
  final double rotationSpeed;

  const _ConfettiParticle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.progress, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final elapsed = progress;
      final distance = p.speed * elapsed;
      final gravity = 200 * elapsed * elapsed;

      final dx = cos(p.angle) * distance;
      final dy = sin(p.angle) * distance + gravity;

      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final position = center + Offset(dx, dy);

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(p.rotation + p.rotationSpeed * elapsed);

      // Draw a small rectangle (confetti piece)
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
