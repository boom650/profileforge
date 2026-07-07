// Statistics Dashboard — Visual analytics with animated charts and insights
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statistics', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // XP & Level card
            _XpSummaryCard().animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),

            // Weekly activity chart
            _WeeklyChart().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),

            // Category breakdown
            _CategoryBreakdown().animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            const SizedBox(height: 16),

            // Insights
            _InsightsCard().animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }
}

// ─── XP Summary ─────────────────────────────────────────────────────────────
class _XpSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentPurple, AppTheme.accentPurple.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Level circle
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
            ),
            child: Center(
              child: Text('5', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level 5 — Rising Scholar', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text('750 / 1000 XP to next level', style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.75, minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Weekly Activity Chart ──────────────────────────────────────────────────
class _WeeklyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [0.6, 0.8, 0.4, 0.9, 0.7, 0.3, 0.5];
    final maxVal = values.reduce(math.max);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Activity', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('XP earned per day', style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final height = (values[i] / maxVal) * 100;
                final isToday = i == 4; // Friday
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppTheme.accentPurple
                                : AppTheme.accentPurple.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(days[i], style: GoogleFonts.inter(fontSize: 10, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Breakdown ─────────────────────────────────────────────────────
class _CategoryBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Academics', 0.35, AppTheme.accentPurple),
      ('Writing', 0.25, AppTheme.accentTeal),
      ('Research', 0.20, AppTheme.accentGold),
      ('Service', 0.12, AppTheme.successGreen),
      ('Competitions', 0.08, AppTheme.errorRed),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time Distribution', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...categories.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c.$1, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text('${(c.$2 * 100).round()}%', style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: c.$2, minHeight: 6,
                      backgroundColor: c.$3.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(c.$3),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Insights Card ──────────────────────────────────────────────────────────
class _InsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final insights = [
      ('🔥', 'Consistency', 'You have a 5-day streak! Keep it going.'),
      ('📝', 'Essay Progress', '2 out of 5 essays completed this month.'),
      ('🎯', 'Targets', '75% of weekly targets completed — on track!'),
      ('📊', 'Comparison', 'You\'re ahead of 65% of students in your grade.'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...insights.map((insight) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(insight.$1, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(insight.$2, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(insight.$3, style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
