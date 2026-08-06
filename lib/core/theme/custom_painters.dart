import 'dart:math';
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Custom Painters — Premium visual effects.
///
/// - WaveBackgroundPainter
/// - GlassMorphismPainter
/// - GlowPainter
/// - MeshGradientPainter
/// - ParticleFieldPainter
/// - ScoreArcPainter
/// ────────────────────────────────────────────────────────────────────────────

/// WaveBackgroundPainter — Animated wave background.
class WaveBackgroundPainter extends CustomPainter {
  WaveBackgroundPainter({
    required this.animation,
    required this.color,
    this.amplitude = 20,
    this.frequency = 2,
  });

  final double animation;
  final Color color;
  final double amplitude;
  final int frequency;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.5 +
          amplitude * sin((x / size.width * pi * frequency) + (animation * 2 * pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Second wave
    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.6 +
          amplitude * 0.7 *
              sin((x / size.width * pi * frequency * 1.5) +
                  (animation * 2 * pi) +
                  pi / 3);
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WaveBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

/// GlassMorphismPainter — Frosted glass effect.
class GlassMorphismPainter extends CustomPainter {
  GlassMorphismPainter({
    this.borderRadius = 20,
    this.borderColor,
    this.borderWidth = 1,
  });

  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Fill
    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, fillPaint);

    // Border
    if (borderColor != null) {
      final borderPaint = Paint()
        ..color = borderColor!.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawRRect(rect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(GlassMorphismPainter oldDelegate) => false;
}

/// GlowPainter — Ambient glow effect around a shape.
class GlowPainter extends CustomPainter {
  GlowPainter({
    required this.color,
    this.radius = 40,
    this.intensity = 0.3,
  });

  final Color color;
  final double radius;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: intensity),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(GlowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

/// MeshGradientPainter — Complex mesh gradient effect.
class MeshGradientPainter extends CustomPainter {
  MeshGradientPainter({
    required this.colors,
    this.points = const [],
  });

  final List<Color> colors;
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final color = colors[i % colors.length];
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.4),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: point, radius: 150));

      canvas.drawCircle(point, 150, paint);
    }
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

/// ParticleFieldPainter — Floating particle effect.
class ParticleFieldPainter extends CustomPainter {
  ParticleFieldPainter({
    required this.particles,
    required this.color,
  });

  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      final opacity = (1.0 - particle.life) * 0.5;
      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticleFieldPainter oldDelegate) {
    return oldDelegate.particles != particles;
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double life;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.life,
  });
}

/// ScoreArcPainter — Animated arc for score display.
class ScoreArcPainter extends CustomPainter {
  ScoreArcPainter({
    required this.progress,
    required this.color,
    this.backgroundColor,
    this.strokeWidth = 8,
  });

  final double progress;
  final Color color;
  final Color? backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Background arc
    if (backgroundColor != null) {
      final bgPaint = Paint()
        ..color = backgroundColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi,
        false,
        bgPaint,
      );
    }

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ScoreArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// DotGridPainter — Subtle dot grid background.
class DotGridPainter extends CustomPainter {
  DotGridPainter({
    this.spacing = 20,
    this.dotRadius = 1,
    this.color = Colors.white,
    this.opacity = 0.05,
  });

  final double spacing;
  final double dotRadius;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotGridPainter oldDelegate) => false;
}
