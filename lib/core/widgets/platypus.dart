import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profileforge/core/accessibility/accessibility_utils.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Percy — the ProfileForge platypus mascot.
/// Pure [CustomPainter], no image asset. Warm brown body, cream belly, dark
/// bill. Roles: streak buddy, onboarding guide, empty-state friend.
/// Idle: gentle bob (spring 200/12). Happy: hop + wiggle on level-up.
/// Always decorative — wrap in Semantics(excludeSemantics: true) when purely
/// decorative, or give it a friendly label for screen readers.
/// ────────────────────────────────────────────────────────────────────────────

/// Static painted platypus (no animation). Use inside existing animations.
class PlatypusAvatar extends StatelessWidget {
  const PlatypusAvatar({
    this.size = 120,
    this.pose = PlatypusPose.idle,
    super.key,
  });

  final double size;
  final PlatypusPose pose;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PlatypusPainter(pose: pose, mood: 0.0),
    );
  }
}

enum PlatypusPose {
  idle,
  happy,
  waving,
  sleeping,
}

/// Animated platypus with a gentle idle bob.
class Percy extends StatefulWidget {
  const Percy({
    this.size = 120,
    this.animated = true,
    this.pose = PlatypusPose.idle,
    this.semanticLabel,
    super.key,
  });

  final double size;
  final bool animated;
  final PlatypusPose pose;
  final String? semanticLabel;

  @override
  State<Percy> createState() => _PercyState();
}

class _PercyState extends State<Percy> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant Percy old) {
    super.didUpdateWidget(old);
    _syncMotion();
  }

  void _syncMotion() {
    final reduceMotion = ReduceMotion.isReduceMotion(context);
    if (widget.animated && !reduceMotion && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.animated || reduceMotion) {
      _ctrl.stop();
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platypus = AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final bob = math.sin(_ctrl.value * math.pi) * 0.03;
        return Transform.translate(
          offset: Offset(0, bob * widget.size),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _PlatypusPainter(
              pose: widget.pose,
              mood: _ctrl.value,
            ),
          ),
        );
      },
    );

    if (widget.semanticLabel == null) {
      return ExcludeSemantics(child: platypus);
    }
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: ExcludeSemantics(child: platypus),
    );
  }
}

class _PlatypusPainter extends CustomPainter {
  _PlatypusPainter({required this.pose, required this.mood});

  final PlatypusPose pose;
  final double mood; // 0..1 idle oscillation

  // Palette (DESIGN.md §9).
  static const _fur = Color(0xFF8B6F5C);
  static const _furDark = Color(0xFF75523F);
  static const _belly = Color(0xFFF5E6D3);
  static const _bill = Color(0xFF2E1F1B);
  static const _eye = Color(0xFF2E1F1B);
  static const _cheek = Color(0xFFE8A09A);
  static const _glow = Color(0xFFE85D3D);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final happy = pose == PlatypusPose.happy;
    final waving = pose == PlatypusPose.waving;
    final sleeping = pose == PlatypusPose.sleeping;

    // Hop offset for happy/wave.
    final hop = happy || waving ? -h * 0.04 : 0.0;
    // Wiggle for happy pose.
    final wiggle = happy ? math.sin(mood * math.pi * 4) * 0.05 : 0.0;

    canvas.save();
    canvas.translate(cx, h * 0.5 + hop);
    canvas.rotate(wiggle);

    // ── Tail (left) ──
    final tail = Paint()..color = _fur;
    final tailPath = Path()
      ..moveTo(-w * 0.42, h * 0.06)
      ..quadraticBezierTo(-w * 0.6, -h * 0.10, -w * 0.42, -h * 0.02)
      ..quadraticBezierTo(-w * 0.52, h * 0.02, -w * 0.42, h * 0.06)
      ..close();
    canvas.drawPath(tailPath, tail);

    // ── Body (rounded, slightly wider than tall) ──
    final bodyRect = Rect.fromCenter(
      center: Offset(0, 0),
      width: w * 0.66,
      height: h * 0.58,
    );
    canvas.drawOval(bodyRect, Paint()..color = _fur);

    // Belly patch.
    final bellyRect = Rect.fromCenter(
      center: Offset(w * 0.02, h * 0.10),
      width: w * 0.42,
      height: h * 0.34,
    );
    canvas.drawOval(bellyRect, Paint()..color = _belly);

    // ── Head ──
    final headCenter = Offset(0, -h * 0.20);
    final headRadius = w * 0.22;
    canvas.drawCircle(headCenter, headRadius, Paint()..color = _fur);

    // ── Bill (wide, flat — platypus signature) ──
    final bill = Path()
      ..moveTo(-w * 0.14, -h * 0.14)
      ..quadraticBezierTo(0, -h * 0.08, w * 0.16, -h * 0.12)
      ..quadraticBezierTo(w * 0.26, -h * 0.05, w * 0.16, -h * 0.02)
      ..quadraticBezierTo(0, h * 0.02, -w * 0.14, -h * 0.02)
      ..quadraticBezierTo(-w * 0.22, -h * 0.09, -w * 0.14, -h * 0.14)
      ..close();
    canvas.drawPath(bill, Paint()..color = _bill);

    // Nostrils on the bill.
    final nostril = Paint()..color = _furDark;
    canvas.drawCircle(Offset(w * 0.02, -h * 0.10), w * 0.015, nostril);

    // ── Eyes ──
    final eyePaint = Paint()..color = _eye;
    final openEye = !sleeping;
    if (openEye) {
      // Eyebrow lift when happy.
      final brow = happy ? -h * 0.005 : 0.0;
      canvas.drawCircle(
        Offset(-w * 0.09, -h * 0.22 + brow),
        w * 0.028,
        eyePaint,
      );
      canvas.drawCircle(
        Offset(w * 0.08, -h * 0.22 + brow),
        w * 0.028,
        eyePaint,
      );
      // Eye sparkle.
      final sparkle = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(-w * 0.08, -h * 0.235 + brow),
        w * 0.008,
        sparkle,
      );
      canvas.drawCircle(
        Offset(w * 0.09, -h * 0.235 + brow),
        w * 0.008,
        sparkle,
      );
    } else {
      // Sleeping closed eyes.
      final line = Paint()
        ..color = _eye
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(-w * 0.11, -h * 0.22),
        Offset(-w * 0.05, -h * 0.24),
        line,
      );
      canvas.drawLine(
        Offset(w * 0.06, -h * 0.24),
        Offset(w * 0.12, -h * 0.22),
        line,
      );
    }

    // ── Cheeks (blush) ──
    final blush = Paint()..color = _cheek.withValues(alpha: 0.55);
    canvas.drawCircle(Offset(-w * 0.14, -h * 0.12), w * 0.035, blush);
    canvas.drawCircle(Offset(w * 0.18, -h * 0.10), w * 0.035, blush);

    // ── Feet ──
    final foot = Paint()..color = _furDark;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-w * 0.14, h * 0.26),
        width: w * 0.14,
        height: h * 0.05,
      ),
      foot,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.10, h * 0.26),
        width: w * 0.14,
        height: h * 0.05,
      ),
      foot,
    );

    // ── Happy halo / sparkle ──
    if (happy) {
      final glow = Paint()
        ..color = _glow.withValues(alpha: 0.18 + mood * 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(0, -h * 0.42), w * 0.16, glow);
    }

    // ── Waving arm ──
    if (waving) {
      final waveAngle = math.sin(mood * math.pi * 2) * 0.6 + 0.5;
      final arm = Path()
        ..moveTo(w * 0.22, -h * 0.02)
        ..quadraticBezierTo(
          w * 0.34,
          -h * 0.04 + waveAngle * h * 0.02,
          w * 0.30,
          -h * 0.10,
        )
        ..quadraticBezierTo(w * 0.22, -h * 0.04, w * 0.18, h * 0.02)
        ..close();
      canvas.drawPath(arm, Paint()..color = _fur);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlatypusPainter old) =>
      old.pose != pose || old.mood != mood;
}
