import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/quests/application/quest_providers.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/audio/sound_provider.dart';

class QuestsScreen extends ConsumerWidget {
  final String profileId;
  const QuestsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(generateQuestsProvider(profileId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Quests'), centerTitle: true),
      body: questsAsync.when(
        data: (quests) {
          final done = quests.where((q) => q.done).length;
          return Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.colorScheme.secondary, theme.colorScheme.tertiary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('🗺️', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Challenges', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('$done / ${quests.length} completed', style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const Spacer(),
                    Text('${quests.length - done} left', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: quests.length,
                  itemBuilder: (ctx, i) {
                    final q = quests[i];
                    return _QuestTile(quest: q, profileId: profileId).animate().fadeIn(duration: 300.ms, delay: (100 * i).ms).slideX(begin: -0.2);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _QuestTile extends ConsumerWidget {
  final DailyQuestRow quest;
  final String profileId;
  const _QuestTile({required this.quest, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: quest.done ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: quest.done ? const Icon(Icons.check_circle, color: Colors.green, size: 28) : const Text('🗺️', style: TextStyle(fontSize: 24))),
        ),
        title: Text(quest.title, style: TextStyle(fontWeight: FontWeight.w600, decoration: quest.done ? TextDecoration.lineThrough : null)),
        subtitle: quest.description.isNotEmpty ? Text(quest.description, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        trailing: quest.done
            ? Icon(Icons.check, color: Colors.green.shade400)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('+${quest.xpReward}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  PoppyButton(label: 'Go', compact: true, onPressed: () async {
                    await ref.read(completeQuestProvider(
                      (profileId: profileId, questId: quest.id, xp: quest.xpReward),
                    ).future);
                    showXpPopup(context, quest.xpReward);
                    ref.read(soundServiceProvider).success();
                  }),
                ],
              ),
      ),
    );
  }
}
