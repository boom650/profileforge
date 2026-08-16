import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/accessibility/accessibility_utils.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Motion Kit — Duolingo-style micro-interactions.
///
/// Small, reusable, delightful. Everything here is a tiny detail that makes
/// the app feel alive:
///   • PressableScale  — tactile press feedback on any widget
///   • StreakFlame     — flickering animated flame
///   • CheckmarkDraw   — animated checkmark stroke (mission complete)
///   • LevelUpOverlay  — full-screen level-up celebration
///   • NavPill         — sliding pill behind the active nav item
///   • FloatingXp      — "+N XP" chip that pops in from the button
/// ────────────────────────────────────────────────────────────────────────────

/// Press feedback: scales down on press, springs back with elastic overshoot.
/// Wraps any child; callbacks fire like a normal GestureDetector.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.94,
    this.duration = const Duration(milliseconds: 160),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration =
        ReduceMotion.getAnimationDuration(context, widget.duration);
    _c.duration = duration;
    _c.reverseDuration = duration;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down() {
    HapticFeedback.selectionClick();
    _c.forward();
  }

  void _up() {
    _c.reverse();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _down(),
      onTapUp: (_) => _up(),
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, child) {
          final v = Curves.easeOut.transform(_c.value);
          return Transform.scale(
            scale: 1 - (1 - widget.scaleDown) * v,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Flickering animated flame — used for streak badges and fire missions.
class StreakFlame extends StatefulWidget {
  const StreakFlame({
    super.key,
    this.size = 22,
    this.color = const Color(0xFFFF8A00),
  });

  final double size;
  final Color color;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: 900.ms,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ReduceMotion.isReduceMotion(context)) {
      _c.stop();
      _c.value = 0.5;
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => CustomPaint(
        painter: _FlamePainter(
          progress: _c.value,
          color: widget.color,
        ),
        size: Size.square(widget.size),
      ),
    );
  }
}

class _FlamePainter extends CustomPainter {
  _FlamePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Flame flicker: scale the body and sway the tip.
    final flicker = 1 + 0.06 * math.sin(progress * math.pi * 2);
    final sway = math.sin(progress * math.pi * 4) * w * 0.04;

    final body = Path()
      ..moveTo(w * 0.5, h * 0.98)
      ..quadraticBezierTo(
        w * 0.1 + sway,
        h * 0.62,
        w * 0.34 + sway * 1.5,
        h * 0.42,
      )
      ..quadraticBezierTo(
        w * 0.52 + sway,
        h * 0.18 * flicker,
        w * 0.6 + sway,
        h * 0.4,
      )
      ..quadraticBezierTo(
        w * 0.92 + sway,
        h * 0.62,
        w * 0.5,
        h * 0.98,
      )
      ..close();

    canvas.drawShadow(body, color.withValues(alpha: 0.5), 6, true);

    final grad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 1.0),
          color.withValues(alpha: 0.35),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(body, grad);

    // Inner core glow.
    final core = Paint()
      ..color = const Color(0xFFFFF3C4).withValues(alpha: 0.9);
    canvas.drawCircle(
      Offset(w * 0.44, h * 0.52),
      w * 0.1 * (1 + 0.15 * math.sin(progress * math.pi * 3)),
      core,
    );
  }

  @override
  bool shouldRepaint(covariant _FlamePainter old) => old.progress != progress;
}

/// Animated checkmark that draws its stroke — mission-complete feedback.
class CheckmarkDraw extends StatelessWidget {
  const CheckmarkDraw({
    super.key,
    this.size = 44,
    this.color = Colors.white,
    this.strokeWidth = 4.5,
    this.duration = const Duration(milliseconds: 420),
  });

  final double size;
  final Color color;
  final double strokeWidth;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => CustomPaint(
        painter: CheckStrokePainter(
          progress: v,
          color: color,
          strokeWidth: strokeWidth,
        ),
        size: Size.square(size),
      ),
    );
  }
}

class CheckStrokePainter extends CustomPainter {
  CheckStrokePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Checkmark path (two segments).
    const p1 = Offset(0.24, 0.52);
    const p2 = Offset(0.42, 0.70);
    const p3 = Offset(0.78, 0.30);

    final seg1 = progress.clamp(0.0, 0.55) / 0.55;
    final seg2 = (progress - 0.45).clamp(0.0, 0.55) / 0.55;

    final a = Offset(w * p1.dx, h * p1.dy);
    final b = Offset(w * p2.dx, h * p2.dy);
    final c = Offset(w * p3.dx, h * p3.dy);

    if (seg1 > 0) {
      canvas.drawLine(a, Offset.lerp(a, b, seg1)!, paint);
    }
    if (seg2 > 0) {
      canvas.drawLine(b, Offset.lerp(b, c, seg2)!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CheckStrokePainter old) =>
      old.progress != progress;
}

/// Full-screen level-up celebration: expanding rings + glow + big level text.
/// Call once per level boundary; auto-removes.
void showLevelUp(BuildContext context, int level) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _LevelUpLayer(
      level: level,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
  HapticFeedback.heavyImpact();
}

class _LevelUpLayer extends StatefulWidget {
  const _LevelUpLayer({required this.level, required this.onDone});
  final int level;
  final VoidCallback onDone;

  @override
  State<_LevelUpLayer> createState() => _LevelUpLayerState();
}

class _LevelUpLayerState extends State<_LevelUpLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: 1800.ms);

  @override
  void initState() {
    super.initState();
    Future.delayed(1900.ms, widget.onDone);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = ReduceMotion.getAnimationDuration(
        context, const Duration(milliseconds: 1800));
    _c.duration = duration;
    if (ReduceMotion.isReduceMotion(context)) {
      _c.value = 1.0;
    } else if (!_c.isAnimating) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dim scrim.
            AnimatedBuilder(
              animation: _c,
              builder: (_, __) => Container(
                color: Colors.black
                    .withValues(alpha: 0.55 * (1 - _c.value).clamp(0.0, 0.4)),
              ),
            ),
            // Expanding rings.
            AnimatedBuilder(
              animation: _c,
              builder: (_, __) {
                final v = Curves.easeOutCubic.transform(_c.value);
                return CustomPaint(
                  painter: _RingsPainter(v),
                  size: MediaQuery.of(context).size,
                );
              },
            ),
            // Level number pop.
            AnimatedBuilder(
              animation: _c,
              builder: (_, __) {
                final appear = (_c.value * 2).clamp(0.0, 1.0);
                return Transform.scale(
                  scale: Curves.elasticOut.transform(appear),
                  child: Opacity(
                    opacity: appear.clamp(0.0, 1.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LEVEL UP!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Palette.warning,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.level}',
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Palette.success,
                                blurRadius: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 3; i++) {
      final t = ((progress - i * 0.18) / (1 - i * 0.18)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final radius = 40 + t * (size.width * 0.45);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * (1 - t)
        ..color = Palette.primary.withValues(alpha: (1 - t) * 0.6);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) => old.progress != progress;
}

/// Sliding pill behind the active bottom-nav item.
class NavPill extends StatelessWidget {
  const NavPill({
    super.key,
    required this.selected,
    required this.index,
    required this.itemCount,
    this.color = Palette.primary,
    this.width = 44,
    this.height = 4,
  });

  final int selected;
  final int index;
  final int itemCount;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: Alignment(0, 0),
      duration: 260.ms,
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: selected == index ? 1 : 0,
        duration: 180.ms,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "+N XP" chip that pops from a source position and drifts up.
/// Optional: shows the chip without an overlay — use inside a Stack.
class XpPill extends StatelessWidget {
  const XpPill({
    super.key,
    required this.amount,
    this.gems,
    this.color = Palette.warning,
  });

  final int amount;
  final int? gems;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+$amount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          if (gems != null) ...[
            const SizedBox(width: 3),
            const Icon(Icons.diamond, color: Colors.white, size: 14),
            Text(
              '+$gems',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    ).animate().scale(
          begin: const Offset(0.4, 0.4),
          duration: 300.ms,
          curve: Curves.elasticOut,
        );
  }
}
