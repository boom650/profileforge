import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/goals/data/goal_repository.dart';
import 'package:profileforge/features/goals/application/goal_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// GoalProgressTracker — tracks how goals connect to missions and XP.
///
/// Shows the user their progress toward their goals with concrete metrics.
/// This creates a clear path from "where I am" to "where I want to be."
/// ────────────────────────────────────────────────────────────────────────────
class GoalProgressTracker {
  final GoalRepository _goalRepo;
  final AppDatabase _db;

  GoalProgressTracker(this._goalRepo, this._db);

  /// Get comprehensive progress toward the user's primary goal.
  Future<GoalProgress> getProgress(String profileId) async {
    final goal = await _goalRepo.getPrimaryGoal(profileId);
    final xp = await _getXpBalance(profileId);
    final streak = await _getStreak(profileId);
    final missionsCompleted = await _getMissionsCompleted(profileId);
    final achievementsUnlocked = await _getAchievementsUnlocked(profileId);

    // Calculate goal-specific progress
    final goalProgress = _calculateGoalProgress(
      goal: goal,
      xp: xp,
      streak: streak,
      missionsCompleted: missionsCompleted,
      achievementsUnlocked: achievementsUnlocked,
    );

    // Get next milestone
    final nextMilestone = _getNextMilestone(
      goal: goal,
      xp: xp,
      streak: streak,
      missionsCompleted: missionsCompleted,
    );

    // Get personalized advice
    final advice = _getAdvice(
      goal: goal,
      xp: xp,
      streak: streak,
      missionsCompleted: missionsCompleted,
    );

    return GoalProgress(
      primaryGoal: goal,
      xp: xp,
      streak: streak,
      missionsCompleted: missionsCompleted,
      achievementsUnlocked: achievementsUnlocked,
      progressPercent: goalProgress,
      nextMilestone: nextMilestone,
      advice: advice,
    );
  }

  /// Calculate progress percentage toward the goal.
  double _calculateGoalProgress({
    required String goal,
    required int xp,
    required int streak,
    required int missionsCompleted,
    required int achievementsUnlocked,
  }) {
    // Each goal has different success criteria
    switch (goal) {
      case 'mit':
      case 'stanford':
      case 'ivy':
        // Elite school: need diverse achievements, high XP, strong streak
        final xpProgress = (xp / 1000).clamp(0.0, 0.4);
        final streakProgress = (streak / 30).clamp(0.0, 0.3);
        final missionProgress = (missionsCompleted / 50).clamp(0.0, 0.2);
        final achieveProgress = (achievementsUnlocked / 10).clamp(0.0, 0.1);
        return xpProgress + streakProgress + missionProgress + achieveProgress;

      case 'scholarship':
        // Scholarship: need consistent effort and XP
        final xpProgress = (xp / 500).clamp(0.0, 0.5);
        final streakProgress = (streak / 14).clamp(0.0, 0.3);
        final missionProgress = (missionsCompleted / 30).clamp(0.0, 0.2);
        return xpProgress + streakProgress + missionProgress;

      case 'skills':
        // Skills: need consistent practice
        final streakProgress = (streak / 21).clamp(0.0, 0.5);
        final missionProgress = (missionsCompleted / 40).clamp(0.0, 0.5);
        return streakProgress + missionProgress;

      default:
        // General: balanced progress
        final xpProgress = (xp / 300).clamp(0.0, 0.33);
        final streakProgress = (streak / 7).clamp(0.0, 0.33);
        final missionProgress = (missionsCompleted / 20).clamp(0.0, 0.34);
        return xpProgress + streakProgress + missionProgress;
    }
  }

  /// Get the next milestone the user should work toward.
  String _getNextMilestone({
    required String goal,
    required int xp,
    required int streak,
    required int missionsCompleted,
  }) {
    // XP milestones
    if (xp < 100) return 'Earn 100 XP (currently $xp)';
    if (xp < 500) return 'Earn 500 XP (currently $xp)';
    if (xp < 1000) return 'Earn 1000 XP (currently $xp)';

    // Streak milestones
    if (streak < 3) return 'Build a 3-day streak';
    if (streak < 7) return 'Build a 7-day streak';
    if (streak < 30) return 'Build a 30-day streak';

    // Mission milestones
    if (missionsCompleted < 10) return 'Complete 10 missions';
    if (missionsCompleted < 50) return 'Complete 50 missions';

    // Goal-specific
    switch (goal) {
      case 'mit':
      case 'stanford':
      case 'ivy':
        return 'Build a diverse portfolio of achievements';
      case 'scholarship':
        return 'Research and apply to scholarships';
      case 'skills':
        return 'Master your chosen skill area';
      default:
        return 'Keep building momentum';
    }
  }

  /// Get personalized advice based on current progress.
  String _getAdvice({
    required String goal,
    required int xp,
    required int streak,
    required int missionsCompleted,
  }) {
    if (missionsCompleted == 0) {
      return 'Start with your first mission to build momentum!';
    }

    if (streak < 3) {
      return 'Consistency is key. Complete missions daily to build your streak.';
    }

    if (xp < 100) {
      return 'You\'re building XP. Focus on higher-value missions for faster progress.';
    }

    if (streak >= 7 && missionsCompleted < 10) {
      return 'Great streak! Now focus on completing more missions each day.';
    }

    // Goal-specific advice
    switch (goal) {
      case 'mit':
      case 'stanford':
      case 'ivy':
        if (missionsCompleted < 20) {
          return 'Build a strong foundation first. Diversify your activities.';
        }
        return 'Focus on depth over quantity. Quality achievements matter most.';

      case 'scholarship':
        return 'Research deadlines early. Many scholarships close months before school starts.';

      case 'skills':
        return 'Practice consistently. 30 minutes daily beats 3 hours weekly.';

      default:
        return 'Keep going! You\'re making progress every day.';
    }
  }

  Future<int> _getXpBalance(String profileId) async {
    final events = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return events.fold(0, (sum, e) => sum + e.xp);
  }

  Future<int> _getStreak(String profileId) async {
    final streak = await (_db.select(_db.streaks)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return streak?.currentStreak ?? 0;
  }

  Future<int> _getMissionsCompleted(String profileId) async {
    final events = await (_db.select(_db.xpEvents)
          ..where((t) =>
              t.profileId.equals(profileId) & t.source.equals('mission')))
        .get();
    return events.length;
  }

  Future<int> _getAchievementsUnlocked(String profileId) async {
    final unlocks = await (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return unlocks.length;
  }
}

/// Comprehensive goal progress data.
class GoalProgress {
  final String primaryGoal;
  final int xp;
  final int streak;
  final int missionsCompleted;
  final int achievementsUnlocked;
  final double progressPercent;
  final String nextMilestone;
  final String advice;

  const GoalProgress({
    required this.primaryGoal,
    required this.xp,
    required this.streak,
    required this.missionsCompleted,
    required this.achievementsUnlocked,
    required this.progressPercent,
    required this.nextMilestone,
    required this.advice,
  });
}

/// Provider for the goal progress tracker.
final goalProgressTrackerProvider = Provider<GoalProgressTracker>((ref) {
  final goalRepo = ref.watch(goalRepoProvider);
  final db = ref.watch(appDatabaseProvider);
  return GoalProgressTracker(goalRepo, db);
});

/// Provider for goal progress.
final goalProgressProvider =
    FutureProvider.family<GoalProgress, String>((ref, profileId) async {
  final tracker = ref.watch(goalProgressTrackerProvider);
  return tracker.getProgress(profileId);
});
