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
              description: Value(m.description),
              pillar: Value(m.pillar.name),
              cadence: Value(m.cadence.name),
              due: Value(m.dueAt),
              done: Value(m.completed),
              xpReward: Value(m.xpReward),
              gemReward: Value(m.gemReward),
              source: Value(m.source),
              priority: Value(m.priority),
              rationale: Value(m.rationale),
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

  /// Non-completed missions for a specific cadence.
  Future<List<MissionRow>> listForCadence(
      String profileId, MissionCadence cadence) async {
    try {
      return (_db.select(_db.missions)
            ..where((t) => t.profileId.equals(profileId) &
                t.cadence.equals(cadence.name) &
                t.done.equals(false)))
          .get();
    } catch (e) {
      return const [];
    }
  }

  /// How many missions currently exist (across all cadences) for a profile.
  Future<int> countOpen(String profileId) async {
    try {
      final rows = await (_db.select(_db.missions)
            ..where((t) => t.profileId.equals(profileId) & t.done.equals(false)))
          .get();
      return rows.length;
    } catch (e) {
      return 0;
    }
  }

  /// Delete a cadence's open missions (used before regenerating that cadence).
  Future<void> deleteOpenForCadence(
      String profileId, MissionCadence cadence) async {
    await (_db.delete(_db.missions)
          ..where((t) => t.profileId.equals(profileId) &
              t.cadence.equals(cadence.name) &
              t.done.equals(false)))
        .go();
  }

  /// Marks a mission done. Returns the number of rows actually flipped
  /// (0 = already done) so callers can award XP/gems idempotently —
  /// completing an already-done mission must never re-award (gauntlet B:
  /// "the completion reward is farmable").
  Future<int> complete(String missionId) async {
    try {
      return await (_db.update(_db.missions)
            ..where((t) => t.id.equals(missionId) & t.done.equals(false)))
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