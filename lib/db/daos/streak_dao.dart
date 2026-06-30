import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'streak_dao.g.dart';

@DriftAccessor(tables: [Streaks])
class StreakDao extends DatabaseAccessor<AppDatabase> with _$StreakDaoMixin {
  StreakDao(super.db);

  Future<StreakData?> getStreak(String studentId, String type) => 
      (select(streaks)..where((s) => s.studentId.equals(studentId) & s.type.equals(type))).getSingleOrNull();

  Stream<StreakData?> watchStreak(String studentId, String type) => 
      (select(streaks)..where((s) => s.studentId.equals(studentId) & s.type.equals(type))).watchSingleOrNull();

  Future<List<StreakData>> getAllStreaks(String studentId) => 
      (select(streaks)..where((s) => s.studentId.equals(studentId))).get();

  Future<int> upsertStreak(StreaksCompanion streak) => 
      into(streaks).insertOnConflictUpdate(streak);

  Future<void> incrementStreak(String studentId, String type) async {
    final existing = await getStreak(studentId, type);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = existing?.lastActivityDate != null 
        ? DateTime(existing!.lastActivityDate!.year, existing.lastActivityDate!.month, existing.lastActivityDate!.day)
        : null;
    
    int newStreak = 1;
    DateTime newStreakStart = today;
    
    if (lastDate != null) {
      final diff = today.difference(lastDate).inDays;
      if (diff == 1) {
        // Consecutive day
        newStreak = (existing?.currentStreak ?? 0) + 1;
        newStreakStart = existing?.streakStartDate ?? today;
      } else if (diff == 0) {
        // Already logged today
        return;
      } else {
        // Streak broken
        newStreak = 1;
        newStreakStart = today;
      }
    }

    final longestStreak = newStreak > (existing?.longestStreak ?? 0) ? newStreak : (existing?.longestStreak ?? 0);

    await upsertStreak(StreaksCompanion(
      id: Value(existing?.id ?? const Uuid().v4()),
      studentId: Value(studentId),
      type: Value(type),
      currentStreak: Value(newStreak),
      longestStreak: Value(longestStreak),
      lastActivityDate: Value(today),
      streakStartDate: Value(newStreakStart),
      totalDays: Value((existing?.totalDays ?? 0) + 1),
      isActive: const Value(true),
    ));
  }

  Future<void> resetStreak(String studentId, String type) async {
    await (update(streaks)
      ..where((s) => s.studentId.equals(studentId) & s.type.equals(type)))
      .write(StreaksCompanion(
        currentStreak: const Value(0),
        streakStartDate: Value(DateTime.now()),
        isActive: const Value(false),
      ));
  }

  Future<int> getLongestStreak(String studentId, String type) async {
    final streak = await getStreak(studentId, type);
    return streak?.longestStreak ?? 0;
  }

  Future<int> getCurrentStreak(String studentId, String type) async {
    final streak = await getStreak(studentId, type);
    return streak?.currentStreak ?? 0;
  }

  Future<bool> isStreakActive(String studentId, String type) async {
    final streak = await getStreak(studentId, type);
    return streak?.isActive ?? false;
  }
}