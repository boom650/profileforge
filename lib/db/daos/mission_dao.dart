import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../tables/all_tables.dart';
import '../database.dart';
import '../../models/gamification/missions.dart'
    show MissionCategory, MissionType;

part 'mission_dao.g.dart';

@DriftAccessor(tables: [Missions, MissionProgresses])
class MissionDao extends DatabaseAccessor<AppDatabase> with _$MissionDaoMixin {
  MissionDao(super.db);

  Future<List<Mission>> getAllMissions() => 
      (select(missions)..orderBy([(m) => OrderingTerm.asc(m.sortOrder)])).get();

  Stream<List<Mission>> watchAllMissions() => 
      (select(missions)..orderBy([(m) => OrderingTerm.asc(m.sortOrder)])).watch();

  Future<List<Mission>> getActiveMissions() => 
      (select(missions)
        ..where((m) => m.isActive.equals(true))
        ..orderBy([(m) => OrderingTerm.asc(m.sortOrder)]))
        .get();

  Future<List<Mission>> getMissionsByCategory(MissionCategory category) => 
      (select(missions)
        ..where((m) => m.category.equals(category.name) & m.isActive.equals(true))
        ..orderBy([(m) => OrderingTerm.asc(m.sortOrder)]))
      .get();

  Future<List<Mission>> getMissionsByType(MissionType type) =>
      (select(missions)
        ..where((m) => m.type.equals(type.name) & m.isActive.equals(true))
        ..orderBy([(m) => OrderingTerm.asc(m.sortOrder)]))
      .get();

  Future<List<Mission>> getDailyMissions() => getMissionsByType(MissionType.daily);
  Future<List<Mission>> getWeeklyMissions() => getMissionsByType(MissionType.weekly);
  Future<List<Mission>> getMilestoneMissions() => getMissionsByType(MissionType.milestone);
  Future<List<Mission>> getSpecialMissions() => getMissionsByType(MissionType.special);

  Future<Mission?> getMission(String id) => 
      (select(missions)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<int> insertMission(MissionsCompanion mission) => 
      into(missions).insert(mission);

  Future<bool> updateMission(MissionsCompanion mission) => 
      update(missions).replace(mission);

  Future<int> deleteMission(String id) => 
      (delete(missions)..where((m) => m.id.equals(id))).go();

  // Mission Progress
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

  Future<void> incrementProgress(String studentId, String missionId, int amount) async {
    final existing = await getProgress(studentId, missionId);
    final mission = await getMission(missionId);
    if (mission == null) return;

    final newProgress = (existing?.currentProgress ?? 0) + amount;
    final isCompleted = newProgress >= mission.requiredCount && !(existing?.isCompleted ?? false);
    
    await upsertProgress(MissionProgressesCompanion(
      id: Value(existing?.id ?? const Uuid().v4()),
      studentId: Value(studentId),
      missionId: Value(missionId),
      currentProgress: Value(newProgress),
      isCompleted: Value(isCompleted),
      completedAt: Value(isCompleted ? DateTime.now() : null),
      xpEarned: Value(isCompleted ? mission.xpReward : (existing?.xpEarned ?? 0)),
      coinsEarned: Value(isCompleted ? mission.coinReward : (existing?.coinsEarned ?? 0)),
      lastUpdatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> completeMission(String studentId, String missionId) async {
    final mission = await getMission(missionId);
    if (mission == null) return;

    await upsertProgress(MissionProgressesCompanion(
      id: Value(const Uuid().v4()),
      studentId: Value(studentId),
      missionId: Value(missionId),
      currentProgress: Value(mission.requiredCount),
      isCompleted: Value(true),
      completedAt: Value(DateTime.now()),
      xpEarned: Value(mission.xpReward),
      coinsEarned: Value(mission.coinReward),
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
}