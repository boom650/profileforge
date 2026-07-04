/// Daily Reward Widget
///
/// Shows a 7-day login reward calendar with streak visualization,
/// claim animation, and coin particle effects.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../../models/gamification/coin_store.dart';

// ---------------------------------------------------------------------------
// DailyRewardWidget – Bottom sheet for daily reward claiming
// ---------------------------------------------------------------------------

class DailyRewardWidget extends StatefulWidget {
  final CoinStore store;
  final ValueChanged<int> onClaimed;

  const DailyRewardWidget({
    super.key,
    required this.store,
    required this.onClaimed,
  });

  @override
  State<DailyRewardWidget> createState() => _DailyRewardWidgetState();
}

class _DailyRewardWidgetState extends State<DailyRewardWidget>
    with TickerProviderStateMixin {
  late AnimationController _claimAnimController;
  late Animation<double> _coinScaleAnim;
  late Animation<double> _coinRotateAnim;
  bool _showParticles = false;
  bool _justClaimed = false;
  int _claimedAmount = 0;

  @override
  void initState() {
    super.initState();
    _claimAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _coinScaleAnim = Tween<double>(begin: 1.0, end: 2.5).animate(
      CurvedAnimation(
        parent: _claimAnimController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _coinRotateAnim = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _claimAnimController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _claimAnimController.dispose();
    super.dispose();
  }

  void _claimReward() {
    if (!widget.store.canClaimDailyReward || _justClaimed) return;

    HapticFeedback.heavyImpact();

    final coins = widget.store.claimDailyReward();
    setState(() {
      _justClaimed = true;
      _claimedAmount = coins;
      _showParticles = true;
    });

    _claimAnimController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => _showParticles = false);
        }
      });
    });

    widget.onClaimed(coins);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.store.dailyRewardState;
    final canClaim = widget.store.canClaimDailyReward && !_justClaimed;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  _justClaimed ? 'Reward Claimed!' : 'Daily Rewards',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _justClaimed
                      ? 'You earned $_claimedAmount coins!'
                      : 'Log in daily to earn increasing rewards',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // 7-day calendar
                _buildRewardCalendar(state, canClaim),
                const SizedBox(height: 20),

                // Streak multiplier info
                _buildStreakInfo(state),
                const SizedBox(height: 24),

                // Claim button or claimed status
                if (_justClaimed)
                  _buildClaimedStatus()
                else if (canClaim)
                  _buildClaimButton()
                else
                  _buildAlreadyClaimed(),
                const SizedBox(height: 16),

                // Total earned
                if (state.totalCoinsEarnedFromRewards > 0)
                  _buildTotalEarned(state),
              ],
            ),
          ),

          // Coin particles overlay
          if (_showParticles)
            Positioned.fill(
              child: _CoinParticleEffect(
                origin: Offset(
                  MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height * 0.35,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── 7-Day Reward Calendar ────────────────────────────────────────────────

  Widget _buildRewardCalendar(DailyRewardState state, bool canClaim) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final day = index + 1;
          final reward = DailyRewardConfig.rewardForDay(day);
          final isCurrentDay = day == state.currentStreakDay && !_justClaimed;
          final isClaimedDay = day < state.currentStreakDay || _justClaimed;
          final isToday = day == state.currentStreakDay;
          final isLastDay = day == 7;

          return _buildDayCell(
            day: day,
            reward: reward,
            isCurrentDay: isCurrentDay,
            isClaimedDay: isClaimedDay,
            isToday: isToday,
            isLastDay: isLastDay,
            canClaim: canClaim && isToday,
          );
        }),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildDayCell({
    required int day,
    required int reward,
    required bool isCurrentDay,
    required bool isClaimedDay,
    required bool isToday,
    required bool isLastDay,
    required bool canClaim,
  }) {
    final size = isToday ? 48.0 : 40.0;
    final bgColor = isClaimedDay
        ? AppTheme.successGreen.withValues(alpha: 0.15)
        : isCurrentDay && canClaim
            ? AppTheme.accentGold.withValues(alpha: 0.15)
            : context.surfaceElevated;
    final borderColor = isClaimedDay
        ? AppTheme.successGreen
        : isCurrentDay && canClaim
            ? AppTheme.accentGold
            : context.borderColor;
    final textColor = isClaimedDay
        ? AppTheme.successGreen
        : isCurrentDay
            ? AppTheme.accentGold
            : context.textMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Day label
        Text(
          'D$day',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 4),

        // Day cell
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isCurrentDay && canClaim
                ? [
                    BoxShadow(
                      color: AppTheme.accentGold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isClaimedDay
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppTheme.successGreen,
                  )
                : Text(
                    '$reward',
                    style: GoogleFonts.inter(
                      fontSize: isToday ? 13 : 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 4),

        // Multiplier for days > 1
        if (day > 1)
          Text(
            DailyRewardConfig.multiplierText(day),
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }

  // ── Streak Info ──────────────────────────────────────────────────────────

  Widget _buildStreakInfo(DailyRewardState state) {
    final totalPossible = DailyRewardConfig.totalCycleCoins;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Streak flame icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 22,
              color: AppTheme.accentOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak Bonus',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Day ${state.currentStreakDay}/7 — '
                  '${state.totalDaysClaimed} total logins',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Total possible
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$totalPossible/wk',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentGold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  // ── Claim Button ─────────────────────────────────────────────────────────

  Widget _buildClaimButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _claimReward,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentGold,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppTheme.accentGold.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.monetization_on_rounded,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'Claim ${widget.store.todayRewardAmount} Coins',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .then(delay: 200.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ── Claimed Status ───────────────────────────────────────────────────────

  Widget _buildClaimedStatus() {
    return AnimatedBuilder(
      animation: _claimAnimController,
      builder: (context, child) {
        return Column(
          children: [
            // Animated coin
            Transform.scale(
              scale: _coinScaleAnim.value,
              child: Transform.rotate(
                angle: _coinRotateAnim.value,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientGold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentGold.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.monetization_on_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '+$_claimedAmount coins',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.accentGold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Come back tomorrow for more!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Already Claimed ──────────────────────────────────────────────────────

  Widget _buildAlreadyClaimed() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.textMuted.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 28,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'Already claimed today!',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Come back tomorrow for day ${widget.store.currentStreakDay}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  // ── Total Earned ─────────────────────────────────────────────────────────

  Widget _buildTotalEarned(DailyRewardState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.savings_rounded,
            size: 16,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: 8),
          Text(
            'Total earned from daily rewards: ${state.totalCoinsEarnedFromRewards} coins',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.successGreen,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }
}

// ---------------------------------------------------------------------------
// Coin Particle Effect – simple coin-shaped particles floating upward
// ---------------------------------------------------------------------------

class _CoinParticleEffect extends StatefulWidget {
  final Offset origin;

  const _CoinParticleEffect({required this.origin});

  @override
  State<_CoinParticleEffect> createState() => _CoinParticleEffectState();
}

class _CoinParticleEffectState extends State<_CoinParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_CoinParticle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _generateParticles();
    _controller.forward().then((_) {
      if (mounted) {
        // Done
      }
    });
  }

  void _generateParticles() {
    _particles = List.generate(12, (_) {
      return _CoinParticle(
        angle: -pi / 2 + (_random.nextDouble() - 0.5) * pi * 0.8,
        speed: 120 + _random.nextDouble() * 200,
        size: 8 + _random.nextDouble() * 8,
        delay: _random.nextDouble() * 0.3,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      );
    });
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
          size: Size.infinite,
          painter: _CoinParticlePainter(
            progress: _controller.value,
            particles: _particles,
            origin: widget.origin,
          ),
        );
      },
    );
  }
}

class _CoinParticle {
  final double angle;
  final double speed;
  final double size;
  final double delay;
  final double rotation;
  final double rotationSpeed;

  const _CoinParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.delay,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _CoinParticlePainter extends CustomPainter {
  final double progress;
  final List<_CoinParticle> particles;
  final Offset origin;

  _CoinParticlePainter({
    required this.progress,
    required this.particles,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final adjustedProgress = ((progress - p.delay) / (1.0 - p.delay))
          .clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      final distance = p.speed * adjustedProgress;
      final gravity = 150 * adjustedProgress * adjustedProgress;

      final dx = cos(p.angle) * distance;
      final dy = sin(p.angle) * distance + gravity;

      final opacity = (1.0 - adjustedProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = AppTheme.accentGold.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final position = origin + Offset(dx, dy);

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(p.rotation + p.rotationSpeed * adjustedProgress);

      // Draw coin (circle with highlight)
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.85,
        ),
        paint,
      );

      // Coin highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(-p.size * 0.1, -p.size * 0.1),
          width: p.size * 0.4,
          height: p.size * 0.35,
        ),
        highlightPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CoinParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
