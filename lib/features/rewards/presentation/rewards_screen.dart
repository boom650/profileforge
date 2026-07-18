import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/rewards/data/daily_reward_repository.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reward = ref.watch(dailyRewardProvider(profileId));
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;

    final day = reward.valueOrNull?.day ?? 1;
    final canClaim = reward.valueOrNull?.canClaim ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientBanner(
            from: Palette.yellow,
            to: Palette.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎁 Daily reward',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('Come back every day. Day 7 is a jackpot!',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.92), fontSize: 14)),
                const SizedBox(height: 10),
                Text('💎 $gems gems saved',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 7-day wheel.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final d = i + 1;
              final claimed = d < day || (d == day && !canClaim);
              final isToday = d == day && canClaim;
              final rewardAmt = DailyRewardRepository.rewardFor(d);
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isToday
                        ? Palette.yellow
                        : claimed
                            ? Palette.green.withOpacity(0.25)
                            : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isToday ? Palette.orange : theme.dividerColor),
                  ),
                  child: Column(
                    children: [
                      Text(d == 7 ? '🎉' : '$d',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isToday
                                  ? Colors.white
                                  : theme.textTheme.bodyLarge?.color)),
                      const SizedBox(height: 2),
                      Text('$rewardAmt',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isToday
                                  ? Colors.white
                                  : theme.hintColor)),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          if (canClaim)
            PoppyButton(
              label: 'Claim Day $day reward',
              color: Palette.orange,
              onTap: () {
                final g = ref.read(claimDailyRewardProvider(profileId));
                SoundService.instance.coin();
                celebrate(context, message: '+$g 💎');
              },
            ).animate().shake(delay: 300.ms)
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Palette.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16)),
              child: const Center(
                child: Text('✅ Reward claimed today. Come back tomorrow!',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.push('/skins'),
            child: const Text('Spend gems in the Shop →'),
          ),
        ],
      ),
    );
  }
}
