import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(todaysMissionsProvider(profileId));
    return Scaffold(
      appBar: AppBar(title: const Text('Missions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(generateMissionsProvider(profileId)),
        tooltip: 'Generate daily missions',
        child: const Icon(Icons.auto_awesome),
      ),
      body: missions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rows) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rows.length,
          itemBuilder: (context, i) {
            final m = rows[i];
            return Dismissible(
              key: Key(m.id),
              onDismissed: (_) => ref.read(completeMissionProvider((
                profileId: profileId,
                missionId: m.id,
              ))),
              child: Semantics(
                label: '${m.title}, ${m.pillar} mission, ${m.xpReward} XP',
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.flag),
                    title: Text(m.title),
                    subtitle: Text('${m.pillar} · ${m.xpReward} XP'),
                    trailing: const Icon(Icons.check_circle_outline),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: (i * 30).ms).slideX(begin: 0.1);
          },
        ),
      ),
    );
  }
}
