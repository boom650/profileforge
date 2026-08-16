import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/goals/application/goal_providers.dart';
import 'package:profileforge/features/goals/domain/goal_models.dart';

class GoalScreen extends ConsumerWidget {
  final String profileId;
  const GoalScreen({super.key, required this.profileId});

  static const _goalIcons = {
    'exam_prep': Icons.flag_rounded,
    'competition': Icons.emoji_events_rounded,
    'general': Icons.menu_book_rounded,
    'skill_building': Icons.build_rounded,
    'college_apps': Icons.school_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAsync = ref.watch(primaryGoalProvider(profileId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Goal'), centerTitle: true),
      body: currentAsync.when(
        data: (current) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('What brings you here?', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Choose your primary focus — this helps us personalize your missions.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            ...GoalOption.all.map((g) {
              final icon = _goalIcons[g.id] ?? Icons.menu_book_rounded;
              final selected = current == g.id;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(icon, size: 28, color: theme.colorScheme.primary),
                  title: Text(g.title, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.w500)),
                  subtitle: Text(g.description, style: const TextStyle(fontSize: 12)),
                  trailing: selected ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : const Icon(Icons.circle_outlined),
                  selected: selected,
                  onTap: () => ref.read(setPrimaryGoalProvider((profileId: profileId, goal: g.id)).future),
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1);
            }),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
