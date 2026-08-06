import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/score_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ScoreBreakdownScreen — Detailed animated score breakdown.
///
/// Features:
/// - Animated overall score circle
/// - Category breakdown with animated bars
/// - Score trend sparkline
/// - Improvement suggestions
/// - Detailed tooltips for each category
/// ────────────────────────────────────────────────────────────────────────────
class ScoreBreakdownScreen extends StatefulWidget {
  const ScoreBreakdownScreen({super.key});

  @override
  State<ScoreBreakdownScreen> createState() => _ScoreBreakdownScreenState();
}

class _ScoreBreakdownScreenState extends State<ScoreBreakdownScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _barsController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 82).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    _barsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Stagger the animations
    Future.delayed(const Duration(milliseconds: 300), () {
      _scoreController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _barsController.forward();
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

                      // ── Score Trend ──
                      _buildSectionTitle('Score History', dark),
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
                    '+5 from last week',
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
    final categories = [
      _ScoreCategory(
        label: 'Academic Profile',
        score: 85,
        icon: Icons.school,
        color: Palette.primary,
        tips: ['Add AP courses', 'Highlight research'],
      ),
      _ScoreCategory(
        label: 'Extracurriculars',
        score: 78,
        icon: Icons.star,
        color: Palette.success,
        tips: ['Start a club', 'Get leadership role'],
      ),
      _ScoreCategory(
        label: 'Essays',
        score: 72,
        icon: Icons.edit_note,
        color: Palette.warning,
        tips: ['Add personal stories', 'Show vulnerability'],
      ),
      _ScoreCategory(
        label: 'Recommendations',
        score: 80,
        icon: Icons.person,
        color: Palette.info,
        tips: ['Choose diverse recommenders', 'Provide context'],
      ),
      _ScoreCategory(
        label: 'Test Scores',
        score: 88,
        icon: Icons.speed,
        color: Palette.accentPink,
        tips: ['Retake if below target', 'Superscore'],
      ),
    ];

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
    // Mock data: last 7 days
    final scores = [75, 77, 74, 78, 80, 79, 82];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
            children: days.map((d) {
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
      ),
    );
  }

  Widget _buildImprovementTips(bool dark) {
    final tips = [
      _ImprovementTip(
        icon: Icons.edit_note,
        title: 'Revise Your Main Essay',
        description:
            'Your essay score can improve by adding a specific personal anecdote.',
        impact: '+8 pts',
        color: Palette.warning,
      ),
      _ImprovementTip(
        icon: Icons.star,
        title: 'Add Leadership Activity',
        description:
            'Starting or leading a club would boost your extracurricular score.',
        impact: '+5 pts',
        color: Palette.success,
      ),
      _ImprovementTip(
        icon: Icons.person,
        title: 'Request Recommendation',
        description:
            'A recommendation from a teacher who knows you well can make a big difference.',
        impact: '+3 pts',
        color: Palette.info,
      ),
    ];

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
