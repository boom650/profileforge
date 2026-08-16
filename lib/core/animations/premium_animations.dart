import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Premium Animations — Duolingo-level micro-interactions.
/// Spring physics, haptics, staggered reveals, celebration bursts.
/// ────────────────────────────────────────────────────────────────────────────

/// Haptic feedback on every interaction.
class Haptics {
  Haptics._();

  /// Light tap — button press, toggle.
  static void light() => HapticFeedback.lightImpact();

  /// Medium — completion, selection.
  static void medium() => HapticFeedback.mediumImpact();

  /// Heavy — level up, major event.
  static void heavy() => HapticFeedback.heavyImpact();

  /// Selection changed.
  static void selection() => HapticFeedback.selectionClick();

  /// Success — mission complete.
  static void success() {
    HapticFeedback.mediumImpact();
    Future.delayed(80.ms, () => HapticFeedback.lightImpact());
  }

  /// Double tap — level up.
  static void levelUp() {
    HapticFeedback.heavyImpact();
    Future.delayed(100.ms, () => HapticFeedback.mediumImpact());
    Future.delayed(200.ms, () => HapticFeedback.heavyImpact());
  }

  /// Celebration burst.
  static void celebration() {
    HapticFeedback.heavyImpact();
    Future.delayed(60.ms, () => HapticFeedback.mediumImpact());
    Future.delayed(120.ms, () => HapticFeedback.lightImpact());
    Future.delayed(180.ms, () => HapticFeedback.mediumImpact());
    Future.delayed(240.ms, () => HapticFeedback.heavyImpact());
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Extension on Widget for Duolingo-style animations.
/// ────────────────────────────────────────────────────────────────────────────
extension WidgetAnimationX on Widget {
  /// Staggered fade-in + slide-up (like Duolingo lesson items).
  Widget animateIn({int delayMs = 0, Duration? duration}) {
    return animate()
        .fadeIn(
          delay: Duration(milliseconds: delayMs),
          duration: duration ?? 400.ms,
          curve: Curves.easeOutCubic,
        )
        .slideY(
          begin: 0.08,
          end: 0,
          delay: Duration(milliseconds: delayMs),
          duration: duration ?? 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// Bounce-in (like Duolingo correct answer).
  Widget bounceIn({int delayMs = 0}) {
    return animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          delay: Duration(milliseconds: delayMs),
          duration: 500.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(
          delay: Duration(milliseconds: delayMs),
          duration: 300.ms,
        );
  }

  /// Slide from right (page transition feel).
  Widget slideInRight({int delayMs = 0}) {
    return animate()
        .fadeIn(
          delay: Duration(milliseconds: delayMs),
          duration: 350.ms,
          curve: Curves.easeOutCubic,
        )
        .slideX(
          begin: 0.15,
          end: 0,
          delay: Duration(milliseconds: delayMs),
          duration: 350.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// Pulse (attention grabber).
  Widget pulse({int delayMs = 0}) {
    return animate()
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          delay: Duration(milliseconds: delayMs),
          duration: 600.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeInOut,
        );
  }

  /// Shake (error feedback).
  Widget shake({int delayMs = 0}) {
    return animate()
        .shimmer(
          delay: Duration(milliseconds: delayMs),
          duration: 600.ms,
        );
  }

  /// Scale on tap (interactive feedback).
  Widget scaleOnTap({double scale = 0.95}) {
    return _ScaleOnTapWrapper(scale: scale, child: this);
  }
}

/// ScaleOnTap wrapper — scales down on press, back up on release.
class _ScaleOnTapWrapper extends StatefulWidget {
  const _ScaleOnTapWrapper({required this.child, this.scale = 0.95});
  final Widget child;
  final double scale;

  @override
  State<_ScaleOnTapWrapper> createState() => _ScaleOnTapWrapperState();
}

class _ScaleOnTapWrapperState extends State<_ScaleOnTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 100.ms,
    );
    _animation = Tween<double>(begin: 1, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        Haptics.light();
        _controller.forward();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(
          scale: _animation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Staggered list animation — animate children one by one.
/// ────────────────────────────────────────────────────────────────────────────
class StaggeredReveal extends StatelessWidget {
  const StaggeredReveal({
    super.key,
    required this.children,
    this.delayMs = 50,
    this.durationMs = 400,
    this.offset = 0.06,
  });

  final List<Widget> children;
  final int delayMs;
  final int durationMs;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        return entry.value
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: entry.key * delayMs),
              duration: Duration(milliseconds: durationMs),
              curve: Curves.easeOutCubic,
            )
            .slideY(
              begin: offset,
              end: 0,
              delay: Duration(milliseconds: entry.key * delayMs),
              duration: Duration(milliseconds: durationMs),
              curve: Curves.easeOutCubic,
            );
      }).toList(),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Confetti celebration — particle burst for milestones.
/// ────────────────────────────────────────────────────────────────────────────
class ConfettiCelebration extends StatefulWidget {
  const ConfettiCelebration({
    super.key,
    this.colors = const [
      Color(0xFF4C9BD6),
      Color(0xFF8B7CD8),
      Color(0xFFE8719E),
      Color(0xFFF2A03D),
      Color(0xFF4FA36B),
    ],
    this.particleCount = 40,
    this.duration = const Duration(milliseconds: 1500),
  });

  final List<Color> colors;
  final int particleCount;
  final Duration duration;

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _generateParticles();
    _controller.forward();
  }

  void _generateParticles() {
    final rng = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        color: widget.colors[i % widget.colors.length],
        x: (rng + i * 7) % 100 / 100,
        speed: 0.5 + (rng + i * 13) % 100 / 200,
        angle: -0.5 + (rng + i * 17) % 100 / 100,
        size: 4 + (rng + i * 23) % 8,
      ));
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
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.color,
    required this.x,
    required this.speed,
    required this.angle,
    required this.size,
  });
  final Color color;
  final double x;
  final double speed;
  final double angle;
  final double size;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});
  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color.withValues(alpha: 1 - progress);
      final y = progress * size.height * p.speed;
      final x = p.x * size.width + progress * p.angle * size.width * 0.5;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
