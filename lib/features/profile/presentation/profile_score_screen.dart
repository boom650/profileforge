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
import 'package:profileforge/features/profile/application/profile_score_loader.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/core/audio/sound_service.dart';

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
        _isDemo = !hasRealGrades && widget.student == null;
      });
    }
  }

  /// Map a real onboarding profile into the scorer's StudentData model.
  /// (Delegates to the SHARED loader — every screen computes the SAME
  /// numbers; no per-screen divergent demo/preview data.)
  StudentData _studentFrom(OnboardingProfile o) => studentFromOnboarding(o);

  /// Demo fallback — ONLY used when there is genuinely no user data yet.
  /// (Delegates to the SHARED loader so every screen shows the SAME
  /// preview — the old private copy had divergent SAT/ACT demo values.)
  StudentData _demoStudentData() => demoStudentData();

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final score = _score;

    if (score == null) {
      return Scaffold(
        backgroundColor: dark ? Palette.black : Palette.cream,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [
                    const Color(0xFFFBF1E3),
                    Palette.cream,
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
                : const Color(0xFFEDE3D6),
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
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                borderRadius: BorderRadius.circular(9999),
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
                  style: GoogleFonts.nunito(
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
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: Palette.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'PREVIEW',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                borderRadius: BorderRadius.circular(9999),
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
                    color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
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
                      style: GoogleFonts.nunito(
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        color: score.tierColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      'out of 100',
                      style: GoogleFonts.nunito(
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
              style: GoogleFonts.nunito(
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
            style: GoogleFonts.nunito(
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
            color: Palette.accent,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'Growth',
            value: score.growthScore,
            weight: '5%',
            color: Palette.accentTeal,
            dark: dark,
          ),
          const SizedBox(height: 16),
          _ScoreBar(
            label: 'AI Insights',
            value: score.aiScore,
            weight: '5%',
            color: Palette.accentYellow,
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
                        borderRadius: BorderRadius.circular(16),
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
                      style: GoogleFonts.nunito(
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
                    style: GoogleFonts.nunito(
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
                                style: GoogleFonts.nunito(
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
                        borderRadius: BorderRadius.circular(16),
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
                      style: GoogleFonts.nunito(
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
                    style: GoogleFonts.nunito(
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
                                style: GoogleFonts.nunito(
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(gap.icon, size: 18, color: gap.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  activeGapMission != null
                      ? 'Mission in progress'
                      : '${gap.label} is your biggest lever right now',
                  style: GoogleFonts.nunito(
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
            style: GoogleFonts.nunito(
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
              borderRadius: BorderRadius.circular(9999),
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
                  style: GoogleFonts.nunito(
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

  /// All scored components ranked weakest-first → mission pillar mapping.
  /// Used both for display (weakest) and for one-shot gap missions (the next
  /// pillar with no completed gap mission — a pillar is addressed ONCE, never
  /// re-minted, closing the sequential farm).
  List<_GapInfo> _gapCandidates(ProfileScore score) {
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
        Palette.accent,
        Icons.psychology,
        MissionPillar.personal,
        'Strengthen your growth mindset: one 10-minute reflection on a past '
            'setback and what you learned. Fit and mindset move with practice.',
        'A stronger psychology profile lifts your fit score.',
      ),
      _GapInfo(
        'Growth',
        score.growthScore.toDouble(),
        Palette.accentTeal,
        Icons.trending_up,
        MissionPillar.personal,
        'Record one improvement you made this week. Evidence of upward '
            'trajectory is a scored component in the rubric.',
        'Documented progress compounds your growth score.',
      ),
      _GapInfo(
        'AI Insights',
        score.aiScore.toDouble(),
        Palette.accentYellow,
        Icons.auto_awesome,
        MissionPillar.research,
        'Act on one AI insight from your profile review. Insight without '
            'action is trivia — this turns it into progress.',
        'Executing an AI recommendation scores higher than reading one.',
      ),
    ];
    candidates.sort((a, b) => a.value.compareTo(b.value));
    return candidates;
  }

  /// Weakest scored component (display).
  _GapInfo _weakestGap(ProfileScore score) => _gapCandidates(score).first;

  /// Create the gap mission in the real ledger, then open /missions so the
  /// student can start it immediately (never a fake toast).
  ///
  /// ONE-SHOT PER PILLAR: a pillar is addressed once, ever. The mission id is
  /// deterministic (`gap-{profileId}-{pillar}`), and before minting we check
  /// mission history for any DONE rule-mission on that pillar — if one exists
  /// we advance to the next weakest pillar with no completed gap mission.
  /// When every pillar has been addressed, nothing mints (the CTA reflects
  /// it). This closes the sequential farm (R3: complete → back → tap re-minted
  /// the identical reward-bearing mission with zero cooldown).
  Future<void> _createGapMission() async {
    final score = _score;
    if (score == null) return;
    if (_mintingGapMission) return; // double-tap guard
    _mintingGapMission = true;
    try {
      // Pillars already addressed (any DONE rule mission) — never re-mint.
      final history = await ref
          .read(missionRepositoryProvider)
          .history(widget.profileId);
      final addressedPillars = history
          .where((m) => m.source == 'rule' && m.done)
          .map((m) => m.pillar)
          .toSet();

      // Next weakest pillar with no completed gap mission.
      final gap = _gapCandidates(score).firstWhere(
            (g) => !addressedPillars.contains(g.pillar),
            orElse: () => _gapCandidates(score).first,
          );
      final allAddressed = addressedPillars.isNotEmpty &&
          _gapCandidates(score).every((g) => addressedPillars.contains(g.pillar));

      // If an OPEN gap mission still exists, just navigate to it.
      final existing = await ref
          .read(specialMissionsProvider(widget.profileId).future)
          .then((rows) => rows.where((m) => m.source == 'rule' && !m.done))
          .then((rows) => rows.isNotEmpty);
      if (existing || allAddressed) {
        SoundService.instance.tap();
        if (mounted) context.push('/missions');
        return;
      }

      // Deterministic id per pillar — same pillar can never mint twice.
      final missionId = 'gap-${widget.profileId}-${gap.pillar.name}';
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
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How the AI adapts to your personality',
            style: GoogleFonts.nunito(
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
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            Row(
              children: [
                Text(
                  '$value',
                  style: GoogleFonts.nunito(
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
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    weight,
                    style: GoogleFonts.nunito(
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
            color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: FractionallySizedBox(
            widthFactor: (value / 100).clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(9999),
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
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: Palette.textSecondary,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: GoogleFonts.nunito(
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
            color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(9999),
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
