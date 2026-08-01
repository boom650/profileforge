import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/audio/sound_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// DailyRewardClaim — Satisfying daily reward claim with particle burst.
/// Shows: glowing gift box → tap → particles + reward reveal.
/// ────────────────────────────────────────────────────────────────────────────
class DailyRewardClaim extends StatefulWidget {
  final int xpReward;
  final int gemReward;
  final int dayStreak;
  final VoidCallback onClaimed;

  const DailyRewardClaim({
    super.key,
    required this.xpReward,
    required this.gemReward,
    required this.dayStreak,
    required this.onClaimed,
  });

  @override
  State<DailyRewardClaim> createState() => _DailyRewardClaimState();
}

class _DailyRewardClaimState extends State<DailyRewardClaim>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _burstController;
  bool _claimed = false;
  final List<_RewardParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: 1200.ms)
      ..repeat(reverse: true);
    _burstController = AnimationController(vsync: this, duration: 1000.ms);
    _generateParticles();
  }

  void _generateParticles() {
    final rng = math.Random();
    for (int i = 0; i < 40; i++) {
      _particles.add(_RewardParticle(
        color: [
          Palette.warning,
          Palette.primary,
          Palette.accent,
          Palette.success,
          const Color(0xFFEC4899),
        ][rng.nextInt(5)],
        angle: (i / 40) * math.pi * 2 + rng.nextDouble() * 0.5,
        speed: 150 + rng.nextDouble() * 250,
        size: 3 + rng.nextDouble() * 6,
        delay: rng.nextDouble() * 0.2,
      ));
    }
  }

  void _claim() {
    if (_claimed) return;
    setState(() => _claimed = true);

    // Haptics + sound
    HapticFeedback.heavyImpact();
    SoundService.instance.coin();
    Future.delayed(100.ms, () => HapticFeedback.mediumImpact());

    // Burst animation
    _burstController.forward();

    // Callback after animation
    Future.delayed(1500.ms, () {
      widget.onClaimed();
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _claim,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowController, _burstController]),
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _claimed
                    ? [Palette.surface1, Palette.surface2]
                    : [
                        Palette.surface1,
                        Palette.surface2.withValues(
                          alpha: 0.8 + _glowController.value * 0.2,
                        ),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _claimed
                    ? Palette.success.withValues(alpha: 0.3)
                    : Palette.warning.withValues(
                        alpha: 0.3 + _glowController.value * 0.2,
                      ),
                width: _claimed ? 1 : 2,
              ),
              boxShadow: _claimed
                  ? []
                  : [
                      BoxShadow(
                        color: Palette.warning.withValues(
                          alpha: 0.2 + _glowController.value * 0.15,
                        ),
                        blurRadius: 20 + _glowController.value * 10,
                        spreadRadius: _glowController.value * 3,
                      ),
                    ],
            ),
            child: Stack(
              children: [
                // Particle burst
                if (_claimed)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RewardParticlePainter(
                        particles: _particles,
                        progress: _burstController.value,
                      ),
                    ),
                  ),

                // Content
                Column(
                  children: [
                    // Gift icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: _claimed
                            ? LinearGradient(
                                colors: [
                                  Palette.success.withValues(alpha: 0.2),
                                  Palette.success.withValues(alpha: 0.1),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Palette.warning.withValues(alpha: 0.2),
                                  Palette.accent.withValues(alpha: 0.2),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _claimed ? '✅' : '🎁',
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ).animate().scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      _claimed ? 'Claimed!' : 'Daily Reward',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _claimed ? Palette.success : Palette.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Streak info
                    Text(
                      'Day ${widget.dayStreak} streak',
                      style: TextStyle(
                        fontSize: 12,
                        color: Palette.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rewards row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RewardBadge(
                          icon: '⭐',
                          value: '+${widget.xpReward}',
                          color: Palette.warning,
                        ),
                        const SizedBox(width: 16),
                        _RewardBadge(
                          icon: '💎',
                          value: '+${widget.gemReward}',
                          color: Palette.accent,
                        ),
                      ],
                    ),

                    if (!_claimed) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: Palette.gradientPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Tap to Claim',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;

  const _RewardBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardParticle {
  final Color color;
  final double angle;
  final double speed;
  final double size;
  final double delay;

  _RewardParticle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
    required this.delay,
  });
}

class _RewardParticlePainter extends CustomPainter {
  final List<_RewardParticle> particles;
  final double progress;

  _RewardParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.3);
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final dist = p.speed * t;
      final x = center.dx + math.cos(p.angle) * dist;
      final y = center.dy + math.sin(p.angle) * dist + 100 * t * t;
      final alpha = (1 - t).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(x, y),
        p.size * (1 - t * 0.5),
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_RewardParticlePainter old) => old.progress != progress;
}
