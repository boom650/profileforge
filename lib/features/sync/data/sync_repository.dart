import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

class SyncRepository {
  SyncRepository(this._db);
  final AppDatabase _db;

  Future<int> enqueue(String entity, String op, String payload) async {
    return _db.into(_db.syncOutbox).insert(SyncOutboxCompanion(
      entity: Value(entity),
      kind: Value(op),
      payload: Value(payload),
    ));
  }

  Future<List<SyncOutboxRow>> pending() async {
    return (_db.select(_db.syncOutbox)
          ..where((t) => t.done.equals(false))
          ..orderBy([(t) => t.queuedAt.desc()]))
        .get();
  }

  Future<void> markDone(int id) async {
    await (_db.update(_db.syncOutbox)..where((t) => t.id.equals(id)))
        .write(const SyncOutboxCompanion(done: Value(true)));
  }

  Future<void> bumpAttempts(int id) async {
    final row = await (_db.select(_db.syncOutbox)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row != null) {
      await (_db.update(_db.syncOutbox)..where((t) => t.id.equals(id)))
          .write(SyncOutboxCompanion(attempts: Value(row.attempts + 1)));
    }
  }
}
