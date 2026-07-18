import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

class BuddyRepository {
  BuddyRepository(this._db);
  final AppDatabase _db;

  Future<void> addBuddy(String myProfileId, String buddyId) async {
    try {
      await _db.into(_db.buddies).insertOnConflictUpdate(BuddiesCompanion(
        profileId: Value(myProfileId),
        buddyProfileId: Value(buddyId),
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BuddyRow>> listBuddies(String profileId) async {
    try {
      return (_db.select(_db.buddies)
            ..where((t) => t.profileId.equals(profileId)))
          .get();
    } catch (e) {
      return const [];
    }
  }

  Future<void> recordCheckIn(String from, String to, int xp, String note) async {
    try {
      await _db.into(_db.buddyCheckIns).insert(BuddyCheckInsCompanion(
        fromProfileId: Value(from),
        toProfileId: Value(to),
        xp: Value(xp),
        note: Value(note),
      ));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BuddyCheckInRow>> recentCheckIns(String profileId) async {
    try {
      final rows = await (_db.select(_db.buddyCheckIns)
            ..where((t) => t.toProfileId.equals(profileId))
            ..orderBy([(t) => OrderingTerm.desc(t.id)]))
          .get();
      return rows;
    } catch (e) {
      return const [];
    }
  }
}
