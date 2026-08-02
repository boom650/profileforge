import 'package:flutter/material.dart';
import '../../../core/effects/shimmer_skeleton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/tap_scale.dart';
import '../application/quest_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Quests screen — Premium quest cards with progress tracking.
/// ────────────────────────────────────────────────────────────────────────────
class QuestsScreen extends ConsumerWidget {
  final String profileId;
  const QuestsScreen({super.key, required this.profileId});

  static const _questIcons = {
    'daily': Icons.wb_sunny,
    'weekly': Icons.date_range,
    'special': Icons.auto_awesome,
    'milestone': Icons.emoji_events,
  };

  static const _questColors = {
    'daily': Palette.primary,
    'weekly': Palette.accent,
    'special': Palette.info,
    'milestone': Palette.warning,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(questListProvider(profileId));
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'Quests',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: questsAsync.when(
        data: (quests) {
          if (quests.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.task_outlined, color: Palette.textTertiary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No quests available',
                    style: TextStyle(color: Palette.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete onboarding to unlock quests',
                    style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          // Group quests by type
          final grouped = <String, List<dynamic>>{};
          for (final q in quests) {
            final type = q.questType ?? 'daily';
            grouped.putIfAbsent(type, () => []).add(q);
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Text(
                'Complete quests to earn XP and level up',
                style: TextStyle(color: Palette.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Quest groups
              ...grouped.entries.map((entry) {
                final type = entry.key;
                final items = entry.value;
                final color = _questColors[type] ?? Palette.primary;
                final icon = _questIcons[type] ?? Icons.task;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          type.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: color.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...items.map((q) {
                      final progress = q.progress ?? 0;
                      final target = q.targetCount ?? 1;
                      final pct = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
                      final completed = pct >= 1.0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TapScale(
                          onTap: () => HapticFeedback.selectionClick(),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: completed
                                            ? Palette.success.withValues(alpha: 0.15)
                                            : color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        completed ? Icons.check : icon,
                                        color: completed ? Palette.success : color,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            q.title ?? 'Quest',
                                            style: TextStyle(
                                              color: Palette.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (q.description?.isNotEmpty == true)
                                            Text(
                                              q.description!,
                                              style: TextStyle(
                                                color: Palette.textSecondary,
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Palette.accent.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '+${q.xpReward ?? 0} XP',
                                        style: const TextStyle(
                                          color: Palette.accent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Progress bar
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: pct,
                                          minHeight: 6,
                                          backgroundColor: Palette.surface2,
                                          valueColor: AlwaysStoppedAnimation(
                                            completed ? Palette.success : color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$progress/$target',
                                      style: TextStyle(
                                        color: completed ? Palette.success : Palette.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 200.ms),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          );
        },
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
      ),
    );
  }
}
