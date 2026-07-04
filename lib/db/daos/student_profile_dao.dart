import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';
import '../../services/encryption_service.dart';
part 'student_profile_dao.g.dart';

/// Mixin that provides PII encryption/decryption helpers for StudentProfileDao.
/// This mixin can be used with the generated DAO to add encryption support.
mixin StudentProfileEncryptionMixin on DatabaseAccessor<AppDatabase> {
  /// Create an encrypted companion from the given profile companion.
  /// Only encrypts PII fields: name, email, phone, coachingInstitute.
  StudentProfilesCompanion encryptPII(
    StudentProfilesCompanion profile,
    EncryptionService encryptionService,
  ) {
    return StudentProfilesCompanion(
      id: profile.id,
      name: profile.name.present
          ? Value(encryptionService.encrypt(profile.name.value))
          : profile.name,
      email: profile.email.present
          ? Value(encryptionService.encrypt(profile.email.value))
          : profile.email,
      phone: profile.phone.present
          ? Value(encryptionService.encrypt(profile.phone.value))
          : profile.phone,
      board: profile.board,
      stream: profile.stream,
      grade: profile.grade,
      subjects: profile.subjects,
      tenthPercentage: profile.tenthPercentage,
      coachingInstitute: profile.coachingInstitute.present
          ? Value(profile.coachingInstitute.value != null
              ? encryptionService.encrypt(profile.coachingInstitute.value!)
              : null)
          : profile.coachingInstitute,
      coachingHoursPerWeek: profile.coachingHoursPerWeek,
      satScore: profile.satScore,
      ieltsScore: profile.ieltsScore,
      targetCountries: profile.targetCountries,
      targetMajor: profile.targetMajor,
      reachUniversities: profile.reachUniversities,
      matchUniversities: profile.matchUniversities,
      safetyUniversities: profile.safetyUniversities,
      totalXp: profile.totalXp,
      totalCoins: profile.totalCoins,
      currentStreak: profile.currentStreak,
      longestStreak: profile.longestStreak,
      lastActiveDate: profile.lastActiveDate,
      currentSkinId: profile.currentSkinId,
      currentFrameId: profile.currentFrameId,
      equippedBadgesJson: profile.equippedBadgesJson,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }
}

@DriftAccessor(tables: [StudentProfiles])
class StudentProfileDao extends DatabaseAccessor<AppDatabase>
    with _$StudentProfileDaoMixin, StudentProfileEncryptionMixin {
  StudentProfileDao(super.db);

  // ── Read Operations ──────────────────────────────────────────────────

  Future<List<StudentProfile>> getAllProfiles() =>
      select(studentProfiles).get();

  Stream<List<StudentProfile>> watchAllProfiles() =>
      select(studentProfiles).watch();

  Future<StudentProfile?> getProfile(String id) =>
      (select(studentProfiles)..where((p) => p.id.equals(id)))
          .getSingleOrNull();

  Stream<StudentProfile?> watchProfile(String id) =>
      (select(studentProfiles)..where((p) => p.id.equals(id)))
          .watchSingleOrNull();

  // ── Write Operations (with optional encryption) ──────────────────────

  /// Insert a profile. Pass [encryptionService] to encrypt PII before storage.
  Future<int> insertProfile(
    StudentProfilesCompanion profile, {
    EncryptionService? encryptionService,
  }) {
    final toInsert = (encryptionService != null && encryptionService.isEncryptionEnabled)
        ? encryptPII(profile, encryptionService)
        : profile;
    return into(studentProfiles).insert(toInsert);
  }

  /// Update a profile. Pass [encryptionService] to encrypt PII before storage.
  Future<bool> updateProfile(
    StudentProfilesCompanion profile, {
    EncryptionService? encryptionService,
  }) {
    final toUpdate = (encryptionService != null && encryptionService.isEncryptionEnabled)
        ? encryptPII(profile, encryptionService)
        : profile;
    return update(studentProfiles).replace(toUpdate);
  }

  Future<int> deleteProfile(String id) =>
      (delete(studentProfiles)..where((p) => p.id.equals(id))).go();

  Future<void> updateLastActive(String id) =>
      (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
        lastActiveDate: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> incrementXp(String id, int xp) async =>
      (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
        totalXp: Value(((await getProfile(id))?.totalXp ?? 0) + xp),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> incrementCoins(String id, int coins) async =>
      (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
        totalCoins: Value(((await getProfile(id))?.totalCoins ?? 0) + coins),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> updateStreak(String id, {int? current, int? longest}) async {
    final profile = await getProfile(id);
    if (profile == null) return;

    (update(studentProfiles)..where((p) => p.id.equals(id)))
        .write(StudentProfilesCompanion(
      currentStreak: current != null ? Value(current) : const Value.absent(),
      longestStreak:
          longest != null ? Value(longest) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> equipSkin(String id, String skinId) =>
      (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
        currentSkinId: Value(skinId),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> equipFrame(String id, String frameId) =>
      (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
        currentFrameId: Value(frameId),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> addEquippedBadge(String id, String badgeId) async {
    final profile = await getProfile(id);
    if (profile == null) return;

    final badges = List<String>.from(profile.equippedBadgesJson ?? []);
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await (update(studentProfiles)..where((p) => p.id.equals(id)))
          .write(StudentProfilesCompanion(
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
    await (update(studentProfiles)..where((p) => p.id.equals(id)))
        .write(StudentProfilesCompanion(
      equippedBadgesJson: Value(badges),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Delete all student data (for account deletion / COPPA compliance).
  Future<void> deleteAllData() => delete(studentProfiles).go();
}
