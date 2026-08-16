import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/analytics/application/analytics_providers.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  final String profileId;
  const AnalyticsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final snapshotAsync = ref.watch(analyticsSnapshotProvider(profileId));
    final snapshot = snapshotAsync.valueOrNull;
    final tagDataAsync = ref.watch(focusMinutesByTagProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(analyticsSnapshotProvider(profileId));
          ref.invalidate(focusMinutesByTagProvider(profileId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero stat
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Streak flame
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Palette.accentOrange, Palette.error],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.accentOrange.withValues(alpha: 0.3),
                            blurRadius: 16,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: Center(
                      child: const Icon(Icons.local_fire_department_rounded,
                          size: 28, color: Palette.warning),
                    ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${snapshot?.streakDays ?? 0} day streak',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Palette.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            '${snapshot?.focusMinutes ?? 0} min total focus',
                            style: TextStyle(
                              fontSize: 14,
                              color: Palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 16),

              // Stat grid
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.star_rounded, label: 'Total XP',
                      value: '${snapshot?.totalXp ?? 0}',
                      color: Palette.accentYellow,
                          dark: dark, index: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.trending_up_rounded, label: 'Weekly',
                      value: '${snapshot?.weeklyXp ?? 0}',
                      color: Palette.accentTeal,
                          dark: dark, index: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.timer_outlined, label: 'Sessions',
                      value: '${snapshot?.sessions ?? 0}',
                      color: Palette.accentBlue,
                          dark: dark, index: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.calendar_today_rounded, label: 'Focus',
                      value: '${snapshot?.focusMinutes ?? 0} min',
                      color: Palette.accentViolet,
                          dark: dark, index: 3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Subject pie chart
              Text(
                'Study by Subject',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Palette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              tagDataAsync.when(
                data: (tagData) {
                  if (tagData.isEmpty) {
                    return GlassCard(
                      padding: const EdgeInsets.all(24),
                      opacity: 0.04,
                      child: Center(
                        child: Column(
                          children: [
                            Text('📊', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'Complete focus sessions to see your breakdown',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Palette.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final total = tagData.values.fold(0, (a, b) => a + b);
                  final chartColors = [
                    Palette.accentBlue,
                    Palette.accentViolet,
                    Palette.accentTeal,
                    Palette.accentOrange,
                    Palette.accentYellow,
                    Palette.accentPink,
                    Palette.accentCyan,
                    Palette.success,
                  ];

                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: tagData.entries.toList().asMap().entries.map((e) {
                                  final i = e.key;
                                  final entry = e.value;
                                  final pct = (entry.value / total * 100).toStringAsFixed(0);
                                  return PieChartSectionData(
                                    value: entry.value.toDouble(),
                                    color: chartColors[i % chartColors.length],
                                    title: '$pct%',
                                    radius: 48,
                                    titleStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 3,
                                centerSpaceRadius: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tagData.entries.toList().asMap().entries.map((e) {
                              final i = e.key;
                              final entry = e.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: chartColors[i % chartColors.length],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${entry.key} (${entry.value}m)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Palette.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (e, _) => GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $e',
                      style: TextStyle(color: Palette.error)),
                ),
              ),

              const SizedBox(height: 28),

              // XP history bar chart
              _XpHistorySection(profileId: profileId, dark: dark),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool dark;
  final int index;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.dark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Palette.textMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideY(
      begin: 0.15,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _XpHistorySection extends ConsumerWidget {
  final String profileId;
  final bool dark;
  const _XpHistorySection({required this.profileId, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpRepo = ref.watch(xpRepositoryProvider);
    return FutureBuilder(
      future: xpRepo.history(profileId),
      builder: (ctx, snap) {
        if (!snap.hasData || snap.data!.isEmpty) return const SizedBox.shrink();
        final events = snap.data!;

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
            Text(
              'XP History (7 days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Palette.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxVal > 0 ? maxVal * 1.2 : 50,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= entries.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                entries[idx].key,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Palette.textMuted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: entries.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.value.toDouble().clamp(1, double.infinity),
                            width: 18,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Palette.accentViolet,
                                Palette.accentBlue,
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ],
        );
      },
    );
  }
}
