import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';

/// Active user session. Offline-first: a single local profile is the default.
/// Multi-profile + auth arrive with H9 (backend). For now the device profile id
/// is stable and created on first launch.
final activeProfileIdProvider = FutureProvider<String>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  const id = 'local-profile';
  final existing = await (db.select(db.profiles)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  if (existing == null) {
    await db.into(db.profiles).insert(
          ProfilesCompanion.insert(id: id, name: const Value('')),
        );
  }
  return id;
});
