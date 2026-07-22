import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  final String profileId;
  const AnalyticsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalXpAsync = ref.watch(totalXpProvider(profileId));
    final weeklyXpAsync = ref.watch(weeklyXpProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final focusMinAsync = ref.watch(totalFocusMinutesProvider(profileId));
    final todayFocusAsync = ref.watch(todayFocusMinutesProvider(profileId));
    final sessionsAsync = ref.watch(focusSessionCountProvider(profileId));
    final tagDataAsync = ref.watch(focusMinutesByTagProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(totalXpProvider(profileId));
          ref.invalidate(weeklyXpProvider(profileId));
          ref.invalidate(streakProvider(profileId));
          ref.invalidate(totalFocusMinutesProvider(profileId));
          ref.invalidate(todayFocusMinutesProvider(profileId));
          ref.invalidate(focusSessionCountProvider(profileId));
          ref.invalidate(focusMinutesByTagProvider(profileId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards row
              Row(
                children: [
                  Expanded(child: _StatCard(
                    icon: '⭐', label: 'Total XP',
                    value: totalXpAsync.valueOrNull?.toString() ?? '...',
                    color: Colors.amber,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _StatCard(
                    icon: '📈', label: 'Weekly XP',
                    value: weeklyXpAsync.valueOrNull?.toString() ?? '...',
                    color: Colors.green,
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _StatCard(
                    icon: '🔥', label: 'Streak',
                    value: '${streakAsync.valueOrNull?.current ?? 0} days',
                    color: Colors.orange,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _StatCard(
                    icon: '⏱️', label: 'Sessions',
                    value: sessionsAsync.valueOrNull?.toString() ?? '...',
                    color: Colors.blue,
                  )),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _StatCard(
                    icon: '⌛', label: 'Total Focus',
                    value: '${focusMinAsync.valueOrNull ?? 0} min',
                    color: Colors.purple,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _StatCard(
                    icon: '📅', label: 'Today',
                    value: '${todayFocusAsync.valueOrNull ?? 0} min',
                    color: Colors.teal,
                  )),
                ],
              ),
              const SizedBox(height: 24),

              // Pie chart — subject breakdown
              Text('Study by Subject', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              tagDataAsync.when(
                data: (tagData) {
                  if (tagData.isEmpty) return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: Text('Complete focus sessions to see your subject breakdown!',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                    ),
                  );
                  final total = tagData.values.fold(0, (a, b) => a + b);
                  final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.indigo];
                  return SizedBox(
                    height: 220,
                    child: Row(
                      children: [
                        Expanded(
                          child: PieChart(PieChartData(
                            sections: tagData.entries.toList().asMap().entries.map((e) {
                              final i = e.key;
                              final entry = e.value;
                              final pct = (entry.value / total * 100).toStringAsFixed(0);
                              return PieChartSectionData(
                                value: entry.value.toDouble(),
                                color: colors[i % colors.length],
                                title: '$pct%',
                                radius: 50,
                                titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                          )),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tagData.entries.toList().asMap().entries.map((e) {
                            final i = e.key;
                            final entry = e.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(3))),
                                  const SizedBox(width: 6),
                                  Text('${entry.key} (${entry.value}m)', style: const TextStyle(fontSize: 11)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),

              // XP History section
              _XpHistorySection(profileId: profileId, theme: theme),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2);
  }
}

class _XpHistorySection extends ConsumerWidget {
  final String profileId;
  final ThemeData theme;
  const _XpHistorySection({required this.profileId, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpRepo = ref.watch(xpRepositoryProvider);
    return FutureBuilder(
      future: xpRepo.history(profileId),
      builder: (ctx, snap) {
        if (!snap.hasData || snap.data!.isEmpty) return const SizedBox.shrink();
        final events = snap.data!;
        // Group by day for last 7 days
        final now = DateTime.now();
        final dayMap = <String, int>{};
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i));
          dayMap['${d.month}/${d.day}'] = 0;
        }
        for (final e in events) {
          final key = '${e.at.month}/${e.at.day}';
          if (dayMap.containsKey(key)) {
            dayMap[key] = (dayMap[key] ?? 0) + e.amount;
          }
        }
        final entries = dayMap.entries.toList();
        final maxVal = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('XP History (7 days)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal > 0 ? maxVal * 1.2 : 50,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= entries.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(entries[idx].key, style: const TextStyle(fontSize: 10)),
                      );
                    },
                  )),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: entries.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [BarChartRodData(
                      toY: e.value.value.toDouble().clamp(1, double.infinity),
                      color: theme.colorScheme.primary,
                      width: 20,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    )],
                  );
                }).toList(),
              )),
            ),
          ],
        );
      },
    );
  }
}
