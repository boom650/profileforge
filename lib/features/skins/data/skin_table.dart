import 'package:drift/drift.dart';

/// Persisted skin unlock + equip state.
class SkinStates extends Table {
  TextColumn get id => text()();
  TextColumn get skinId => text()();
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get equipped => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
