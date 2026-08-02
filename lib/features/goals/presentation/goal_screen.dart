import 'package:flutter/material.dart';
import ../../../core/effects/shimmer_skeleton.dart;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/tap_scale.dart';
import 'package:profileforge/features/goals/application/goal_providers.dart';

/// Goal selection screen — premium card-based selection with haptic feedback.
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

  static const _goalGradients = [
    [Color(0xFF3B82F6), Color(0xFF60A5FA)],  // Blue
    [Color(0xFFF59E0B), Color(0xFFFBBF24)],  // Amber
    [Color(0xFF8B5CF6), Color(0xFFA78BFA)],  // Violet
    [Color(0xFF10B981), Color(0xFF34D399)],  // Emerald
    [Color(0xFFEF4444), Color(0xFFF87171)],  // Red
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAsync = ref.watch(primaryGoalProvider(profileId));
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'My Goal',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: currentAsync.when(
        data: (current) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'What brings you here?',
                style: TextStyle(
                  color: Palette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 8),
              Text(
                'Choose your primary focus — this helps us personalize your experience.',
                style: TextStyle(
                  color: Palette.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: 28),

              // Goal cards
              ...List.generate(goals.length, (i) {
                final g = goals[i];
                final id = g.$1;
                final icon = g.$2;
                final title = g.$3;
                final desc = g.$4;
                final selected = current == id;
                final gradient = _goalGradients[i];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TapScale(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      ref.read(setPrimaryGoalProvider((profileId: profileId, goal: id)).future);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? LinearGradient(
                                colors: gradient.map((c) => c.withValues(alpha: 0.2)).toList(),
                              )
                            : null,
                        color: selected ? null : (dark ? Palette.surface1 : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? gradient[0] : Palette.border.withValues(alpha: 0.3),
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: gradient[0].withValues(alpha: 0.2),
                                  blurRadius: 16,
                                  spreadRadius: -4,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: selected
                                  ? gradient[0].withValues(alpha: 0.2)
                                  : Palette.surface2,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(icon, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
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
                                    color: selected ? gradient[0] : Palette.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  desc,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Palette.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: selected
                                ? Container(
                                    key: const ValueKey('selected'),
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: gradient[0],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                                  )
                                : Container(
                                    key: const ValueKey('unselected'),
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Palette.surface2,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.circle_outlined, color: Palette.textTertiary, size: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: 150 + i * 60), duration: 300.ms)
                   .slideX(begin: 0.08),
                );
              }),
            ],
          ),
        ),
        loading: () => const Center(child: ShimmerLoader.missions()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Palette.error, size: 48),
              const SizedBox(height: 12),
              Text('Error: $e', style: TextStyle(color: Palette.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
