import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ParticleSystem — Reusable particle effects for premium animations.
/// Supports confetti, sparkles, ambient floating, and celebration bursts.
/// ────────────────────────────────────────────────────────────────────────────
class ParticleSystem extends StatefulWidget {
  final ParticleType type;
  final int count;
  final Duration duration;
  final List<Color>? colors;
  final bool repeat;
  final VoidCallback? onComplete;

  const ParticleSystem({
    super.key,
    required this.type,
    this.count = 30,
    this.duration = const Duration(seconds: 2),
    this.colors,
    this.repeat = false,
    this.onComplete,
  });

  /// Confetti burst for celebrations
  factory ParticleSystem.confetti({
    Key? key,
    int count = 30,
    Duration duration = const Duration(seconds: 3),
    List<Color>? colors,
    bool repeat = false,
  }) {
    return ParticleSystem(
      key: key,
      type: ParticleType.confetti,
      count: count,
      duration: duration,
      colors: colors ??
          const [
            Color(0xFF6366F1), // Indigo
            Color(0xFF10B981), // Green
            Color(0xFFF59E0B), // Amber
            Color(0xFFEF4444), // Red
            Color(0xFF8B5CF6), // Purple
            Color(0xFFEC4899), // Pink
          ],
      repeat: repeat,
    );
  }

  /// Sparkle effect for achievements
  factory ParticleSystem.sparkles({
    Key? key,
    int count = 20,
    Duration duration = const Duration(seconds: 2),
    bool repeat = false,
  }) {
    return ParticleSystem(
      key: key,
      type: ParticleType.sparkle,
      count: count,
      duration: duration,
      colors: const [
        Color(0xFFFFD700), // Gold
        Color(0xFFFFFFFF), // White
        Color(0xFFF59E0B), // Amber
      ],
      repeat: repeat,
    );
  }

  /// Ambient floating particles for backgrounds
  factory ParticleSystem.ambient({
    Key? key,
    int count = 15,
    Duration duration = const Duration(seconds: 8),
  }) {
    return ParticleSystem(
      key: key,
      type: ParticleType.ambient,
      count: count,
      duration: duration,
      colors: const [
        Color(0xFF6366F1),
        Color(0xFF8B5CF6),
      ],
      repeat: true,
    );
  }

  /// Celebration burst (full screen overlay)
  factory ParticleSystem.celebration({
    Key? key,
    int count = 50,
    Duration duration = const Duration(seconds: 3),
  }) {
    return ParticleSystem(
      key: key,
      type: ParticleType.confetti,
      count: count,
      duration: duration,
      repeat: false,
    );
  }

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

enum ParticleType { confetti, sparkle, ambient }

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final _particles = <_Particle>[];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _generateParticles();

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  void _generateParticles() {
    final colors = widget.colors ?? const [Color(0xFF6366F1)];
    for (var i = 0; i < widget.count; i++) {
      _particles.add(_Particle(
        color: colors[i % colors.length],
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 2 + 1,
        angle: _random.nextDouble() * math.pi * 2,
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        rotation: _random.nextDouble() * math.pi * 2,
        rotationSpeed: _random.nextDouble() * 4 - 2,
        delay: _random.nextDouble() * 0.3,
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
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            type: widget.type,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  final Color color;
  final double size;
  final double speed;
  final double angle;
  final double x;
  final double y;
  final double rotation;
  final double rotationSpeed;
  final double delay;

  _Particle({
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
    required this.x,
    required this.y,
    required this.rotation,
    required this.rotationSpeed,
    required this.delay,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final ParticleType type;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final pProgress = (progress - p.delay).clamp(0.0, 1.0);
      if (pProgress <= 0) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: (1 - pProgress) * 0.8)
        ..style = PaintingStyle.fill;

      double px, py;
      double currentRotation;
      double currentSize;

      switch (type) {
        case ParticleType.confetti:
          // Confetti falls down and spreads
          px = size.width * p.x + math.cos(p.angle) * pProgress * 100 * p.speed;
          py = size.height * p.y +
              pProgress * size.height * 0.5 * p.speed;
          currentRotation = p.rotation + pProgress * math.pi * 2 * p.rotationSpeed;
          currentSize = p.size * (1 - pProgress * 0.3);
          // Draw as rotated rectangle
          canvas.save();
          canvas.translate(px, py);
          canvas.rotate(currentRotation);
          canvas.drawRect(
            Rect.fromCenter(
                center: Offset.zero,
                width: currentSize * 2,
                height: currentSize),
            paint,
          );
          canvas.restore();
          break;

        case ParticleType.sparkle:
          // Sparkles twinkle and drift
          px = size.width * p.x + math.sin(pProgress * math.pi * 2 + p.angle) * 20;
          py = size.height * p.y - pProgress * 50 * p.speed;
          final alpha = (math.sin(pProgress * math.pi * 3) * 0.5 + 0.5);
          paint.color = p.color.withValues(alpha: alpha * 0.9);
          currentSize = p.size * (0.5 + alpha * 0.5);
          // Draw as 4-point star
          _drawSparkle(canvas, px, py, currentSize, paint);
          break;

        case ParticleType.ambient:
          // Ambient floats upward slowly
          px = size.width * p.x + math.sin(pProgress * math.pi * 2 + p.angle) * 30;
          py = size.height * (1 - pProgress) * p.y;
          final alpha = math.sin(pProgress * math.pi) * 0.3;
          paint.color = p.color.withValues(alpha: alpha);
          currentSize = p.size;
          canvas.drawCircle(Offset(px, py), currentSize, paint);
          break;
      }
    }
  }

  void _drawSparkle(Canvas canvas, double cx, double cy, double size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final outerX = cx + math.cos(angle) * size;
      final outerY = cy + math.sin(angle) * size;
      final innerAngle = angle + math.pi / 4;
      final innerX = cx + math.cos(innerAngle) * size * 0.3;
      final innerY = cy + math.sin(innerAngle) * size * 0.3;
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
