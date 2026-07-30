import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/rewards/data/daily_reward_repository.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final reward = ref.watch(dailyRewardProvider(profileId));
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;
    final day = reward.valueOrNull?.day ?? 1;
    final canClaim = reward.valueOrNull?.canClaim ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('🎁', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Reward',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Palette.textPrimary,
                            ),
                          ),
                          Text(
                            'Come back every day. Day 7 is a jackpot!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Gem counter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.surface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('💎', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '$gems gems saved',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),

          // 7-day wheel
          Text(
            'Streak Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Palette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(7, (i) {
              final d = i + 1;
              final claimed = d < day || (d == day && !canClaim);
              final isToday = d == day && canClaim;
              final rewardAmt = DailyRewardRepository.rewardFor(d);
              final isJackpot = d == 7;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _DayCard(
                    day: d,
                    rewardAmt: rewardAmt,
                    claimed: claimed,
                    isToday: isToday,
                    isJackpot: isJackpot,
                    dark: dark,
                    index: i,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // Claim button or claimed message
          if (canClaim)
            GlassCard(
              padding: const EdgeInsets.all(0),
              border: Palette.accentViolet,
              borderWidth: 2,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    final g = await ref
                        .read(claimDailyRewardProvider(profileId).future);
                    SoundService.instance.coin();
                    celebrate(context, message: '+$g 💎');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Palette.accentViolet, Palette.accentBlue],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Claim Day $day reward',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).then().shimmer(
              duration: 1200.ms,
              color: Colors.white.withValues(alpha: 0.2),
            )
          else
            GlassCard(
              padding: const EdgeInsets.all(20),
              opacity: 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✅', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Reward claimed today. Come back tomorrow!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Shop link
          Center(
            child: GestureDetector(
              onTap: () => context.push('/skins'),
              child: Text(
                'Spend gems in the Shop →',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Palette.accentViolet,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final int day;
  final int rewardAmt;
  final bool claimed;
  final bool isToday;
  final bool isJackpot;
  final bool dark;
  final int index;

  const _DayCard({
    required this.day,
    required this.rewardAmt,
    required this.claimed,
    required this.isToday,
    required this.isJackpot,
    required this.dark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isToday
        ? Palette.accentViolet
        : claimed
            ? Palette.accentViolet.withValues(alpha: 0.12)
            : Palette.surface1;

    final borderColor = isToday
        ? Palette.accentViolet
        : claimed
            ? Palette.accentViolet.withValues(alpha: 0.3)
            : Palette.border;

    final textColor = isToday
        ? Colors.white
        : claimed
            ? Palette.accentViolet
            : Palette.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: Palette.accentViolet.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          if (isJackpot)
            Text('🎉', style: TextStyle(fontSize: 18))
          else
            Text(
              '$day',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: textColor,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            '$rewardAmt',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          if (claimed && !isToday)
            Icon(
              Icons.check_circle,
              size: 12,
              color: Palette.accentViolet.withValues(alpha: 0.6),
            ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 60).ms).scale(
      begin: const Offset(0.8, 0.8),
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}
