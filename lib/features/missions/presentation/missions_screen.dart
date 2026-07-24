import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final daily = ref.watch(todaysMissionsProvider(profileId));
    final weekly = ref.watch(weeklyMissionsProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Missions')),
      bottomNavigationBar: appBottomNav(context, '/missions'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientBanner(
            from: Palette.blue,
            to: Palette.purple,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎯 Your daily quests',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                    'Complete missions to earn XP and gems. They\'re generated from your profile.',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    final ob =
                        ref.read(onboardingProvider(profileId)).valueOrNull;
                    if (ob == null) {
                      context.push('/onboarding');
                      return;
                    }
                    ref.read(generateMissionsProvider(profileId));
                    SoundService.instance.success();
                    celebrate(context, message: 'Refreshed! 🚀');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Generate / refresh plan'),
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Palette.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionTitle('Today'),
          ...daily.when(
            data: (rows) => rows.isEmpty
                ? [const Text('No missions yet — tap Generate above.')]
                : rows
                    .map((m) => _MissionTile(
                          key: ValueKey(m.id),
                          title: m.title,
                          pillar: m.pillar,
                          xp: m.xpReward,
                          onDone: () async {
                            SoundService.instance.success();
                            await ref.read(completeMissionProvider((
                              profileId: profileId,
                              missionId: m.id,
                              xp: m.xpReward,
                              pillar: m.pillar,
                            )));
                            celebrate(context, message: '+$m.xpReward XP 🎉');
                          },
                        ))
                    .toList(),
            loading: () => const [CircularProgressIndicator()],
            error: (e, _) => [Text('Error: $e')],
          ),
          const SizedBox(height: 18),
          SectionTitle('This week'),
          ...weekly.when(
            data: (rows) => rows.isEmpty
                ? [const Text('No weekly missions yet.')]
                : rows
                    .map((m) => _MissionTile(
                          key: ValueKey(m.id),
                          title: m.title,
                          pillar: m.pillar,
                          xp: m.xpReward,
                          onDone: () async {
                            SoundService.instance.success();
                            await ref.read(completeMissionProvider((
                              profileId: profileId,
                              missionId: m.id,
                              xp: m.xpReward,
                              pillar: m.pillar,
                            )));
                            celebrate(context, message: '+$m.xpReward XP 🎉');
                          },
                        ))
                    .toList(),
            loading: () => const [CircularProgressIndicator()],
            error: (e, _) => [Text('Error: $e')],
          ),
        ],
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile(
      {super.key,
      required this.title,
      required this.pillar,
      required this.xp,
      required this.onDone});
  final String title;
  final String pillar;
  final int xp;
  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    final c = pillarColor(pillar);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.flag, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                PillarChip(pillar),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c, borderRadius: BorderRadius.circular(8)),
                child: Text('+$xp',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12)),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: onDone,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.check, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.04);
  }
}
