import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/goals/application/goal_providers.dart';

class GoalScreen extends ConsumerWidget {
  final String profileId;
  const GoalScreen({super.key, required this.profileId});

  static const goals = [
    ('exam_prep', '🎯', 'Exam Preparation', 'Prepare for upcoming exams with targeted study plans'),
    ('competition', '🏆', 'Competition Prep', 'Train for academic competitions and Olympiads'),
    ('general', '📚', 'General Learning', 'Broad knowledge building across subjects'),
    ('skill_building', '🛠️', 'Skill Building', 'Develop specific skills (coding, writing, etc.)'),
    ('college_apps', '🎓', 'College Applications', 'Build your profile for university admissions'),
  ];

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
            ...goals.map((g) {
              final id = g.$1;
              final icon = g.$2;
              final title = g.$3;
              final desc = g.$4;
              final selected = current == id;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(icon, style: const TextStyle(fontSize: 28)),
                  title: Text(title, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.w500)),
                  subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
                  trailing: selected ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : const Icon(Icons.circle_outlined),
                  selected: selected,
                  onTap: () => ref.read(setPrimaryGoalProvider((profileId: profileId, goal: id)).future),
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
