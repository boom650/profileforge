import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/scoring/profile_scoring.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/widgets/score_widgets.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Profile Score Screen — Animated score display with breakdown.
///
/// Features:
/// - Animated circular score ring
/// - Tier classification (Platinum/Gold/Silver/Bronze)
/// - Component breakdown with animated bars
/// - Personality radar chart
/// - Strengths and improvements
///
/// Based on research:
/// - 01-student-profile-scoring-analytics.md
/// - 01-gpa-grade-analysis-system.md
/// - 01-test-score-optimization.md
/// - 01-essay-writing-framework.md
/// ────────────────────────────────────────────────────────────────────────────
class ProfileScoreScreen extends StatefulWidget {
  const ProfileScoreScreen({
    super.key,
    required this.profileId,
    this.student,
    this.psychology,
    this.aiInsights,
  });

  final String profileId;
  final StudentData? student;
  final PsychologicalProfile? psychology;
  final AIInsights? aiInsights;

  @override
  State<ProfileScoreScreen> createState() => _ProfileScoreScreenState();
}

class _ProfileScoreScreenState extends State<ProfileScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _radarController;
  late Animation<double> _scoreAnimation;
  ProfileScore? _score;

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scoreAnimation = CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    );

    // Calculate score
    _calculateScore();

    // Start animations
    _scoreController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _radarController.forward();
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  void _calculateScore() {
    // Use provided data or demo data
    final student = widget.student ?? _demoStudentData();
    final psychology = widget.psychology;
    final aiInsights = widget.aiInsights;

    setState(() {
      _score = ProfileScoring.calculate(
        student: student,
        psychology: psychology,
        aiInsights: aiInsights,
      );
    });
  }

  StudentData _demoStudentData() {
    return const StudentData(
      gpa: 3.8,
      isWeighted: false,
      gpaTrend: GPATrend.upward,
      satScore: 1450,
      activities: [
        Activity(
          name: 'Robotics Club President',
          category: 'STEM',
          yearsInvolved: 3,
          isLeadership: true,
          hasImpact: true,
          isNationallyRecognized: false,
        ),
        Activity(
          name: 'Volunteer Tutor',
          category: 'Community',
          yearsInvolved: 2,
          isLeadership: false,
          hasImpact: true,
          isNationallyRecognized: false,
        ),
        Activity(
          name: 'Math Olympiad',
          category: 'Academic',
          yearsInvolved: 2,
          isLeadership: false,
          hasImpact: false,
          isNationallyRecognized: true,
        ),
        Activity(
          name: 'Debate Team',
          category: 'Communication',
          yearsInvolved: 1,
          isLeadership: false,
          hasImpact: false,
          isNationallyRecognized: false,
        ),
      ],
      essays: [
        Essay(
          title: 'Common App Essay',
          wordCount: 650,
          hasPersonalVoice: true,
          showsGrowth: true,
          hasUniqueAngle: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final score = _score;

    if (score == null) {
      return Scaffold(
        backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
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
            children: [
              // ── Header ──
              _buildHeader(dark),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // ── Score Ring ──
                      _buildScoreRing(score, dark),

                      const SizedBox(height: 24),

                      // ── Tier Badge ──
                      _buildTierBadge(score, dark),

                      const SizedBox(height: 32),

                      // ── Component Breakdown ──
                      _buildComponentBreakdown(score, dark),

                      const SizedBox(height: 32),

                      // ── Strengths & Improvements ──
                      _buildStrengthsImprovements(score, dark),

                      const SizedBox(height: 32),

                      // ── Personality Radar ──
                      if (widget.psychology != null)
                        _buildPersonalityRadar(widget.psychology!, dark),

                      const SizedBox(height: 100),
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

  /// ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 12),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
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
          Expanded(
            child: Text(
              'Profile Score',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ),
          GestureDetector(
            onTap: _calculateScore,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.refresh,
                size: 18,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── Score Ring ───────────────────────────────────────────────────────────
  Widget _buildScoreRing(ProfileScore score, bool dark) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        final animatedScore = (score.total * _scoreAnimation.value).round();

        return Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background ring
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 12,
                    color: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
                  ),
                ),
                // Progress ring
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: (animatedScore / 100).clamp(0.0, 1.0),
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation(score.tierColor),
                  ),
                ),
                // Score text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$animatedScore',
                      style: GoogleFonts.inter(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: score.tierColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      'out of 100',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).animate().scale(
      delay: 200.ms,
      duration: 600.ms,
      curve: Curves.easeOutBack,
    );
  }

  /// ── Tier Badge ───────────────────────────────────────────────────────────
  Widget _buildTierBadge(ProfileScore score, bool dark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: score.tierColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: score.tierColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: score.tierColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${score.tierName} Tier',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: score.tierColor,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  /// ── Component Breakdown ──────────────────────────────────────────────────
  Widget _buildComponentBreakdown(ProfileScore score, bool dark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Breakdown',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 20),
          _ScoreBar(
            label: 'GPA',
            value: score.gpaScore,
            weight: '35%',
            color: Palette.primary,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Test Scores',
            value: score.testScore,
            weight: '20%',
            color: Palette.info,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Activities',
            value: score.activitiesScore,
            weight: '20%',
            color: Palette.warning,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Essays',
            value: score.essayScore,
            weight: '10%',
            color: Palette.success,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Psychology',
            value: score.psychologyScore,
            weight: '5%',
            color: const Color(0xFF8B5CF6),
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Growth',
            value: score.growthScore,
            weight: '5%',
            color: const Color(0xFF06B6D4),
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'AI Insights',
            value: score.aiScore,
            weight: '5%',
            color: const Color(0xFFF59E0B),
            dark: dark,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.05);
  }

  /// ── Strengths & Improvements ─────────────────────────────────────────────
  Widget _buildStrengthsImprovements(ProfileScore score, bool dark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strengths
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Palette.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        size: 16,
                        color: Palette.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Strengths',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Palette.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (score.strengths.isEmpty)
                  Text(
                    'Complete more profile data to see strengths',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Palette.textTertiary,
                    ),
                  )
                else
                  ...score.strengths.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Palette.success.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            s,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: dark ? Palette.textPrimary : Palette.textInverse,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Improvements
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Palette.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Palette.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Improve',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Palette.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (score.improvements.isEmpty)
                  Text(
                    'Looking good! Keep building your profile',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Palette.textTertiary,
                    ),
                  )
                else
                  ...score.improvements.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: Palette.warning.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            s,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: dark ? Palette.textPrimary : Palette.textInverse,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05);
  }

  /// ── Personality Radar ────────────────────────────────────────────────────
  Widget _buildPersonalityRadar(PsychologicalProfile profile, bool dark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personality Profile',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How the AI adapts to your personality',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Palette.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: PersonalityRadar(
              values: [
                profile.openness,
                profile.conscientiousness,
                profile.extraversion,
                profile.agreeableness,
                1 - profile.neuroticism, // Invert so higher = better
              ],
              labels: ['Openness', 'Conscientious', 'Extraversion', 'Agreeableness', 'Stability'],
              size: 220,
            ),
          ),
          const SizedBox(height: 20),
          // Trait bars
          _TraitBar(
            label: 'Growth Mindset',
            value: profile.growthMindset,
            color: Palette.success,
            dark: dark,
          ),
          const SizedBox(height: 12),
          _TraitBar(
            label: 'Self-Efficacy',
            value: profile.selfEfficacy,
            color: Palette.warning,
            dark: dark,
          ),
          const SizedBox(height: 12),
          _TraitBar(
            label: 'Competence',
            value: profile.competence,
            color: Palette.info,
            dark: dark,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.05);
  }
}

/// ── Score Bar ──────────────────────────────────────────────────────────────
class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.label,
    required this.value,
    required this.weight,
    required this.color,
    required this.dark,
  });

  final String label;
  final int value;
  final String weight;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            Row(
              children: [
                Text(
                  '$value',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    weight,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: (value / 100).clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ── Trait Bar ──────────────────────────────────────────────────────────────
class _TraitBar extends StatelessWidget {
  const _TraitBar({
    required this.label,
    required this.value,
    required this.color,
    required this.dark,
  });

  final String label;
  final double value;
  final Color color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Palette.textSecondary,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
