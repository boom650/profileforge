import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';

/// Bridges the [SkinStates] Drift table to the domain [Skin] definitions.
class SkinRepository {
  SkinRepository(this._db);
  final AppDatabase _db;

  Future<List<SkinState>> all(String profileId) async {
    final rows = await (_db.select(_db.skinStates)
          ..where((t) => t.id.equals(profileId)))
        .get();
    return rows;
  }

  Future<void> unlock(String profileId, String skinId) async {
    await _db.into(_db.skinStates).insertOnConflictUpdate(SkinStatesCompanion(
      id: Value(profileId),
      skinId: Value(skinId),
      unlocked: const Value(true),
      unlockedAt: Value(DateTime.now()),
    ));
  }

  Future<void> equip(String profileId, String skinId) async {
    // Only one equipped at a time.
    await _db.update(_db.skinStates).write(const SkinStatesCompanion(equipped: Value(false)));
    await _db.into(_db.skinStates).insertOnConflictUpdate(SkinStatesCompanion(
      id: Value(profileId),
      skinId: Value(skinId),
      equipped: const Value(true),
    ));
  }

  /// Returns the currently equipped skin id, or null.
  Future<String?> equippedId(String profileId) async {
    final row = await (_db.select(_db.skinStates)
          ..where((t) => t.id.equals(profileId) & t.equipped.equals(true)))
        .getSingleOrNull();
    return row?.skinId;
  }
}
