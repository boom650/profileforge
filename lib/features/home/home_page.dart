import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/game/level.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final xpAsync = ref.watch(totalXpProvider(profileId));
    final gemsAsync = ref.watch(gemsProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final missionsAsync = ref.watch(todaysMissionsProvider(profileId));
    final leagueAsync = ref.watch(myLeagueProvider(profileId));
    final standingsAsync = ref.watch(leagueStandingsProvider(profileId));
    final rewardAsync = ref.watch(dailyRewardProvider(profileId));

    final level = LevelEngine();
    final totalXp = xpAsync.valueOrNull ?? 0;
    final lv = level.resolve(totalXp);

    return Scaffold(
      bottomNavigationBar: appBottomNav(context, '/home'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Header: greeting + level + gems.
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi there! 👋',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: theme.hintColor)),
                      const SizedBox(height: 2),
                      Text('Let\'s level up today',
                          style: theme.textTheme.headlineSmall),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SoundService.instance.tap();
                    context.push('/profile');
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Palette.yellow.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.diamond, color: Palette.yellow, size: 18),
                        const SizedBox(width: 4),
                        Text('${gemsAsync.valueOrNull ?? 0}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hero gradient banner: level ring + title + streak.
            GradientBanner(
              from: Palette.green,
              to: Palette.blue,
              child: Row(
                children: [
                  XpRing(
                    progress: lv.levelSpan == 0
                        ? 1
                        : lv.intoLevel / lv.levelSpan,
                    centerTop: '${lv.level}',
                    centerBottom: 'LVL',
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(level.titleFor(lv.level),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text('$totalXp XP total',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥',
                                  style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                  '${streakAsync.valueOrNull?.current ?? 0} day streak',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05),

            const SizedBox(height: 18),

            // Daily reward CTA.
            if (rewardAsync.valueOrNull?.canClaim ?? false)
              GestureDetector(
                onTap: () async {
                  final g = await ref.read(claimDailyRewardProvider(profileId).future);
                  SoundService.instance.coin();
                  celebrate(context, message: '+$g 💎');
                  ref.invalidate(dailyRewardProvider(profileId));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Palette.yellow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Text('🎁', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Day ${rewardAsync.valueOrNull?.day ?? 1} reward waiting!',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ).animate().shake(delay: 600.ms, duration: 500.ms),

            if (rewardAsync.valueOrNull?.canClaim ?? false)
              const SizedBox(height: 18),

            // Today's missions preview.
            SectionTitle('Today\'s missions', action: TextButton(
              onPressed: () => context.push('/missions'),
              child: const Text('See all'),
            )),
            ...missionsAsync.valueOrNull?.take(3).map((m) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: pillarColor(m.pillar).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: pillarColor(m.pillar).withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flag, color: pillarColor(m.pillar)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(m.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: pillarColor(m.pillar),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('+${m.xpReward}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }).toList() ??
                [const Text('Generate your plan to see missions →')],

            const SizedBox(height: 18),

            // League mini card.
            SectionTitle('Your league'),
            Builder(builder: (context) {
              final standings = standingsAsync.valueOrNull ?? [];
              final tierStr = leagueAsync.valueOrNull?.tier ?? 'bronze';
              final tier = LeagueTier.values.firstWhere(
                  (t) => t.name == tierStr,
                  orElse: () => LeagueTier.bronze);
              final rank = standings.indexWhere((m) => m.profileId == profileId) + 1;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tier.tierColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: tier.tierColor),
                ),
                child: Row(
                  children: [
                    Text(tier.tierEmoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tier.tierLabel,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16)),
                          Text(
                              rank > 0
                                  ? '#$rank of ${standings.length}'
                                  : 'Join a league',
                              style: TextStyle(color: theme.hintColor)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/leagues'),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Quick actions grid — new features
            SectionTitle('Quick Actions'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _QuickAction(icon: '⏱️', label: 'Focus Timer', route: '/timer', color: Colors.blue),
                _QuickAction(icon: '📊', label: 'Analytics', route: '/analytics', color: Colors.purple),
                _QuickAction(icon: '🏆', label: 'Achievements', route: '/achievements', color: Colors.amber),
                _QuickAction(icon: '🗺️', label: 'Quests', route: '/quests', color: Colors.green),
                _QuickAction(icon: '🎯', label: 'Goal', route: '/goal', color: Colors.teal),
                _QuickAction(icon: '⚔️', label: 'Challenges', route: '/challenges', color: Colors.orange),
                _QuickAction(icon: '📅', label: 'Summary', route: '/summary', color: Colors.indigo),
                _QuickAction(icon: '📤', label: 'Share', route: '/share', color: Colors.pink),
              ],
            ),
            const SizedBox(height: 24),

            PoppyButton(
              label: 'Generate / refresh my plan',
              onTap: () {
                final onboarding =
                    ref.read(onboardingProvider(profileId)).valueOrNull;
                if (onboarding == null) {
                  context.push('/onboarding');
                  return;
                }
                ref.read(generateMissionsProvider(profileId));
                SoundService.instance.success();
                celebrate(context, message: 'New missions! 🚀');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick action button for the home page feature grid.
class _QuickAction extends StatelessWidget {
  final String icon;
  final String label;
  final String route;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.route, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 90, height: 90,
      child: Material(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}
