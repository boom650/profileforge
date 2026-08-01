import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
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
    final dark = isDark(context);

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
              return GestureDetector(
                onTap: () => ref.read(setPrimaryGoalProvider((profileId: profileId, goal: id)).future),
                child: AnimatedContainer(
                  duration: 300.ms,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: selected ? Palette.gradientPrimary : null,
                    color: selected ? null : (dark ? Palette.surface1 : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? Palette.primary : (dark ? Palette.border : const Color(0xFFE2E8F0)),
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: selected ? [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.2),
                        blurRadius: 16,
                        spreadRadius: -4,
                      ),
                    ] : null,
                  ),
                  child: Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: selected ? Colors.white : Palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? Colors.white70 : Palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selected ? Icons.check_circle : Icons.circle_outlined,
                        color: selected ? Colors.white : Palette.textTertiary,
                        size: 24,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
              );
            }),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
