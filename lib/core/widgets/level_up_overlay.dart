import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/audio/sound_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// LevelUpOverlay — Full-screen celebration when user levels up.
/// Shows: confetti burst + level number + title + shine effect.
/// ────────────────────────────────────────────────────────────────────────────
class LevelUpOverlay extends StatefulWidget {
  final int newLevel;
  final String title;
  final VoidCallback onDismiss;

  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    required this.title,
    required this.onDismiss,
  });

  static void show(BuildContext context, {required int newLevel, required String title}) {
    Overlay.of(context).insert(
      OverlayEntry(
        builder: (_) => LevelUpOverlay(
          newLevel: newLevel,
          title: title,
          onDismiss: () {},
        ),
      ),
    );
  }

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _cardController;
  late AnimationController _particleController;
  final List<_ShineParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Background flash
    _bgController = AnimationController(vsync: this, duration: 800.ms);
    _bgController.forward();

    // Card bounce in
    _cardController = AnimationController(vsync: this, duration: 600.ms);

    // Particle burst
    _particleController = AnimationController(vsync: this, duration: 2000.ms);
    _generateParticles();

    // Haptics + sound
    HapticFeedback.heavyImpact();
    SoundService.instance.levelUp();
    Future.delayed(100.ms, () => HapticFeedback.mediumImpact());
    Future.delayed(200.ms, () => HapticFeedback.heavyImpact());

    // Start card animation after brief delay
    Future.delayed(200.ms, () {
      _cardController.forward();
      _particleController.forward();
    });

    // Auto-dismiss after 3 seconds
    Future.delayed(3000.ms, () {
      if (mounted) {
        _bgController.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  void _generateParticles() {
    final rng = math.Random();
    for (int i = 0; i < 60; i++) {
      _particles.add(_ShineParticle(
        color: [
          Palette.primary,
          Palette.accent,
          Palette.warning,
          Palette.success,
          const Color(0xFFEC4899),
          const Color(0xFF06B6D4),
        ][rng.nextInt(6)],
        angle: -math.pi / 2 + (rng.nextDouble() - 0.5) * math.pi * 1.5,
        speed: 200 + rng.nextDouble() * 400,
        size: 3 + rng.nextDouble() * 8,
        delay: rng.nextDouble() * 0.3,
        spin: rng.nextDouble() * 4 - 2,
      ));
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bgController, _cardController, _particleController]),
      builder: (context, _) {
        return Stack(
          children: [
            // Background dim
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: _bgController.value * 0.7,
                ),
              ),
            ),

            // Particle burst
            Positioned.fill(
              child: CustomPaint(
                painter: _LevelUpParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              ),
            ),

            // Center card
            Center(
              child: Transform.scale(
                scale: Curves.elasticOut.transform(_cardController.value),
                child: Opacity(
                  opacity: _cardController.value.clamp(0.0, 1.0),
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Palette.surface1,
                          Palette.surface2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Palette.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.4),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Palette.accent.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Level number with shine
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow ring
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Palette.primary.withValues(alpha: 0.3),
                                    Palette.accent.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ).animate(
                              onPlay: (c) => c.repeat(),
                            ).scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.1, 1.1),
                              duration: 1200.ms,
                              curve: Curves.easeInOut,
                            ),
                            // Level number
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: Palette.gradientPrimary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Palette.primary.withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.newLevel}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().scale(
                          begin: const Offset(0.3, 0.3),
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        ),

                        const SizedBox(height: 20),

                        // "LEVEL UP" text
                        Text(
                          'LEVEL UP!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Palette.primary, Palette.accent],
                              ).createShader(const Rect.fromLTWH(0, 0, 200, 40)),
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

                        const SizedBox(height: 8),

                        // Title
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Palette.textSecondary,
                          ),
                        ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 24),

                        // Dismiss button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _bgController.reverse().then((_) => widget.onDismiss());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: Palette.gradientPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
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

class _ShineParticle {
  _ShineParticle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
    required this.delay,
    required this.spin,
  });
  final Color color;
  final double angle;
  final double speed;
  final double size;
  final double delay;
  final double spin;
}

class _LevelUpParticlePainter extends CustomPainter {
  _LevelUpParticlePainter({required this.particles, required this.progress});
  final List<_ShineParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final dist = p.speed * t;
      final x = center.dx + math.cos(p.angle) * dist;
      final y = center.dy + math.sin(p.angle) * dist + 200 * t * t;
      final alpha = (1 - t).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin * t * 3);

      // Draw circle particle
      canvas.drawCircle(
        Offset.zero,
        p.size * (1 - t * 0.5),
        Paint()..color = p.color.withValues(alpha: alpha),
      );

      // Draw shine trail
      final trailPaint = Paint()
        ..color = p.color.withValues(alpha: alpha * 0.3)
        ..strokeWidth = p.size * 0.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset.zero,
        Offset(-math.cos(p.angle) * p.size * 3, -math.sin(p.angle) * p.size * 3),
        trailPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_LevelUpParticlePainter old) => old.progress != progress;
}
