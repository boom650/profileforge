import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'mission_progress_dao.g.dart';

@DriftAccessor(tables: [MissionProgresses])
class MissionProgressDao extends DatabaseAccessor<AppDatabase> with _$MissionProgressDaoMixin {
  MissionProgressDao(super.db);

  Future<MissionProgressesData?> getProgress(String studentId, String missionId) => 
      (select(missionProgresses)
        ..where((mp) => mp.studentId.equals(studentId) & mp.missionId.equals(missionId)))
        .getSingleOrNull();

  Stream<MissionProgressesData?> watchProgress(String studentId, String missionId) => 
      (select(missionProgresses)
        ..where((mp) => mp.studentId.equals(studentId) & mp.missionId.equals(missionId)))
        .watchSingleOrNull();

  Future<List<MissionProgressesData>> getAllProgress(String studentId) => 
      (select(missionProgresses)..where((mp) => mp.studentId.equals(studentId))).get();

  Future<int> upsertProgress(MissionProgressesCompanion progress) => 
      into(missionProgresses).insertOnConflictUpdate(progress);

  Future<void> updateProgress(String studentId, String missionId, int progress, {bool completed = false}) async {
    final existing = await getProgress(studentId, missionId);
    final mission = await db.missionDao.getMission(missionId);
    
    if (mission == null) return;

    await upsertProgress(MissionProgressesCompanion(
      id: Value(existing?.id ?? const Uuid().v4()),
      studentId: Value(studentId),
      missionId: Value(missionId),
      currentProgress: Value(progress),
      isCompleted: Value(completed),
      completedAt: Value(completed ? DateTime.now() : null),
      xpEarned: Value(completed ? mission.xpReward : (existing?.xpEarned ?? 0)),
      coinsEarned: Value(completed ? mission.coinReward : (existing?.coinsEarned ?? 0)),
      streakCount: Value(completed ? (existing?.streakCount ?? 0) + 1 : (existing?.streakCount ?? 0)),
      lastUpdatedAt: Value(DateTime.now()),
    ));
  }

  Future<int> getCompletedCount(String studentId) async {
    final result = await (selectOnly(missionProgresses)
      ..addColumns([missionProgresses.id.count()])
      ..where(missionProgresses.studentId.equals(studentId) & missionProgresses.isCompleted.equals(true)))
      .getSingle();
    return result.read(missionProgresses.id.count()) ?? 0;
  }

  Future<int> getTotalXpEarned(String studentId) async {
    final result = await (selectOnly(missionProgresses)
      ..addColumns([missionProgresses.xpEarned.sum()])
      ..where(missionProgresses.studentId.equals(studentId)))
      .getSingle();
    return result.read(missionProgresses.xpEarned.sum()) ?? 0;
  }

  Future<int> getTotalCoinsEarned(String studentId) async {
    final result = await (selectOnly(missionProgresses)
      ..addColumns([missionProgresses.coinsEarned.sum()])
      ..where(missionProgresses.studentId.equals(studentId)))
      .getSingle();
    return result.read(missionProgresses.coinsEarned.sum()) ?? 0;
  }

  Future<Map<String, int>> getProgressByMission(String studentId) async {
    final rows = await (selectOnly(missionProgresses)
      ..addColumns([missionProgresses.missionId, missionProgresses.currentProgress, missionProgresses.isCompleted])
      ..where(missionProgresses.studentId.equals(studentId)))
      .get();

    final Map<String, int> result = {};
    for (final row in rows) {
      result[row.read(missionProgresses.missionId)!] = row.read(missionProgresses.currentProgress) ?? 0;
    }
    return result;
  }
}