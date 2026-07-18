import 'package:drift/drift.dart';

/// Offline-first sync outbox. Every local mutation enqueues an op; the
/// sync service flushes the queue when connectivity returns, applying
/// last-write-wins conflict resolution server-side.
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()(); // streaks, missions, buddies...
  TextColumn get op => text()(); // upsert, delete
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
