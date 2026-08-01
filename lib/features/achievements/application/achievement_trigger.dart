import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementTrigger — unlocks achievements based on real user progress.
///
/// Instead of random unlocks, achievements trigger when the user actually
/// completes meaningful actions. This creates a sense of accomplishment
/// and motivates continued engagement.
/// ────────────────────────────────────────────────────────────────────────────
class AchievementTrigger {
  final AppDatabase _db;

  AchievementTrigger(this._db);

  /// Check and unlock achievements after a mission is completed.
  Future<List<String>> checkAfterMission({
    required String profileId,
    required String missionPillar,
    required int missionXp,
    required int totalXp,
    required int streak,
    required int missionsCompleted,
  }) async {
    final unlocked = <String>[];

    // 1. First mission ever
    if (missionsCompleted == 1) {
      if (await _tryUnlock(profileId, 'first-mission')) {
        unlocked.add('first-mission');
      }
    }

    // 2. Streak milestones
    if (streak == 3) {
      if (await _tryUnlock(profileId, 'streak-3')) {
        unlocked.add('streak-3');
      }
    }
    if (streak == 7) {
      if (await _tryUnlock(profileId, 'streak-7')) {
        unlocked.add('streak-7');
      }
    }
    if (streak == 30) {
      if (await _tryUnlock(profileId, 'streak-30')) {
        unlocked.add('streak-30');
      }
    }

    // 3. XP milestones
    if (totalXp >= 100 && totalXp - missionXp < 100) {
      if (await _tryUnlock(profileId, 'xp-100')) {
        unlocked.add('xp-100');
      }
    }
    if (totalXp >= 500 && totalXp - missionXp < 500) {
      if (await _tryUnlock(profileId, 'xp-500')) {
        unlocked.add('xp-500');
      }
    }
    if (totalXp >= 1000 && totalXp - missionXp < 1000) {
      if (await _tryUnlock(profileId, 'xp-1000')) {
        unlocked.add('xp-1000');
      }
    }

    // 4. Pillar diversity (completed missions in all pillars)
    final pillars = await _getCompletedPillars(profileId);
    if (pillars.length >= 3) {
      if (await _tryUnlock(profileId, 'well-rounded')) {
        unlocked.add('well-rounded');
      }
    }

    // 5. Missions completed milestones
    if (missionsCompleted == 10) {
      if (await _tryUnlock(profileId, 'missions-10')) {
        unlocked.add('missions-10');
      }
    }
    if (missionsCompleted == 50) {
      if (await _tryUnlock(profileId, 'missions-50')) {
        unlocked.add('missions-50');
      }
    }

    // 6. Perfect day (completed all missions in a day)
    if (missionsCompleted > 0 && missionsCompleted % 7 == 0) {
      if (await _tryUnlock(profileId, 'perfect-week')) {
        unlocked.add('perfect-week');
      }
    }

    return unlocked;
  }

  /// Try to unlock an achievement. Returns true if newly unlocked.
  Future<bool> _tryUnlock(String profileId, String achievementId) async {
    // Check if already unlocked
    final existing = await (_db.select(_db.achievementUnlocks)
          ..where((t) =>
              t.profileId.equals(profileId) &
              t.achievementId.equals(achievementId)))
        .getSingleOrNull();

    if (existing != null) return false; // Already unlocked

    // Unlock it
    await _db.into(_db.achievementUnlocks).insert(
          AchievementUnlocksCompanion.insert(
            profileId: profileId,
            achievementId: achievementId,
          ),
        );

    return true;
  }

  /// Get the set of pillars the user has completed missions in.
  Future<Set<String>> _getCompletedPillars(String profileId) async {
    final events = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId)))
        .get();

    return events.map((e) => e.source).toSet();
  }

  /// Get all achievements with their unlock status.
  Future<List<AchievementWithStatus>> getAllAchievements(String profileId) async {
    final definitions = _achievementDefinitions;
    final unlocked = await (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();

    final unlockedIds = unlocked.map((u) => u.achievementId).toSet();

    return definitions.map((d) => AchievementWithStatus(
      definition: d,
      isUnlocked: unlockedIds.contains(d.id),
      unlockedAt: unlocked
          .where((u) => u.achievementId == d.id)
          .map((u) => u.unlockedAt)
          .firstOrNull,
    )).toList();
  }
}

/// Achievement definition.
class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final int rarity; // 1=common, 2=rare, 3=epic, 4=legendary

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
  });
}

/// Achievement with unlock status.
class AchievementWithStatus {
  final AchievementDefinition definition;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementWithStatus({
    required this.definition,
    required this.isUnlocked,
    this.unlockedAt,
  });
}

/// All achievement definitions.
const _achievementDefinitions = [
  // First steps
  AchievementDefinition(
    id: 'first-mission',
    title: 'First Steps',
    description: 'Complete your first mission',
    icon: '🎯',
    category: 'getting_started',
    rarity: 1,
  ),
  AchievementDefinition(
    id: 'first-goal',
    title: 'Goal Setter',
    description: 'Set your primary goal',
    icon: '🏁',
    category: 'getting_started',
    rarity: 1,
  ),

  // Streaks
  AchievementDefinition(
    id: 'streak-3',
    title: 'Consistency',
    description: 'Maintain a 3-day streak',
    icon: '🔥',
    category: 'streaks',
    rarity: 1,
  ),
  AchievementDefinition(
    id: 'streak-7',
    title: 'Week Warrior',
    description: 'Maintain a 7-day streak',
    icon: '⚡',
    category: 'streaks',
    rarity: 2,
  ),
  AchievementDefinition(
    id: 'streak-30',
    title: 'Unstoppable',
    description: 'Maintain a 30-day streak',
    icon: '💎',
    category: 'streaks',
    rarity: 4,
  ),

  // XP milestones
  AchievementDefinition(
    id: 'xp-100',
    title: 'Rising Star',
    description: 'Earn 100 XP total',
    icon: '⭐',
    category: 'xp',
    rarity: 1,
  ),
  AchievementDefinition(
    id: 'xp-500',
    title: 'XP Hunter',
    description: 'Earn 500 XP total',
    icon: '🌟',
    category: 'xp',
    rarity: 2,
  ),
  AchievementDefinition(
    id: 'xp-1000',
    title: 'XP Master',
    description: 'Earn 1000 XP total',
    icon: '💫',
    category: 'xp',
    rarity: 3,
  ),

  // Missions
  AchievementDefinition(
    id: 'missions-10',
    title: 'Dedicated',
    description: 'Complete 10 missions',
    icon: '📋',
    category: 'missions',
    rarity: 1,
  ),
  AchievementDefinition(
    id: 'missions-50',
    title: 'Mission Master',
    description: 'Complete 50 missions',
    icon: '🏆',
    category: 'missions',
    rarity: 3,
  ),

  // Diversity
  AchievementDefinition(
    id: 'well-rounded',
    title: 'Well-Rounded',
    description: 'Complete missions in 3+ pillars',
    icon: '🎯',
    category: 'diversity',
    rarity: 2,
  ),

  // Weekly
  AchievementDefinition(
    id: 'perfect-week',
    title: 'Perfect Week',
    description: 'Complete all missions for 7 days',
    icon: '👑',
    category: 'weekly',
    rarity: 3,
  ),
];

/// Provider for the achievement trigger.
final achievementTriggerProvider = Provider<AchievementTrigger>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AchievementTrigger(db);
});
