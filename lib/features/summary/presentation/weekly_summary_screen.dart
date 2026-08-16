import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/summary/application/weekly_summary_providers.dart';
import 'package:profileforge/core/theme/app_theme.dart';

class WeeklySummaryScreen extends ConsumerWidget {
  final String profileId;
  const WeeklySummaryScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(weeklySummaryProvider(profileId));
    final summary = summaryAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklySummaryProvider(profileId));
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
                    const Icon(Icons.insights_rounded,
                        size: 48, color: Colors.white),
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
                          _StatItem(icon: Icons.star_rounded, value: summary?.weeklyXp.toString() ?? '0', label: 'XP This Week', color: Palette.warning),
                          const SizedBox(width: 16),
                          _StatItem(icon: Icons.local_fire_department_rounded, value: '${summary?.dayStreak ?? 0}', label: 'Day Streak', color: Palette.accent),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatItem(icon: Icons.timer_outlined, value: '${summary?.focusMinutes ?? 0}m', label: 'Focus Time', color: Palette.accentViolet),
                          const SizedBox(width: 16),
                          _StatItem(icon: Icons.flag_rounded, value: '${summary?.focusSessions ?? 0}', label: 'Sessions Done', color: Palette.accentBlue),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _StatItem(icon: Icons.emoji_events_rounded, value: '${summary?.badges ?? 0}', label: 'Badges Earned', color: Palette.success),
                          const SizedBox(width: 16),
                          _StatItem(icon: Icons.trending_up_rounded, value: '${summary?.totalXp ?? 0}', label: 'Total XP', color: Palette.accentTeal),
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
                    const Icon(Icons.fitness_center_rounded,
                        size: 32, color: Palette.primary),
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
  final IconData icon;
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
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
