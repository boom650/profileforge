import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/audio/sound_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementUnlock — Premium unlock animation for badges.
/// Shows: golden burst + trophy bounce + badge details.
/// ────────────────────────────────────────────────────────────────────────────
class AchievementUnlock extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;
  final VoidCallback? onDismiss;

  const AchievementUnlock({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String emoji,
    required String title,
    required String description,
  }) {
    Overlay.of(context).insert(
      OverlayEntry(
        builder: (_) => AchievementUnlock(
          emoji: emoji,
          title: title,
          description: description,
          onDismiss: () {},
        ),
      ),
    );
  }

  @override
  State<AchievementUnlock> createState() => _AchievementUnlockState();
}

class _AchievementUnlockState extends State<AchievementUnlock>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _badgeController;
  late AnimationController _sparkleController;
  final List<_Sparkle> _sparkles = [];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(vsync: this, duration: 600.ms);
    _badgeController = AnimationController(vsync: this, duration: 800.ms);
    _sparkleController = AnimationController(vsync: this, duration: 1500.ms);

    _generateSparkles();

    // Sound + haptics
    SoundService.instance.unlock();
    HapticFeedback.mediumImpact();
    Future.delayed(150.ms, () => HapticFeedback.lightImpact());
    Future.delayed(300.ms, () => HapticFeedback.mediumImpact());

    // Start animations
    _bgController.forward();
    Future.delayed(100.ms, () => _badgeController.forward());
    _sparkleController.forward();

    // Auto-dismiss
    Future.delayed(2500.ms, () {
      if (mounted) _dismiss();
    });
  }

  void _generateSparkles() {
    final rng = math.Random();
    for (int i = 0; i < 24; i++) {
      _sparkles.add(_Sparkle(
        angle: (i / 24) * math.pi * 2,
        distance: 60 + rng.nextDouble() * 40,
        size: 2 + rng.nextDouble() * 4,
        delay: rng.nextDouble() * 0.3,
        color: [
          Palette.warning,
          Palette.primary,
          Palette.accent,
          Colors.white,
        ][rng.nextInt(4)],
      ));
    }
  }

  void _dismiss() {
    _bgController.reverse().then((_) => widget.onDismiss?.call());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _badgeController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgController,
        _badgeController,
        _sparkleController,
      ]),
      builder: (context, _) {
        return Stack(
          children: [
            // Background dim
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: _bgController.value * 0.6),
              ),
            ),

            // Golden burst rays
            if (_badgeController.value > 0)
              Positioned.fill(
                child: Center(
                  child: Transform.rotate(
                    angle: _badgeController.value * 0.5,
                    child: CustomPaint(
                      painter: _GoldenBurstPainter(
                        progress: _badgeController.value,
                      ),
                      size: Size(
                        MediaQuery.of(context).size.width * 0.8,
                        MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                  ),
                ),
              ),

            // Sparkles
            Positioned.fill(
              child: Center(
                child: CustomPaint(
                  painter: _SparklePainter(
                    sparkles: _sparkles,
                    progress: _sparkleController.value,
                  ),
                  size: const Size(200, 200),
                ),
              ),
            ),

            // Badge card
            Center(
              child: Transform.scale(
                scale: Curves.elasticOut.transform(_badgeController.value.clamp(0.0, 1.0)),
                child: Opacity(
                  opacity: _badgeController.value.clamp(0.0, 1.0),
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Palette.surface1,
                          Palette.surface2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Palette.warning.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.warning.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // "UNLOCKED" label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Palette.warning.withValues(alpha: 0.2),
                                Palette.accent.withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '🎉 UNLOCKED',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: Palette.warning,
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 16),

                        // Emoji badge
                        Text(
                          widget.emoji,
                          style: const TextStyle(fontSize: 56),
                        ).animate().scale(
                          begin: const Offset(0.3, 0.3),
                          delay: 300.ms,
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        ),

                        const SizedBox(height: 12),

                        // Title
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Palette.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                        const SizedBox(height: 6),

                        // Description
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Palette.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 500.ms),

                        const SizedBox(height: 20),

                        // Dismiss
                        GestureDetector(
                          onTap: _dismiss,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: Palette.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Palette.warning.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Text(
                              'Nice!',
                              style: TextStyle(
                                color: Palette.warning,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Sparkle {
  final double angle;
  final double distance;
  final double size;
  final double delay;
  final Color color;

  _Sparkle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
    required this.color,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double progress;

  _SparklePainter({required this.sparkles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final s in sparkles) {
      final t = ((progress - s.delay) / (1 - s.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final dist = s.distance * t;
      final x = center.dx + math.cos(s.angle) * dist;
      final y = center.dy + math.sin(s.angle) * dist;
      final alpha = (1 - t).clamp(0.0, 1.0);

      // Star sparkle
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * math.pi);

      final paint = Paint()..color = s.color.withValues(alpha: alpha);

      // Draw 4-pointed star
      final path = Path();
      final outer = s.size * 2;
      final inner = s.size * 0.5;
      for (int i = 0; i < 8; i++) {
        final r = i.isEven ? outer : inner;
        final angle = (i / 8) * math.pi * 2;
        final point = Offset(
          math.cos(angle) * r,
          math.sin(angle) * r,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => old.progress != progress;
}

class _GoldenBurstPainter extends CustomPainter {
  final double progress;

  _GoldenBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rayCount = 12;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * math.pi * 2;
      final length = size.width * 0.4 * progress;
      final width = 3.0 + math.sin(progress * math.pi * 2 + i) * 1.5;

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Palette.warning.withValues(alpha: 0.3 * progress),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCenter(
          center: center,
          width: length * 2,
          height: width,
        ))
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;

      final start = Offset(
        center.dx + math.cos(angle) * 30,
        center.dy + math.sin(angle) * 30,
      );
      final end = Offset(
        center.dx + math.cos(angle) * (30 + length),
        center.dy + math.sin(angle) * (30 + length),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(_GoldenBurstPainter old) => old.progress != progress;
}
