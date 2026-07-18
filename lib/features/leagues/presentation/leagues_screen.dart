import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';

class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(myLeagueProvider(profileId));
    final standings = ref.watch(leagueStandingsProvider(profileId));
    final tier = me.whenData((m) => m == null ? LeagueTier.bronze : _tierOf(m.tier)).value ?? LeagueTier.bronze;
    final weeklyXp = me.whenData((m) => m?.weeklyXp ?? 0).value ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Current league: ${tier.label}, $weeklyXp XP this week',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tier.label,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (tier.promotionThreshold == 999999)
                            ? 1.0
                            : (weeklyXp / tier.promotionThreshold)
                                .clamp(0.0, 1.0),
                      ),
                      const SizedBox(height: 4),
                      Text(tier.promoteTo == null
                          ? 'Top tier — defend your rank!'
                          : 'Next tier at ${tier.promotionThreshold} weekly XP'),
                      if (me.whenData((m) => m?.shielded ?? false).value == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('🛡 Shield active — protected from demotion'),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: standings.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (rows) => ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final isMe = r.profileId == profileId;
                    return Semantics(
                      label: 'Rank ${i + 1}, ${r.weeklyXp} XP${isMe ? ", you" : ""}',
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(isMe ? 'You' : r.profileId),
                        trailing: Text('${r.weeklyXp} XP'),
                        tileColor: isMe ? Theme.of(context).colorScheme.primaryContainer : null,
                      ),
                    ).animate().fadeIn(delay: (i * 30).ms);
                  },
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () async {
                final res = await ref.read(seasonResetProvider(profileId));
                if (res != null && context.mounted) {
                  final msg = res.promoted
                      ? 'Promoted to ${res.tier.promoteTo?.label}!'
                      : res.demoted
                          ? 'Demoted to ${res.tier.demoteTo?.label}.'
                          : res.shielded
                              ? 'Shield absorbed a demotion!'
                              : 'Held rank in ${res.tier.label}.';
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Resolve week'),
            ),
          ],
        ),
      ),
    );
  }
}

LeagueTier _tierOf(String s) =>
    LeagueTier.values.firstWhere((t) => t.name == s, orElse: () => LeagueTier.bronze);
