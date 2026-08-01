import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/premium_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Weekly summary screen — Premium stats dashboard with animated numbers.
/// ────────────────────────────────────────────────────────────────────────────
class WeeklySummaryScreen extends ConsumerWidget {
  final String profileId;
  const WeeklySummaryScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);

    // Mock weekly data — in production, fetch from provider
    final stats = {
      'sessions': 12,
      'hours': 18.5,
      'xp': 2450,
      'streak': 7,
      'missions': 8,
      'challenges': 3,
    };

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'Weekly Summary',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Week Header ──
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Palette.primary, Palette.accent],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.assessment, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'This Week',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Great progress! Keep it up.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // ── Stats Grid ──
            Text(
              'Performance',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatTile(
                  label: 'Sessions',
                  value: stats['sessions'] as int,
                  icon: Icons.timer,
                  color: Palette.primary,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  label: 'Hours',
                  value: (stats['hours'] as double).toInt(),
                  icon: Icons.schedule,
                  color: Palette.accent,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatTile(
                  label: 'XP Earned',
                  value: stats['xp'] as int,
                  icon: Icons.star,
                  color: Palette.warning,
                ),
                const SizedBox(width: 10),
                _StatTile(
                  label: 'Day Streak',
                  value: stats['streak'] as int,
                  icon: Icons.local_fire_department,
                  color: Palette.error,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Activity Breakdown ──
            Text(
              'Activity',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ActivityRow(
                    label: 'Missions Completed',
                    value: '${stats['missions']}',
                    pct: 0.8,
                    color: Palette.primary,
                  ),
                  const SizedBox(height: 12),
                  _ActivityRow(
                    label: 'Challenges Won',
                    value: '${stats['challenges']}',
                    pct: 0.6,
                    color: Palette.accent,
                  ),
                  const SizedBox(height: 12),
                  _ActivityRow(
                    label: 'Study Time',
                    value: '${stats['hours']}h',
                    pct: 0.75,
                    color: Palette.success,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
            const SizedBox(height: 24),

            // ── Weekly Chart Placeholder ──
            Text(
              'Daily Breakdown',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final heights = [0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 0.3];
                  final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final h = heights[i];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 100 * h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Palette.primary.withValues(alpha: 0.6),
                              Palette.primary.withValues(alpha: 0.2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 300 + i * 50), duration: 300.ms)
                       .slideY(begin: 0.3),
                      const SizedBox(height: 6),
                      Text(
                        dayNames[i],
                        style: TextStyle(
                          color: Palette.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(color: Palette.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCounter(
              value: value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String label;
  final String value;
  final double pct;
  final Color color;

  const _ActivityRow({
    required this.label,
    required this.value,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Palette.textPrimary, fontSize: 13)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 6,
                  backgroundColor: Palette.surface2,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
