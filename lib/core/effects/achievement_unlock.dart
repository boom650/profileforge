import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementUnlockOverlay — Full-screen premium celebration overlay.
/// Triggered when user unlocks an achievement. Combines particles,
/// haptics, sound, and staggered animations for maximum impact.
/// ────────────────────────────────────────────────────────────────────────────
class AchievementUnlockOverlay extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final int xpReward;
  final VoidCallback? onComplete;

  const AchievementUnlockOverlay({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.xpReward = 0,
    this.onComplete,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    int xpReward = 0,
  }) {
    Overlay.of(context).insert(
      OverlayEntry(
        builder: (_) => AchievementUnlockOverlay(
          title: title,
          description: description,
          icon: icon,
          xpReward: xpReward,
          onComplete: () => Overlay.of(context).clear(),
        ),
      ),
    );
    // Haptic sequence
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 150), () =>
        HapticFeedback.mediumImpact());
    Future.delayed(const Duration(milliseconds: 300), () =>
        HapticFeedback.heavyImpact());
    Future.delayed(const Duration(milliseconds: 450), () =>
        HapticFeedback.mediumImpact());
  }

  @override
  State<AchievementUnlockOverlay> createState() =>
      _AchievementUnlockOverlayState();
}

class _AchievementUnlockOverlayState extends State<AchievementUnlockOverlay>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _particleController;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().then((_) {
        widget.onComplete?.call();
      });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Material(
          color: Colors.black.withValues(alpha: _bgController.value * 0.7),
          child: Stack(
            children: [
              // ── Particle burst ──
              ...List.generate(40, (i) {
                final angle = (i / 40) * 2 * math.pi;
                final speed = 100.0 + _random.nextDouble() * 200;
                final delay = _random.nextDouble() * 0.2;
                final pProgress = (_particleController.value - delay)
                    .clamp(0.0, 1.0);
                return Positioned(
                  left: size.width / 2 +
                      math.cos(angle) * speed * pProgress -
                      4,
                  top: size.height / 2 +
                      math.sin(angle) * speed * pProgress * 0.6 -
                      80 * pProgress -
                      4,
                  child: Opacity(
                    opacity: (1 - pProgress) * 0.9,
                    child: Container(
                      width: 6 + _random.nextDouble() * 6,
                      height: 6 + _random.nextDouble() * 6,
                      decoration: BoxDecoration(
                        color: [
                          Palette.primary,
                          const Color(0xFF10B981),
                          const Color(0xFFF59E0B),
                          const Color(0xFFEC4899),
                          const Color(0xFF8B5CF6),
                        ][i % 5],
                        borderRadius: BorderRadius.circular(i % 2 == 0 ? 3 : 100),
                      ),
                    ),
                  ),
                );
              }),

              // ── Center card ──
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48),
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    color: Palette.surface1.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Palette.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.3),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with glow
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: Palette.gradientPrimary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primary.withValues(alpha: 0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                          .animate()
                          .scale(
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          )
                          .then()
                          .shimmer(
                            duration: 1500.ms,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),

                      const SizedBox(height: 20),

                      // "Achievement Unlocked" label
                      Text(
                        'ACHIEVEMENT UNLOCKED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Palette.primary,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 300.ms),

                      const SizedBox(height: 8),

                      // Title
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Palette.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                      const SizedBox(height: 8),

                      // Description
                      Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.textSecondary,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                      if (widget.xpReward > 0) ...[
                        const SizedBox(height: 16),
                        // XP reward badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: Palette.gradientPrimary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '+${widget.xpReward} XP',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        )
                            .animate(delay: 500.ms)
                            .scale(
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            ),
                      ],

                      const SizedBox(height: 20),

                      // Tap to dismiss hint
                      Text(
                        'Tap to dismiss',
                        style: TextStyle(
                          fontSize: 12,
                          color: Palette.textTertiary,
                        ),
                      ).animate(delay: 1000.ms).fadeIn(duration: 500.ms),
                    ],
                  ),
                ).animate().scale(
                  duration: 400.ms,
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
