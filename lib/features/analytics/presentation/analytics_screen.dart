import 'package:flutter/material.dart';
import package:profileforge/core/effects/shimmer_skeleton.dart;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  final String profileId;
  const AnalyticsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final totalXpAsync = ref.watch(totalXpProvider(profileId));
    final weeklyXpAsync = ref.watch(weeklyXpProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final focusMinAsync = ref.watch(totalFocusMinutesProvider(profileId));
    final todayFocusAsync = ref.watch(todayFocusMinutesProvider(profileId));
    final sessionsAsync = ref.watch(focusSessionCountProvider(profileId));
    final tagDataAsync = ref.watch(focusMinutesByTagProvider(profileId));

    // Check overall loading state
    final isLoading = totalXpAsync is AsyncLoading ||
        weeklyXpAsync is AsyncLoading ||
        streakAsync is AsyncLoading ||
        focusMinAsync is AsyncLoading;

    // Check for errors across critical providers
    final hasError = totalXpAsync is AsyncError ||
        weeklyXpAsync is AsyncError ||
        streakAsync is AsyncError ||
        focusMinAsync is AsyncError;

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        title: const Text('Analytics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const _AnalyticsSkeleton()
          : hasError
              ? _AnalyticsError(
                  onRetry: () {
                    ref.invalidate(totalXpProvider(profileId));
                    ref.invalidate(weeklyXpProvider(profileId));
                    ref.invalidate(streakProvider(profileId));
                    ref.invalidate(totalFocusMinutesProvider(profileId));
                    ref.invalidate(todayFocusMinutesProvider(profileId));
                    ref.invalidate(focusSessionCountProvider(profileId));
                    ref.invalidate(focusMinutesByTagProvider(profileId));
                  },
                )
              : RefreshIndicator(
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
                                  gradient: const LinearGradient(
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
                                child: const Center(
                                  child: Text('🔥', style: TextStyle(fontSize: 28)),
                                ),
                              ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${streakAsync.valueOrNull?.current ?? 0} day streak',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Palette.textPrimary,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Text(
                                      '${focusMinAsync.valueOrNull ?? 0} min total focus',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Palette.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Weekly trend indicator
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Palette.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.trending_up_rounded, size: 16, color: Palette.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${weeklyXpAsync.valueOrNull ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Palette.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(delay: 300.ms),
                            ],
                          ),
                        ).animate().fadeIn().slideY(begin: 0.1),

                        const SizedBox(height: 16),
                        // Stat grid
                        Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                icon: '⭐', label: 'Total XP',
                                value: '${totalXpAsync.valueOrNull ?? 0}',
                                color: Palette.accentYellow,
                                    dark: dark, index: 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatTile(
                                icon: '📈', label: 'Weekly',
                                value: '${weeklyXpAsync.valueOrNull ?? 0}',
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
                                icon: '⏱️', label: 'Sessions',
                                value: '${sessionsAsync.valueOrNull ?? 0}',
                                color: Palette.accentBlue,
                                    dark: dark, index: 2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatTile(
                                icon: '📅', label: 'Today',
                                value: '${todayFocusAsync.valueOrNull ?? 0} min',
                                color: Palette.accentViolet,
                                    dark: dark, index: 3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Subject pie chart
                        const Text(
                          'Study by Subject',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
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
                                      const Text('📊', style: TextStyle(fontSize: 40)),
                                      const SizedBox(height: 12),
                                      const Text(
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
                                                style: const TextStyle(
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
                              child: ShimmerLoader.card(),
                            ),
                          ),
                          error: (e, _) => GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Text('Error: $e',
                                style: const TextStyle(color: Palette.error)),
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

/// Shimmer loading skeleton for analytics screen.
class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero stat skeleton
            Container(
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            // Stat grid skeleton
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Chart section skeleton
            Container(
              width: 160,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 232,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state with retry for analytics screen.
class _AnalyticsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _AnalyticsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Palette.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bar_chart_rounded, size: 32, color: Palette.error),
            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text(
              'Failed to load analytics',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Could not fetch your study data.\nCheck your connection and try again.',
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
      ),
    );
  }
}

class _StatTile extends StatefulWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final bool dark;
  final int index;

  const _StatTile({required this.icon, required this.label, required this.value, required this.color, required this.dark, required this.index});

  @override
  State<_StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<_StatTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 300.ms);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(widget.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Palette.textMuted,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (widget.index * 80).ms).slideY(
        begin: 0.15,
        duration: 400.ms,
        curve: Curves.easeOutCubic,
      ),
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
        if (snap.connectionState == ConnectionState.waiting) {
          return GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'XP History (7 days)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ShimmerSkeleton(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (snap.hasError) {
          return GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Palette.error, size: 24),
                const SizedBox(height: 8),
                Text(
                  'Error loading XP history',
                  style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }
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
            const Text(
              'XP History (7 days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
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
                                style: const TextStyle(
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
                            gradient: const LinearGradient(
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
