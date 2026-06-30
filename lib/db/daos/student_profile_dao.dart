import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'student_profile_dao.g.dart';

@DriftAccessor(tables: [StudentProfiles])
class StudentProfileDao extends DatabaseAccessor<AppDatabase> with _$StudentProfileDaoMixin {
  StudentProfileDao(super.db);

  Future<List<StudentProfile>> getAllProfiles() => select(studentProfiles).get();

  Stream<List<StudentProfile>> watchAllProfiles() => select(studentProfiles).watch();

  Future<StudentProfile?> getProfile(String id) => 
      (select(studentProfiles)..where((p) => p.id.equals(id))).getSingleOrNull();

  Stream<StudentProfile?> watchProfile(String id) => 
      (select(studentProfiles)..where((p) => p.id.equals(id))).watchSingleOrNull();

  Future<int> insertProfile(StudentProfilesCompanion profile) => 
      into(studentProfiles).insert(profile);

  Future<bool> updateProfile(StudentProfilesCompanion profile) => 
      update(studentProfiles).replace(profile);

  Future<int> deleteProfile(String id) => 
      (delete(studentProfiles)..where((p) => p.id.equals(id))).go();

  Future<void> updateLastActive(String id) => 
      (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        lastActiveDate: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> incrementXp(String id, int xp) => 
      (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        totalXp: Value((await getProfile(id))?.totalXp ?? 0 + xp),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> incrementCoins(String id, int coins) => 
      (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        totalCoins: Value((await getProfile(id))?.totalCoins ?? 0 + coins),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> updateStreak(String id, {int? current, int? longest}) async {
    final profile = await getProfile(id);
    if (profile == null) return;
    
    (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
      currentStreak: current != null ? Value(current) : const Value.absent(),
      longestStreak: longest != null ? Value(longest) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> equipSkin(String id, String skinId) => 
      (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        currentSkinId: Value(skinId),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> equipFrame(String id, String frameId) => 
      (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        currentFrameId: Value(frameId),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> addEquippedBadge(String id, String badgeId) async {
    final profile = await getProfile(id);
    if (profile == null) return;
    
    final badges = List<String>.from(profile.equippedBadgesJson ?? []);
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
        equippedBadgesJson: Value(badges),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  Future<void> removeEquippedBadge(String id, String badgeId) async {
    final profile = await getProfile(id);
    if (profile == null) return;
    
    final badges = List<String>.from(profile.equippedBadgesJson ?? []);
    badges.remove(badgeId);
    await (update(studentProfiles)..where((p) => p.id.equals(id))).write(StudentProfilesCompanion(
      equippedBadgesJson: Value(badges),
      updatedAt: Value(DateTime.now()),
    ));
  }
}