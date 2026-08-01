import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// StreakFire — Animated fire effect using CustomPainter.
/// Draws flickering flames that respond to streak count.
/// More streak = bigger, more intense fire.
/// ────────────────────────────────────────────────────────────────────────────
class StreakFire extends StatefulWidget {
  final int streak;
  final double size;

  const StreakFire({
    super.key,
    required this.streak,
    this.size = 48,
  });

  @override
  State<StreakFire> createState() => _StreakFireState();
}

class _StreakFireState extends State<StreakFire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
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
          size: Size(widget.size, widget.size),
          painter: _FirePainter(
            progress: _controller.value,
            streak: widget.streak,
          ),
        );
      },
    );
  }
}

class _FirePainter extends CustomPainter {
  final double progress;
  final int streak;

  _FirePainter({required this.progress, required this.streak});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final intensity = (streak / 30).clamp(0.3, 1.0);
    final height = size.height * (0.5 + intensity * 0.5);

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6B00).withValues(alpha: 0.3 * intensity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: height * 0.8));
    canvas.drawCircle(center, height * 0.8, glowPaint);

    // Main flame layers
    for (int layer = 0; layer < 3; layer++) {
      final layerProgress = (progress + layer * 0.3) % 1.0;
      final flicker = math.sin(layerProgress * math.pi * 4 + layer) * 0.15;
      final wobble = math.sin(layerProgress * math.pi * 6) * size.width * 0.08;

      final path = Path();
      final baseWidth = size.width * (0.35 - layer * 0.08) * intensity;
      final flameHeight = height * (0.8 - layer * 0.15);

      path.moveTo(center.dx, center.dy - flameHeight);
      path.quadraticBezierTo(
        center.dx + baseWidth + wobble,
        center.dy - flameHeight * 0.6,
        center.dx + baseWidth * 0.8,
        center.dy - flameHeight * 0.2,
      );
      path.quadraticBezierTo(
        center.dx + baseWidth * 0.4,
        center.dy - flameHeight * 0.1,
        center.dx,
        center.dy,
      );
      path.quadraticBezierTo(
        center.dx - baseWidth * 0.4,
        center.dy - flameHeight * 0.1,
        center.dx - baseWidth * 0.8,
        center.dy - flameHeight * 0.2,
      );
      path.quadraticBezierTo(
        center.dx - baseWidth - wobble,
        center.dy - flameHeight * 0.6,
        center.dx,
        center.dy - flameHeight,
      );

      final colors = [
        [const Color(0xFFFF4500), const Color(0xFFFF6B00)],
        [const Color(0xFFFF6B00), const Color(0xFFFFAA00)],
        [const Color(0xFFFFAA00), const Color(0xFFFFDD00)],
      ];

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: colors[layer],
        ).createShader(path.getBounds())
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0 + layer * 1.5);

      canvas.drawPath(path, paint);
    }

    // Inner bright core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFEE88).withValues(alpha: 0.8),
          const Color(0xFFFFAA00).withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx, center.dy - height * 0.25),
        radius: height * 0.2,
      ));
    canvas.drawCircle(
      Offset(center.dx, center.dy - height * 0.25),
      height * 0.2,
      corePaint,
    );
  }

  @override
  bool shouldRepaint(_FirePainter old) => old.progress != progress;
}
