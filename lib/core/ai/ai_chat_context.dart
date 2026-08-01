import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/goals/application/goal_progress_tracker.dart';
import 'package:profileforge/features/achievements/application/achievement_trigger.dart';
import 'package:profileforge/features/missions/domain/integrated_mission_engine.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AiChatContext — provides the AI with full knowledge of the user's state.
///
/// When the user asks "What should I do?" or "How am I doing?", the AI
/// knows about their missions, goals, XP, streak, and achievements.
/// This creates a truly personalized experience.
/// ────────────────────────────────────────────────────────────────────────────
class AiChatContext {
  final GoalProgressTracker _goalTracker;
  final AchievementTrigger _achievementTrigger;
  final AppDatabase _db;

  AiChatContext(this._goalTracker, this._achievementTrigger, this._db);

  /// Build a comprehensive context string for the AI.
  Future<String> buildContext(String profileId) async {
    final progress = await _goalTracker.getProgress(profileId);
    final achievements = await _achievementTrigger.getAllAchievements(profileId);
    final recentMissions = await _getRecentMissions(profileId);

    final unlockedAchievements = achievements.where((a) => a.isUnlocked).toList();

    return '''
USER STATE:
- Primary Goal: ${_goalName(progress.primaryGoal)}
- XP: ${progress.xp} (Level ${(progress.xp / 100).floor() + 1})
- Streak: ${progress.streak} days
- Missions Completed: ${progress.missionsCompleted}
- Achievements Unlocked: ${unlockedAchievements.length}/${achievements.length}
- Goal Progress: ${(progress.progressPercent * 100).round()}%

NEXT MILESTONE: ${progress.nextMilestone}

ADVICE: ${progress.advice}

RECENT MISSIONS:
${recentMissions.map((m) => '- ${m.title} (${m.pillar}, ${m.xp} XP)').join('\n')}

UNLOCKED ACHIEVEMENTS:
${unlockedAchievements.map((a) => '- ${a.definition.icon} ${a.definition.title}').join('\n')}

When responding:
- Reference their specific goal and progress
- Suggest missions that align with their goal
- Acknowledge their achievements and streak
- Give concrete, actionable advice
- Be encouraging but honest about areas for improvement
''';
  }

  String _goalName(String goal) {
    switch (goal) {
      case 'mit': return 'Get into MIT';
      case 'stanford': return 'Get into Stanford';
      case 'ivy': return 'Get into Ivy League';
      case 'scholarship': return 'Win a scholarship';
      case 'skills': return 'Build skills';
      default: return 'General improvement';
    }
  }

  Future<List<_MissionInfo>> _getRecentMissions(String profileId) async {
    final events = await (_db.select(_db.xpEvents)
          ..where((t) =>
              t.profileId.equals(profileId) & t.source.equals('mission'))
          ..limit(5))
        .get();

    return events.map((e) => _MissionInfo(
      title: e.description ?? 'Mission',
      pillar: e.source,
      xp: e.xp,
    )).toList();
  }
}

class _MissionInfo {
  final String title;
  final String pillar;
  final int xp;
  _MissionInfo({required this.title, required this.pillar, required this.xp});
}

/// Provider for the AI chat context.
final aiChatContextProvider = Provider<AiChatContext>((ref) {
  final goalTracker = ref.watch(goalProgressTrackerProvider);
  final achievementTrigger = ref.watch(achievementTriggerProvider);
  final db = ref.watch(appDatabaseProvider);
  return AiChatContext(goalTracker, achievementTrigger, db);
});
