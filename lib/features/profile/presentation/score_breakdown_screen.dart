import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/score_widgets.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/core/scoring/profile_scoring.dart';
import 'package:profileforge/features/profile/application/profile_score_loader.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ScoreBreakdownScreen — Detailed animated score breakdown.
///
/// Features:
/// - Animated overall score circle (REAL score from ProfileScoring)
/// - Category breakdown with animated bars (REAL component scores)
/// - Weekly XP trend (honest — no score history table exists, so the
///   "history" charts the real XP ledger instead of fabricated scores)
/// - Improvement suggestions (REAL, from ProfileScoring)
/// ────────────────────────────────────────────────────────────────────────────
class ScoreBreakdownScreen extends ConsumerStatefulWidget {
  const ScoreBreakdownScreen({super.key});

  @override
  ConsumerState<ScoreBreakdownScreen> createState() =>
      _ScoreBreakdownScreenState();
}

class _ScoreBreakdownScreenState extends ConsumerState<ScoreBreakdownScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _barsController;
  late Animation<double> _scoreAnimation;
  ProfileScore? _score;
  bool _isDemo = false;
  bool _loaded = false;
  String? _profileId;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Real score, animated from 0 → actual total (never a hardcoded 82).
    _scoreAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    _barsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _loadAndCalculate();
  }

  Future<void> _loadAndCalculate() async {
    final profileId = ref.read(activeProfileIdProvider).valueOrNull;
    final loaded = await loadProfileScore(ref, profileId);
    if (!mounted) return;
    setState(() {
      _score = loaded.score;
      _isDemo = loaded.isDemo;
      _loaded = true;
      _profileId = profileId;
      _scoreAnimation = Tween<double>(begin: 0, end: loaded.score.total.toDouble())
          .animate(
        CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
      );
      // Stagger the animations
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _scoreController.forward();
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _barsController.forward();
      });
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _barsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Score Breakdown',
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

                      // ── Overall Score ──
                      _buildOverallScore(dark),
                      const SizedBox(height: 24),

                      // ── Category Breakdown ──
                      _buildSectionTitle('Category Breakdown', dark),
                      const SizedBox(height: 12),
                      _buildCategoryBreakdown(dark),
                      const SizedBox(height: 24),

                      // ── Weekly Activity Trend ──
                      _buildSectionTitle('Weekly Activity', dark),
                      const SizedBox(height: 12),
                      _buildScoreHistory(dark),
                      const SizedBox(height: 24),

                      // ── Improvement Tips ──
                      _buildSectionTitle('How to Improve', dark),
                      const SizedBox(height: 12),
                      _buildImprovementTips(dark),
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

  Widget _buildOverallScore(bool dark) {
    return Center(
      child: AnimatedBuilder(
        animation: _scoreAnimation,
        builder: (context, child) {
          return Column(
            children: [
              ScoreCircle(
                score: _scoreAnimation.value.round(),
                size: 180,
                strokeWidth: 14,
                label: 'Overall',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 18, color: Palette.success),
                  const SizedBox(width: 4),
                  Text(
                    _isDemo ? 'PREVIEW score' : 'Current score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Palette.success,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ).animate().fadeIn(duration: 600.ms).scale(
          begin: const Offset(0.9, 0.9),
          duration: 600.ms,
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

  Widget _buildCategoryBreakdown(bool dark) {
    final s = _score;
    final categories = [
      _ScoreCategory(
        label: 'Academic Profile',
        score: s?.gpaScore ?? 0,
        icon: Icons.school,
        color: Palette.primary,
        tips: const ['Add AP courses', 'Highlight research'],
      ),
      _ScoreCategory(
        label: 'Extracurriculars',
        score: s?.activitiesScore ?? 0,
        icon: Icons.star,
        color: Palette.success,
        tips: const ['Start a club', 'Get leadership role'],
      ),
      _ScoreCategory(
        label: 'Essays',
        score: s?.essayScore ?? 0,
        icon: Icons.edit_note,
        color: Palette.warning,
        tips: const ['Add personal stories', 'Show vulnerability'],
      ),
      _ScoreCategory(
        label: 'Psychology & Mindset',
        score: s?.psychologyScore ?? 0,
        icon: Icons.psychology,
        color: Palette.info,
        tips: const ['Growth mindset practices', 'Self-efficacy builders'],
      ),
      _ScoreCategory(
        label: 'Test Scores',
        score: s?.testScore ?? 0,
        icon: Icons.speed,
        color: Palette.accentPink,
        tips: const ['Retake if below target', 'Superscore'],
      ),
    ];

    if (!_loaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_isDemo) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'PREVIEW — complete your profile to see your real scores.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      children: categories.map((category) {
        return AnimatedBuilder(
          animation: _barsController,
          builder: (context, child) {
            final progress = _barsController.value * (category.score / 100);
            return _buildCategoryCard(category, progress, dark);
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(_ScoreCategory category, double progress, bool dark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, size: 18, color: category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: category.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(category.color),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: category.tips.map((tip) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tip,
                  style: TextStyle(
                    fontSize: 11,
                    color: category.color,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreHistory(bool dark) {
    // Honest: no score-history table exists. Chart the REAL XP ledger
    // instead of fabricating a fake score series (user rule: never fake).
    final xpByDay = ref
        .watch(xpByDayProvider(
            (profileId: _profileId ?? '', days: 7)))
        .valueOrNull;
    final today = DateTime.now();
    final scores = List<int>.generate(7, (i) {
      final d = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return xpByDay?[d] ?? 0;
    });
    final labels = List<String>.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      const names = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return names[d.weekday - 1];
    });
    final hasActivity = scores.any((s) => s > 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          if (!hasActivity)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No activity recorded this week yet — complete a mission to see your trend.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            )
          else ...[
            // Chart
            SizedBox(
              height: 120,
              child: AnimatedBuilder(
                animation: _barsController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: _SparklineChartPainter(
                      data: scores,
                      progress: _barsController.value,
                      color: Palette.primary,
                      dark: dark,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((d) {
                return Text(
                  d,
                  style: TextStyle(
                    fontSize: 10,
                    color: Palette.textTertiary,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImprovementTips(bool dark) {
    final s = _score;
    if (_isDemo || s == null || s.improvements.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Complete your profile to get personalized improvement tips.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      );
    }

    // REAL suggestions from the scorer — no fabricated point impacts.
    final icons = [
      Icons.edit_note,
      Icons.star,
      Icons.school,
      Icons.psychology,
    ];
    final colors = [
      Palette.warning,
      Palette.success,
      Palette.primary,
      Palette.info,
    ];
    final tips = s.improvements
        .take(4)
        .map((imp) => _ImprovementTip(
              icon: icons[s.improvements.indexOf(imp) % icons.length],
              title: imp.split('.').first,
              description: imp,
              impact: 'Focus area',
              color: colors[s.improvements.indexOf(imp) % colors.length],
            ))
        .toList();

    return Column(
      children: tips.map((tip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dark ? Palette.border : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tip.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tip.icon, size: 20, color: tip.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? Palette.textSecondary : Palette.textTertiary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Palette.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tip.impact,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Palette.success,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ScoreCategory {
  final String label;
  final int score;
  final IconData icon;
  final Color color;
  final List<String> tips;

  const _ScoreCategory({
    required this.label,
    required this.score,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

class _ImprovementTip {
  final IconData icon;
  final String title;
  final String description;
  final String impact;
  final Color color;

  const _ImprovementTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.impact,
    required this.color,
  });
}

class _SparklineChartPainter extends CustomPainter {
  _SparklineChartPainter({
    required this.data,
    required this.progress,
    required this.color,
    required this.dark,
  });

  final List<int> data;
  final double progress;
  final Color color;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final minVal = data.reduce((a, b) => a < b ? a : b).toDouble();
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    final range = maxVal - minVal;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final progressX = (i / (data.length - 1)) * progress;
      final x = progressX * size.width;
      final normalizedY = range > 0 ? (data[i] - minVal) / range : 0.5;
      final y = size.height - (normalizedY * size.height * 0.7) - size.height * 0.15;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots
      if (i <= (progress * data.length).round()) {
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }
    }

    fillPath.lineTo(progress * size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_SparklineChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
