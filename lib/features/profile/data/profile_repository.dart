import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/profile/domain/profile.dart';

class ProfileRepository {
  final AppDatabase db;
  const ProfileRepository(this.db);

  Future<Profile?> get(String id) async {
    final row = await (db.select(db.profiles)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return Profile(
      id: row.id,
      name: row.name,
      goal: row.goal,
      achievements: (jsonDecode(row.achievements) as List).cast<String>(),
    );
  }

  Future<void> save(Profile p) async {
    await db.into(db.profiles).insertOnConflictUpdate(
          ProfilesCompanion(
            id: Value(p.id),
            name: Value(p.name),
            goal: Value(p.goal),
            achievements: Value(jsonEncode(p.achievements)),
          ),
        );
  }
}
