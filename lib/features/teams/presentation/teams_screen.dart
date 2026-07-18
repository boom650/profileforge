import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/teams/application/team_providers.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(teamLeaderboardProvider(profileId));
    final challenges = ref.watch(teamChallengesProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => ref.read(createTeamProvider((
                    id: 't-${DateTime.now().millisecondsSinceEpoch}',
                    name: 'Study Squad',
                    owner: profileId,
                  ))),
                  icon: const Icon(Icons.add),
                  label: const Text('Create team'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => ref.read(joinTeamProvider((
                    teamId: 't-demo',
                    profileId: profileId,
                  ))),
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join team'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: board.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (members) => ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, i) => Semantics(
                    label: 'Rank ${i + 1}: ${members[i]}',
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${i + 1}')),
                      title: Text(members[i]),
                    ),
                  ).animate().fadeIn(delay: (i * 40).ms),
                ),
              ),
            ),
            challenges.when(
              data: (cs) => Column(
                children: cs
                    .map((c) => LinearProgressIndicator(
                          value: c.goalXp == 0 ? 0 : c.currentXp / c.goalXp,
                        ))
                    .toList(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper provider to read a team's challenges (uses a demo team id for now).
final teamChallengesProvider =
    FutureProvider.family<List<dynamic>, String>((ref, teamId) async {
  // TODO: resolve actual team id from membership. Returns empty until wired.
  return ref.watch(teamRepositoryProvider).challenges(teamId);
});
