import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/scoring/profile_scoring.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/widgets/score_widgets.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/navigation/app_router.dart';

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
class ProfileScoreScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ProfileScoreScreen> createState() =>
      _ProfileScoreScreenState();
}

class _ProfileScoreScreenState extends ConsumerState<ProfileScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _radarController;
  late Animation<double> _scoreAnimation;
  ProfileScore? _score;

  /// In-flight guard: prevents two rapid taps from minting two gap missions
  /// (millisecond ids would otherwise race past the open-mission check).
  bool _mintingGapMission = false;
  PsychologicalProfile? _loadedPsych;
  bool _loaded = false;
  bool _isDemo = false;

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

    // Load real data, then calculate score.
    _loadAndCalculate();

    // Start animations.
    _scoreController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _radarController.forward();
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _radarController.dispose();
    super.dispose();
  }

  /// Load the real onboarding + psych profile from the DB and compute a real
  /// score. Falls back to demo ONLY if there is genuinely no user data yet —
  /// never silently pretend demo data is the student's.
  Future<void> _loadAndCalculate() async {
    final onboarding =
        ref.read(onboardingProvider(widget.profileId)).valueOrNull;
    final psych =
        ref.read(psychologicalProfileProvider(widget.profileId)).valueOrNull;

    final hasRealGrades = onboarding != null && onboarding.grades.isNotEmpty;
    final student = hasRealGrades
        ? _studentFrom(onboarding)
        : widget.student ?? _demoStudentData();
    final psychology = psych ?? widget.psychology;
    final aiInsights = widget.aiInsights;

    if (mounted) {
      setState(() {
        _score = ProfileScoring.calculate(
          student: student,
          psychology: psychology,
          aiInsights: aiInsights,
        );
        _loadedPsych = psychology;
        _loaded = true;
        _isDemo = !hasRealGrades && widget.student == null;
      });
    }
  }

  /// Map a real onboarding profile into the scorer's StudentData model.
  StudentData _studentFrom(OnboardingProfile o) {
    final gpa = _gpaFromGrades(o.grades);

    final activities = [
      ...o.activities.map((a) => Activity(
            name: a,
            category: _categoryFor(a),
            isLeadership: a.toLowerCase().contains('president') ||
                a.toLowerCase().contains('captain') ||
                a.toLowerCase().contains('lead'),
            hasImpact: true,
          )),
      ...o.competitions.map((c) => Activity(
            name: c.name,
            category: _categoryFor(c.name),
            hasImpact: true,
            isNationallyRecognized: _national(c.result),
          )),
    ];

    return StudentData(
      gpa: gpa,
      isWeighted: false,
      gpaTrend: GPATrend.stable,
      satScore: null,
      actScore: null,
      activities: activities,
      essays: const [],
    );
  }

  /// Best-effort 0–4 grade point average from per-subject grades.
  /// Handles letter grades (A, A-, B+) and supports an actual GPA override.
  double? _gpaFromGrades(Map<String, String> grades) {
    if (grades.isEmpty) return null;
    final numeric = <double>[];
    for (final raw in grades.values) {
      final v = raw.trim().toUpperCase();
      final parsed = double.tryParse(v);
      if (parsed != null && parsed >= 0 && parsed <= 100) {
        numeric.add(parsed / 25); // percent → 4.0 scale
      } else if (_letterPoints.containsKey(v)) {
        numeric.add(_letterPoints[v]!);
      }
    }
    if (numeric.isEmpty) return null;
    return numeric.reduce((a, b) => a + b) / numeric.length;
  }

  static const Map<String, double> _letterPoints = {
    'A+': 4.3,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'F': 0.0,
  };

  /// Best-effort scorer category classification from a free-form name.
  String _categoryFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('math') ||
        n.contains('science') ||
        n.contains('research') ||
        n.contains('coding') ||
        n.contains('robotic') ||
        n.contains('olympiad')) {
      return 'STEM';
    }
    if (n.contains('debate') ||
        n.contains('speech') ||
        n.contains('writing') ||
        n.contains('english') ||
        n.contains('journal')) {
      return 'Communication';
    }
    if (n.contains('volunteer') ||
        n.contains('service') ||
        n.contains('outreach') ||
        n.contains('ngo') ||
        n.contains('clean')) {
      return 'Community';
    }
    if (n.contains('art') ||
        n.contains('music') ||
        n.contains('theatre') ||
        n.contains('dance') ||
        n.contains('photograph')) {
      return 'Creative';
    }
    if (n.contains('sport') ||
        n.contains('football') ||
        n.contains('cricket') ||
        n.contains('basketball') ||
        n.contains('swim')) {
      return 'Athletics';
    }
    return 'Academic';
  }

  bool _national(String? result) {
    final r = (result ?? '').toLowerCase();
    return r.contains('national') ||
        r.contains('international') ||
        r.contains('state') ||
        r.contains('regional') ||
        r.contains('gold') ||
        r.contains('1st') ||
        r.contains('winner');
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
                : [
                    const Color(0xFFEEF2FF),
                    const Color(0xFFF8FAFC),
                    Colors.white
                  ],
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

                      // ── Personality Radar (loaded psych or passed-in) ──
                      if (_loadedPsych != null)
                        _buildPersonalityRadar(_loadedPsych!, dark),

                      const SizedBox(height: 32),

                      // ── Turn insight into action ──
                      // Habitica bar: every result converts into the next task.
                      // The reveal must not dead-end — weakest component
                      // becomes a real, doable mission the student can start
                      // immediately (SDT: competence feedback → next action).
                      _buildActionBridge(
                        score,
                        dark,
                        activeGapMission: ref
                            .watch(specialMissionsProvider(widget.profileId))
                            .valueOrNull
                            ?.where(
                                (m) => m.source == 'rule' && !m.done)
                            .firstOrNull,
                      ),

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
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 8, 16, 12),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: dark
                ? Palette.border.withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
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
            child: Row(
              children: [
                Text(
                  'Profile Score',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
                if (_isDemo) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Palette.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Palette.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'PREVIEW',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: Palette.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: _loadAndCalculate,
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
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
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
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
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

  /// ── Turn Insight Into Action ─────────────────────────────────────────────
  /// The score reveal must convert into the next task (Habitica bar: feedback
  /// always yields a follow-up action; SDT: competence feedback → next step).
  /// Finds the weakest component and offers a real, immediately-doable mission
  /// targeting exactly that gap — written to the mission ledger and opened in
  /// the missions screen.
  Widget _buildActionBridge(
    ProfileScore score,
    bool dark, {
    MissionRow? activeGapMission,
  }) {
    final gap = _weakestGap(score);
    return GlassCard(
      padding: const EdgeInsets.all(20),
      onTap: _createGapMission,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: gap.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(gap.icon, size: 18, color: gap.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  activeGapMission != null
                      ? 'Mission in progress'
                      : '${gap.label} is your biggest lever right now',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color:
                        dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            activeGapMission != null
                ? 'You already have an open mission for this gap. Complete it, then return here for your next lever.'
                : 'A small, focused mission today compounds into a stronger application.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Palette.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gap.color, gap.color.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gap.color.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  activeGapMission != null ? Icons.flag : Icons.bolt,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  activeGapMission != null
                      ? 'Continue mission'
                      : 'Create a ${gap.label.toLowerCase()} mission',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.05);
  }

  /// Weakest score component → human label + color + icon + mission pillar.
  _GapInfo _weakestGap(ProfileScore score) {
    final candidates = <_GapInfo>[
      _GapInfo(
        'GPA',
        score.gpaScore.toDouble(),
        Palette.primary,
        Icons.school,
        MissionPillar.academics,
        'Raise your GPA with one focused study session — weakest subject '
            'first. A 15-minute active-recall block beats an hour of passive '
            're-reading.',
        'Score your GPA above 70 to unlock the next admission tier.',
      ),
      _GapInfo(
        'Test Scores',
        score.testScore.toDouble(),
        Palette.info,
        Icons.assessment,
        MissionPillar.academics,
        'Build test stamina: one timed practice set now. Pacing is a skill '
            'you train, not a talent you have.',
        'Timed practice directly moves your test-score band.',
      ),
      _GapInfo(
        'Activities',
        score.activitiesScore.toDouble(),
        Palette.warning,
        Icons.groups,
        MissionPillar.leadership,
        'Deepen one activity into leadership or impact. Depth beats breadth '
            'in every admission rubric.',
        'One leadership action converts an activity into a differentiator.',
      ),
      _GapInfo(
        'Essays',
        score.essayScore.toDouble(),
        Palette.success,
        Icons.edit_note,
        MissionPillar.creativity,
        'Draft one authentic scene — a moment you acted, not a list of '
            'achievements. Voice grows from memory, not template.',
        'One genuine scene is the seed of a standout essay.',
      ),
      _GapInfo(
        'Psychology',
        score.psychologyScore.toDouble(),
        const Color(0xFF8B5CF6),
        Icons.psychology,
        MissionPillar.personal,
        'Strengthen your growth mindset: one 10-minute reflection on a past '
            'setback and what you learned. Fit and mindset move with practice.',
        'A stronger psychology profile lifts your fit score.',
      ),
      _GapInfo(
        'Growth',
        score.growthScore.toDouble(),
        const Color(0xFF06B6D4),
        Icons.trending_up,
        MissionPillar.personal,
        'Record one improvement you made this week. Evidence of upward '
            'trajectory is a scored component in the rubric.',
        'Documented progress compounds your growth score.',
      ),
      _GapInfo(
        'AI Insights',
        score.aiScore.toDouble(),
        const Color(0xFFF59E0B),
        Icons.auto_awesome,
        MissionPillar.research,
        'Act on one AI insight from your profile review. Insight without '
            'action is trivia — this turns it into progress.',
        'Executing an AI recommendation scores higher than reading one.',
      ),
    ];
    _GapInfo best = candidates.first;
    for (final c in candidates) {
      if (c.value < best.value) best = c;
    }
    return best;
  }

  /// Create the gap mission in the real ledger, then open /missions so the
  /// student can start it immediately (never a fake toast). One open gap
  /// mission per profile: re-taps navigate to the existing mission instead
  /// of minting another reward (Habitica: a reward is never self-replicating).
  Future<void> _createGapMission() async {
    final score = _score;
    if (score == null) return;
    if (_mintingGapMission) return; // double-tap guard
    _mintingGapMission = true;
    final gap = _weakestGap(score);
    try {
      final existing = await ref
          .read(specialMissionsProvider(widget.profileId).future)
          .then((rows) => rows.where((m) => m.source == 'rule' && !m.done))
          .then((rows) => rows.isNotEmpty);
      if (existing) {
        SoundService.instance.tap();
        if (mounted) context.push('/missions');
        return;
      }

      final missionId =
          'gap-${widget.profileId}-${DateTime.now().millisecondsSinceEpoch}';
    final mission = Mission(
      id: missionId,
      profileId: widget.profileId,
      title: 'Build your ${gap.label.toLowerCase()}',
      description: gap.action,
      // Special cadence: survives mission regeneration (which deletes open
      // daily/weekly/monthly rows). Rendered via specialMissionsProvider in a
      // pinned "Priority" section — visible, completable, never silently wiped.
      cadence: MissionCadence.special,
      pillar: gap.pillar,
      xpReward: 20,
      gemReward: 3,
      dueAt: DateTime.now().add(const Duration(days: 3)),
      completed: false,
      source: 'rule',
      priority: 'high',
      rationale: gap.rationale,
    );

    SoundService.instance.tap();
    await ref.read(missionRepositoryProvider).upsertGenerated([mission]);
    ref.invalidate(specialMissionsProvider(widget.profileId));
    if (mounted) {
      context.push('/missions');
    }
    } finally {
      _mintingGapMission = false;
    }
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
              labels: [
                'Openness',
                'Conscientious',
                'Extraversion',
                'Agreeableness',
                'Stability'
              ],
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

/// ── Weakest-gap descriptor (score → actionable mission mapping) ───────────
class _GapInfo {
  const _GapInfo(
    this.label,
    this.value,
    this.color,
    this.icon,
    this.pillar,
    this.action,
    this.rationale,
  );

  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final MissionPillar pillar;

  /// The mission body the student actually reads and does.
  final String action;

  /// Why this mission moves the score (admissions rationale).
  final String rationale;
}
