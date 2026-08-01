import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';
import 'package:profileforge/features/goals/data/goal_repository.dart';
import 'package:profileforge/features/goals/application/goal_providers.dart';
import 'package:profileforge/features/ai_chat/application/ai_chat_provider.dart';
import 'package:profileforge/core/extensions/list_extensions.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// IntegratedMissionEngine — generates personalized missions that connect
/// the onboarding profile, user goals, AI recommendations, and streak system.
///
/// This is the brain of the app — it knows everything about the user and
/// generates missions that actually help them achieve their goals.
/// ────────────────────────────────────────────────────────────────────────────
class IntegratedMissionEngine {
  final GoalRepository _goalRepo;
  final AppDatabase _db;

  IntegratedMissionEngine(this._goalRepo, this._db);

  /// Generate a personalized daily mission set based on everything we know.
  Future<List<IntegratedMission>> generateMissions({
    required String profileId,
    required OnboardingProfile profile,
    List<String> recommendations = const [],
    int streak = 0,
  }) async {
    final missions = <IntegratedMission>[];
    final goal = await _goalRepo.getPrimaryGoal(profileId);

    // 1. Goal-aligned missions (highest priority)
    missions.addAll(_generateGoalMissions(goal, profile));

    // 2. Weakness-targeted missions (from grades)
    missions.addAll(_generateWeaknessMissions(profile));

    // 3. Recommendation-connected missions (from AI)
    missions.addAll(_generateRecommendationMissions(recommendations, profile));

    // 4. Streak-boosted missions (maintain consistency)
    missions.addAll(_generateStreakMissions(streak));

    // 5. Exploration missions (try new things)
    missions.addAll(_generateExplorationMissions(profile));

    // 6. Always: 1 quick win for dopamine
    missions.add(_generateQuickWin(profile));

    return missions;
  }

  /// Generate missions aligned with the user's primary goal.
  List<IntegratedMission> _generateGoalMissions(String goal, OnboardingProfile p) {
    final missions = <IntegratedMission>[];

    switch (goal) {
      case 'mit':
      case 'stanford':
      case 'ivy':
        // Elite school missions
        missions.add(IntegratedMission(
          id: 'goal-research',
          title: 'Research ${goal.toUpperCase()} admission requirements for 2026',
          pillar: 'academics',
          xp: 25,
          priority: 1,
          category: 'goal',
          rationale: 'Understanding admissions criteria is the first step',
        ));
        if (p.targetUniversities.isNotEmpty) {
          missions.add(IntegratedMission(
            id: 'goal-essay',
            title: 'Draft 1 paragraph of your ${p.targetUniversities.first} essay',
            pillar: 'academics',
            xp: 30,
            priority: 1,
            category: 'goal',
            rationale: 'Essays are 30% of your application weight',
          ));
        }
        break;
      case 'scholarship':
        missions.add(IntegratedMission(
          id: 'goal-scholarship',
          title: 'Find 3 scholarships matching your profile',
          pillar: 'research',
          xp: 20,
          priority: 1,
          category: 'goal',
          rationale: 'Scholarships need early research and deadlines',
        ));
        break;
      case 'skills':
        missions.add(IntegratedMission(
          id: 'goal-skills',
          title: 'Spend 30 min on a skill-building activity',
          pillar: 'personal',
          xp: 20,
          priority: 1,
          category: 'goal',
          rationale: 'Consistent skill practice compounds over time',
        ));
        break;
      default:
        // General improvement
        missions.add(IntegratedMission(
          id: 'goal-general',
          title: 'Review your weekly progress toward your goal',
          pillar: 'personal',
          xp: 15,
          priority: 2,
          category: 'goal',
          rationale: 'Regular reflection accelerates growth',
        ));
    }

    return missions;
  }

  /// Generate missions targeting the user's weakest subjects.
  List<IntegratedMission> _generateWeaknessMissions(OnboardingProfile p) {
    final missions = <IntegratedMission>[];
    if (p.grades.isEmpty) return missions;

    final weakest = p.grades.entries
        .reduce((a, b) => _pct(a.value) <= _pct(b.value) ? a : b);

    if (_pct(weakest.value) < 80) {
      missions.add(IntegratedMission(
        id: 'weak-${weakest.key}',
        title: 'Spend 25 min on ${weakest.key} — you\'re at ${weakest.value}',
        pillar: 'academics',
        xp: 20,
        priority: 2,
        category: 'weakness',
        rationale: 'Your ${weakest.key} grade is your biggest opportunity for growth',
      ));
    }

    return missions;
  }

  /// Generate missions connected to AI recommendations.
  List<IntegratedMission> _generateRecommendationMissions(
      List<String> recommendations, OnboardingProfile p) {
    final missions = <IntegratedMission>[];

    if (recommendations.isEmpty) return missions;

    // Take the first recommendation and create a mission around it
    final rec = recommendations.first;
    missions.add(IntegratedMission(
      id: 'rec-explore',
      title: 'Research: $rec',
      pillar: 'research',
      xp: 20,
      priority: 3,
      category: 'recommendation',
      rationale: 'AI found this opportunity near you — worth exploring',
    ));

    return missions;
  }

  /// Generate streak-related missions to maintain consistency.
  List<IntegratedMission> _generateStreakMissions(int streak) {
    final missions = <IntegratedMission>[];

    if (streak >= 7) {
      missions.add(IntegratedMission(
        id: 'streak-maintain',
        title: 'Keep your $streak-day streak alive — complete any mission',
        pillar: 'personal',
        xp: 15,
        priority: 1,
        category: 'streak',
        rationale: 'Streaks build habits. You\'re on a $streak-day roll!',
      ));
    }

    return missions;
  }

  /// Generate exploration missions to broaden horizons.
  List<IntegratedMission> _generateExplorationMissions(OnboardingProfile p) {
    final missions = <IntegratedMission>[];

    // If user has few activities, encourage exploration
    if (p.activities.length < 3) {
      missions.add(IntegratedMission(
        id: 'explore-activity',
        title: 'Explore 1 new club, organization, or activity',
        pillar: 'community',
        xp: 20,
        priority: 3,
        category: 'exploration',
        rationale: 'Diverse activities show intellectual curiosity',
      ));
    }

    // If user has no competitions, encourage finding one
    if (p.competitions.isEmpty) {
      missions.add(IntegratedMission(
        id: 'explore-comp',
        title: 'Find 1 competition or Olympiad in ${p.subjects.firstOrEmpty}',
        pillar: 'research',
        xp: 20,
        priority: 3,
        category: 'exploration',
        rationale: 'Competitions demonstrate academic excellence',
      ));
    }

    return missions;
  }

  /// Generate a quick win for instant gratification.
  IntegratedMission _generateQuickWin(OnboardingProfile p) {
    return IntegratedMission(
      id: 'quick-win',
      title: 'Write 3 things you\'re grateful for today',
      pillar: 'personal',
      xp: 5,
      priority: 4,
      category: 'wellbeing',
      rationale: 'Gratitude improves mental health and focus',
    );
  }

  int _pct(String v) {
    final m = RegExp(r'(\d+)').firstMatch(v.replaceAll('%', ''));
    return m == null ? 100 : int.tryParse(m.group(1)!) ?? 100;
  }
}

/// A mission with full context about why it matters.
class IntegratedMission {
  final String id;
  final String title;
  final String pillar;
  final int xp;
  final int priority; // 1 = highest
  final String category;
  final String rationale;

  const IntegratedMission({
    required this.id,
    required this.title,
    required this.pillar,
    required this.xp,
    required this.priority,
    required this.category,
    required this.rationale,
  });
}

/// Provider for the integrated mission engine.
final integratedMissionEngineProvider = Provider<IntegratedMissionEngine>((ref) {
  final goalRepo = ref.watch(goalRepoProvider);
  final db = ref.watch(appDatabaseProvider);
  return IntegratedMissionEngine(goalRepo, db);
});

/// Provider for personalized missions.
final personalizedMissionsProvider =
    FutureProvider.family<List<IntegratedMission>, String>(
  (ref, profileId) async {
    final engine = ref.watch(integratedMissionEngineProvider);
    // TODO: Load actual profile from database
    // For now, use default profile
    final profile = const OnboardingProfile();
    return engine.generateMissions(
      profileId: profileId,
      profile: profile,
    );
  },
);
