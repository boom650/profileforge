import 'package:drift/drift.dart' as drift;
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';
import 'package:profileforge/features/notifications/domain/notification_models.dart';

/// Builds REAL notifications from the actual app database (streak row,
/// XP ledger, achievement unlocks × definitions) — nothing fabricated.
class NotificationRepository {
  final AppDatabase db;
  const NotificationRepository(this.db);

  Future<List<AppNotification>> build(String profileId) async {
    final list = <AppNotification>[];

    // 1 — streak status (real).
    final streak = await (db.select(db.streaks)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (streak != null && streak.current > 0) {
      list.add(AppNotification(
        id: 'streak',
        title: 'Streak: ${streak.current} day${streak.current == 1 ? '' : 's'}',
        message: streak.current >= 7
            ? 'Outstanding — you are on a ${streak.current}-day streak. Keep it going!'
            : streak.current == 1
                ? 'Day 1 done — come back tomorrow to keep it alive.'
                : 'You are ${streak.current} days strong. One more day!',
        type: NotificationType.streak,
        timestamp: streak.lastActiveDate ?? DateTime.now(),
        isRead: false,
      ));
    }

    // 2 — latest XP event (real ledger).
    final latestXp = await (db.select(db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.at)])
          ..limit(1))
        .getSingleOrNull();
    if (latestXp != null) {
      list.add(AppNotification(
        id: 'xp-${latestXp.id}',
        title: '+${latestXp.amount} XP · ${latestXp.source}',
        message: 'Balance: ${latestXp.balanceAfter} XP',
        type: NotificationType.score,
        timestamp: latestXp.at,
        isRead: false,
      ));
    }

    // 3 — latest achievement (real unlocks × defs).
    final unlocked = await (db.select(db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    if (unlocked.isNotEmpty) {
      final unlockedIds = unlocked.map((u) => u.achievementId).toSet();
      final last =
          AchievementDef.all.where((d) => unlockedIds.contains(d.id)).toList().reversed.firstOrNull;
      if (last != null) {
        list.add(AppNotification(
          id: 'achievement-${last.id}',
          title: 'Achievement Unlocked',
          message: '${last.name} — ${last.description}',
          type: NotificationType.achievement,
          timestamp: DateTime.now(),
          isRead: false,
        ));
      }
    }

    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }
}