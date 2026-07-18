import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/buddy/application/buddy_providers.dart';

class BuddiesScreen extends ConsumerWidget {
  const BuddiesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buddies = ref.watch(buddiesProvider(profileId));
    final nudge = ref.watch(buddyMotivationProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Buddies')),
      body: Column(
        children: [
          if (nudge.value != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Chip(
                avatar: const Icon(Icons.notifications_active),
                label: Text(nudge.value!),
              ).animate().shake(),
            ),
          Expanded(
            child: buddies.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final b = list[i];
                  return Semantics(
                    label: 'Buddy ${b.buddyId}',
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(b.buddyId),
                      subtitle: Text('Goal: ${b.sharedStreakGoal}-day shared streak'),
                      trailing: FilledButton(
                        onPressed: () => ref.read(checkInProvider((
                          from: profileId,
                          to: b.buddyId,
                          xp: 10,
                          note: 'Keep going!',
                        ))),
                        child: const Text('Check in'),
                      ),
                    ),
                  ).animate().fadeIn(delay: (i * 40).ms);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
