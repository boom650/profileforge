import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';

class MissionRepository {
  MissionRepository(this._db);
  final AppDatabase _db;

  Future<void> upsertGenerated(List<Mission> missions) async {
    try {
      for (final m in missions) {
        await _db.into(_db.missions).insertOnConflictUpdate(MissionsCompanion(
          id: Value(m.id),
          profileId: Value(m.profileId),
          title: Value(m.title),
          pillar: Value(m.pillar.name),
          cadence: Value(m.cadence.name),
          due: Value(m.dueAt),
          done: Value(m.completed),
          xpReward: Value(m.xpReward),
        ));
      }
    } catch (e) {
      // TODO: enqueue to SyncOutbox for retry.
      rethrow;
    }
  }

  Future<List<MissionRow>> listDue(String profileId, DateTime now) async {
    try {
      return (_db.select(_db.missions)
            ..where((t) => t.profileId.equals(profileId) & t.done.equals(false)))
          .get();
    } catch (e) {
      return const [];
    }
  }

  Future<void> complete(String missionId) async {
    try {
      await (_db.update(_db.missions)..where((t) => t.id.equals(missionId)))
          .write(const MissionsCompanion(done: Value(true)));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MissionRow>> history(String profileId) async {
    try {
      return (_db.select(_db.missions)
            ..where((t) => t.profileId.equals(profileId)))
          .get();
    } catch (e) {
      return const [];
    }
  }
}
