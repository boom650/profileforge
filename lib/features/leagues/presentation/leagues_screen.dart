import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';

class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final me = ref.watch(myLeagueProvider(profileId));
    final standings = ref.watch(leagueStandingsProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      bottomNavigationBar: appBottomNav(context, '/leagues'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tier ladder.
          SectionTitle('Climb the ladder'),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: LeagueTier.values.length,
              separatorBuilder: (_, __) =>
                  const Icon(Icons.chevron_right, color: Colors.grey),
              itemBuilder: (_, i) {
                final t = LeagueTier.values[i];
                final isMe = me.valueOrNull?.tier == t.name;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isMe ? t.tierColor : t.tierColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: t.tierColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.tierEmoji, style: const TextStyle(fontSize: 22)),
                      Text(t.tierLabel,
                          style: TextStyle(
                              color: isMe ? Colors.white : t.tierColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          GradientBanner(
            from: Palette.purple,
            to: Palette.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🏆 This week\'s standings',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                    'Top 10% get promoted, bottom 10% drop a tier. Shields save you from demotion.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...standings.when(
            data: (rows) {
              final sorted = [...rows]
                ..sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));
              return sorted.asMap().entries.map((e) {
                final i = e.key;
                final m = e.value;
                final isMe = m.profileId == profileId;
                final medal = i == 0
                    ? '🥇'
                    : i == 1
                        ? '🥈'
                        : i == 2
                            ? '🥉'
                            : '${i + 1}.';
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Palette.green.withOpacity(0.18)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: isMe
                        ? Border.all(color: Palette.green, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 30,
                          child: Text(medal,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 16))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isMe ? 'You' : m.profileId,
                          style: TextStyle(
                              fontWeight: isMe
                                  ? FontWeight.w900
                                  : FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Palette.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${m.weeklyXp} XP',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (i * 30).ms);
              }).toList();
            },
            loading: () => const [CircularProgressIndicator()],
            error: (e, _) => [Text('Error: $e')],
          ),
          const SizedBox(height: 16),
          PoppyButton(
            label: 'Resolve week & claim result',
            color: Palette.purple,
            onTap: () async {
              final res =
                  await ref.read(seasonResetProvider(profileId));
              SoundService.instance.levelUp();
              if (res != null) {
                final msg = res.promoted
                    ? 'Promoted! ⬆️'
                    : res.demoted
                        ? 'Demoted ⬇️'
                        : res.shielded
                            ? 'Saved by shield 🛡️'
                            : 'Stayed put';
                celebrate(context, message: msg);
              }
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.push('/buddies'),
            child: const Text('Invite buddies to join your league →'),
          ),
        ],
      ),
    );
  }
}
