import 'package:flutter/material.dart';
import 'package:profileforge/core/effects/shimmer_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';

class AchievementsScreen extends ConsumerWidget {
  final String profileId;
  const AchievementsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defsAsync = ref.watch(achievementDefsProvider);
    final unlockedAsync = ref.watch(unlockedAchievementIdsProvider(profileId));
    final countAsync = ref.watch(achievementCountProvider(profileId));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
        backgroundColor: Palette.surface1,
      ),
      body: SafeArea(
        child: defsAsync.when(
        data: (defs) => unlockedAsync.when(
          data: (unlocked) {
            final total = defs.length;
            final done = unlocked.length;
            final percent = total > 0 ? done / total : 0.0;

            return Column(
              children: [
                // Progress header
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text('$done / $total', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Badges Collected', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 10,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),

                // Badge grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: defs.length,
                    itemBuilder: (ctx, i) {
                      final def = defs[i];
                      final isUnlocked = unlocked.contains(def.id);
                      return _BadgeCard(def: def, unlocked: isUnlocked, theme: theme, index: i);
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: ShimmerLoader.card()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: ShimmerLoader.card()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final AchievementDef def;
  final bool unlocked;
  final ThemeData theme;
  final int index;
  const _BadgeCard({required this.def, required this.unlocked, required this.theme, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: unlocked ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: unlocked ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unlocked ? def.icon : '❓', style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              def.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
                color: unlocked ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!unlocked)
            Text('${def.criteriaValue} ${def.criteriaType.replaceAll('_', ' ')}',
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    ).animate().scale(
      duration: 300.ms,
      delay: (50 * index).ms,
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
    );
  }
}
