import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// StatsOverviewScreen — Weekly/monthly analytics and insights.
///
/// Features:
/// - Activity heatmap calendar
/// - Score trend charts
/// - Time spent breakdown
/// - AI interaction stats
/// ────────────────────────────────────────────────────────────────────────────
class StatsOverviewScreen extends ConsumerWidget {
  const StatsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Quick Stats ──
                      _buildQuickStats(dark),
                      const SizedBox(height: 24),

                      // ── Activity Heatmap ──
                      _buildSectionTitle('Activity This Week', dark),
                      const SizedBox(height: 12),
                      _buildActivityHeatmap(dark, ref),
                      const SizedBox(height: 24),

                      // ── Score Trend ──
                      _buildSectionTitle('Weekly XP Trend', dark),
                      const SizedBox(height: 12),
                      _buildScoreTrend(dark, ref),
                      const SizedBox(height: 24),

                      // ── XP Source Breakdown ──
                      _buildSectionTitle('Where your XP comes from', dark),
                      const SizedBox(height: 12),
                      _buildTimeBreakdown(dark, ref),
                      const SizedBox(height: 24),

                      // ── AI Stats ──
                      _buildSectionTitle('AI Interactions', dark),
                      const SizedBox(height: 12),
                      _buildAIStats(dark),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(bool dark) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.local_fire_department,
          value: '7',
          label: 'Day Streak',
          color: Palette.error,
          dark: dark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.star,
          value: '850',
          label: 'Total XP',
          color: Palette.warning,
          dark: dark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.auto_awesome,
          value: '23',
          label: 'AI Chats',
          color: Palette.primary,
          dark: dark,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool dark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface1.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dark ? Palette.border : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Palette.textPrimary : Palette.textInverse,
      ),
    );
  }

  Widget _buildActivityHeatmap(bool dark, WidgetRef ref) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final profileIdAsync = ref.watch(activeProfileIdProvider);
    final profileId = profileIdAsync.valueOrNull;
    // Real per-day XP from the ledger — never hardcoded.
    final xpByDay = profileId == null
        ? const <DateTime, int>{}
        : (ref
                    .watch(xpByDayProvider((profileId: profileId, days: 7)))
                    .valueOrNull ??
                const {});

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final today = DateTime.now();
              final date = DateTime(today.year, today.month, today.day)
                  .subtract(Duration(days: 6 - i));
              final activity = xpByDay[date] ?? 0;
              final intensity =
                  activity == 0 ? 0.0 : (activity / 100.0).clamp(0.15, 1.0);

              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: activity > 0
                          ? Palette.primary
                              .withValues(alpha: 0.15 + intensity * 0.65)
                          : (dark ? Palette.surface3 : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: activity > 0
                          ? Text(
                              '$activity',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Palette.primary,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 10,
                      color: dark ? Palette.textTertiary : Palette.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreTrend(bool dark, WidgetRef ref) {
    final profileIdAsync = ref.watch(activeProfileIdProvider);
    final profileId = profileIdAsync.valueOrNull;
    // Real per-day XP — the honest analog for a "score trend": there is no
    // historical score table yet, so we chart real earned XP instead of
    // fabricating a fake 7-point score series (old code: `scores = [65, 68, ...]`).
    final xpByDay = profileId == null
        ? const <DateTime, int>{}
        : (ref
                    .watch(xpByDayProvider((profileId: profileId, days: 7)))
                    .valueOrNull ??
                const {});
    final today = DateTime.now();
    final scores = List<int>.generate(7, (i) {
      final date = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return xpByDay[date] ?? 0;
    });
    final weekTotal = scores.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly XP',
                style: TextStyle(
                  fontSize: 12,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Palette.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 14, color: Palette.success),
                    const SizedBox(width: 4),
                    Text(
                      '$weekTotal XP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Palette.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$weekTotal',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 16),
          // Mini chart — real XP per day.
          SizedBox(
            height: 60,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: _MiniChartPainter(
                data: scores,
                color: Palette.primary,
                dark: dark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => Text(
                      d,
                      style: TextStyle(
                        fontSize: 10,
                        color: Palette.textTertiary,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBreakdown(bool dark, WidgetRef ref) {
    final profileIdAsync = ref.watch(activeProfileIdProvider);
    final profileId = profileIdAsync.valueOrNull;
    // Honest analog: XP earned by source (real ledger). No time-tracking data
    // exists, so hours were hardcoded before — that fabricated "4.5h AI Chat"
    // numbers. Replace with real per-source XP share.
    final history = profileId == null
        ? const <XpEventRow>[]
        : (ref.watch(xpHistoryProvider(profileId)).valueOrNull ?? const []);
    final bySource = <String, int>{};
    for (final e in history) {
      bySource[e.source] = (bySource[e.source] ?? 0) + e.amount;
    }
    final sourceColors = <String, Color>{
      'mission': Palette.primary,
      'streak': Palette.success,
      'first_win': Palette.warning,
      'daily': Palette.accentPink,
      'ai': Palette.info,
    };
    final breakdown = bySource.entries.map((e) {
      return _TimeEntry(
        label: e.key.replaceAll('_', ' ').toUpperCase(),
        hours: e.value.toDouble(),
        color: sourceColors[e.key] ?? Palette.textSecondary,
      );
    }).toList();
    if (breakdown.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface1.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dark ? Palette.border : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          'No activity yet — complete a mission to see your XP breakdown.',
          style: TextStyle(
            fontSize: 13,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          // Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: breakdown.map((entry) {
                final total = breakdown.fold(0.0, (sum, e) => sum + e.hours);
                final width = entry.hours / total;

                return Expanded(
                  flex: (width * 1000).toInt(),
                  child: Container(
                    height: 12,
                    color: entry.color,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: breakdown.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: entry.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.label} (${entry.hours.toInt()} XP)',
                    style: TextStyle(
                      fontSize: 11,
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIStats(bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          _buildAIStatRow('Conversations', '23', Icons.chat_bubble_outline, dark),
          const Divider(height: 24),
          _buildAIStatRow('Messages Sent', '156', Icons.send, dark),
          const Divider(height: 24),
          _buildAIStatRow('Avg Response Quality', '4.8', Icons.star_outline, dark),
          const Divider(height: 24),
          _buildAIStatRow('Most Used Feature', 'Essay Review', Icons.article_outlined, dark),
        ],
      ),
    );
  }

  Widget _buildAIStatRow(String label, String value, IconData icon, bool dark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Palette.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
      ],
    );
  }
}

class _TimeEntry {
  final String label;
  final double hours;
  final Color color;

  const _TimeEntry({required this.label, required this.hours, required this.color});
}

class _MiniChartPainter extends CustomPainter {
  _MiniChartPainter({
    required this.data,
    required this.color,
    required this.dark,
  });

  final List<int> data;
  final Color color;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    final minVal = data.reduce((a, b) => a < b ? a : b).toDouble();
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    final range = maxVal - minVal;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = range > 0 ? (data[i] - minVal) / range : 0.5;
      final y = size.height - (normalizedY * size.height * 0.8) - size.height * 0.1;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_MiniChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
