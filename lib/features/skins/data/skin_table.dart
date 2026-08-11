import 'package:drift/drift.dart';

/// Persisted skin unlock + equip state.
/// Composite PK so ONE ROW PER SKIN per profile (a single-row PK {id}
/// silently overwrote previous unlocks — skins badges could never reach
/// thresholds 3/10).
class SkinStates extends Table {
  TextColumn get id => text()();
  TextColumn get skinId => text()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get equipped => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id, skinId};
}
