import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/quests/application/quest_providers.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';

class WeeklySummaryScreen extends ConsumerWidget {
  final String profileId;
  const WeeklySummaryScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyXpAsync = ref.watch(weeklyXpProvider(profileId));
    final totalXpAsync = ref.watch(totalXpProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final focusMinAsync = ref.watch(totalFocusMinutesProvider(profileId));
    final sessionsAsync = ref.watch(focusSessionCountProvider(profileId));
    final achCountAsync = ref.watch(achievementCountProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklyXpProvider(profileId));
          ref.invalidate(totalXpProvider(profileId));
          ref.invalidate(totalFocusMinutesProvider(profileId));
          ref.invalidate(focusSessionCountProvider(profileId));
          ref.invalidate(achievementCountProvider(profileId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hero section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text('Your Week in Review', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Keep up the great momentum!', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 16),

              // This week's achievements
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _StatItem(icon: '⭐', value: weeklyXpAsync.valueOrNull?.toString() ?? '0', label: 'XP This Week', color: Colors.amber),
                          const SizedBox(width: 16),
                          _StatItem(icon: '🔥', value: '${streakAsync.valueOrNull?.current ?? 0}', label: 'Day Streak', color: Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatItem(icon: '⌛', value: '${focusMinAsync.valueOrNull ?? 0}m', label: 'Focus Time', color: Colors.purple),
                          const SizedBox(width: 16),
                          _StatItem(icon: '🎯', value: '${sessionsAsync.valueOrNull ?? 0}', label: 'Sessions Done', color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatItem(icon: '🏆', value: '${achCountAsync.valueOrNull ?? 0}', label: 'Badges Earned', color: Colors.green),
                          const SizedBox(width: 16),
                          _StatItem(icon: '📈', value: '${totalXpAsync.valueOrNull ?? 0}', label: 'Total XP', color: Colors.teal),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

              const SizedBox(height: 16),

              // Motivational message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('💪', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Remember:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Every minute of focus adds up. Consistency beats intensity — keep showing up every day!',
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 400.ms),

              const SizedBox(height: 32),

              // Share button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share card feature coming soon!')));
                  },
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share Your Progress'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  const _StatItem({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
