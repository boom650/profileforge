import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'skin_collection_dao.g.dart';

@DriftAccessor(tables: [SkinCollections])
class SkinCollectionDao extends DatabaseAccessor<AppDatabase> with _$SkinCollectionDaoMixin {
  SkinCollectionDao(super.db);

  Future<SkinCollection?> getCollectionItem(String studentId, String skinId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId) & sc.skinId.equals(skinId)))
        .getSingleOrNull();

  Stream<SkinCollection?> watchCollectionItem(String studentId, String skinId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId) & sc.skinId.equals(skinId)))
        .watchSingleOrNull();

  Future<List<SkinCollection>> getStudentCollection(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId))
        ..orderBy([(sc) => OrderingTerm.asc(sc.createdAt)]))
        .get();

  Stream<List<SkinCollection>> watchStudentCollection(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId))
        ..orderBy([(sc) => OrderingTerm.asc(sc.createdAt)]))
        .watch();

  Future<List<SkinCollection>> getUnlockedCollection(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId) & sc.isUnlocked.equals(true)))
        .get();

  Future<int> upsertCollectionItem(SkinCollectionsCompanion item) => 
      into(skinCollections).insertOnConflictUpdate(item);

  Future<void> unlockSkin(String studentId, String skinId, {int? progress}) async {
    final existing = await getCollectionItem(studentId, skinId);
    await upsertCollectionItem(SkinCollectionsCompanion(
      id: Value(existing?.id ?? const Uuid().v4()),
      studentId: Value(studentId),
      skinId: Value(skinId),
      isUnlocked: const Value(true),
      unlockProgress: Value(progress ?? 0),
      unlockedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateProgress(String studentId, String skinId, int progress) async {
    final existing = await getCollectionItem(studentId, skinId);
    if (existing == null) return;

    final skin = await db.skinDao.getSkin(skinId);
    final isUnlocked = progress >= (skin?.unlockTarget ?? 0);

    await upsertCollectionItem(SkinCollectionsCompanion(
      id: Value(existing.id),
      studentId: Value(studentId),
      skinId: Value(skinId),
      unlockProgress: Value(progress),
      isUnlocked: Value(isUnlocked),
      unlockedAt: Value(isUnlocked && existing.unlockedAt == null ? DateTime.now() : existing.unlockedAt),
    ));
  }

  Future<void> equipSkin(String studentId, String skinId) async {
    // Unequip other skins of same category
    final currentEquipped = await (select(skinCollections)
      ..where((sc) => sc.studentId.equals(studentId) & sc.isEquipped.equals(true))
      ..join([innerJoin(skins, skins.id.equalsExp(skinCollections.skinId))]))
      .get();

    for (final item in currentEquipped) {
      final itemSkin = await db.skinDao.getSkin(item.skinId);
      final newSkin = await db.skinDao.getSkin(skinId);
      if (itemSkin != null && newSkin != null && itemSkin.category == newSkin.category) {
        await (update(skinCollections)..where((sc) => sc.id.equals(item.id))).write(SkinCollectionsCompanion(
          isEquipped: const Value(false),
        ));
      }
    }

    // Equip new skin
    await (update(skinCollections)..where((sc) => sc.studentId.equals(studentId) & sc.skinId.equals(skinId))).write(SkinCollectionsCompanion(
      isEquipped: const Value(true),
      equippedAt: Value(DateTime.now()),
    ));
  }

  Future<void> unequipSkin(String studentId, String skinId) async {
    await (update(skinCollections)..where((sc) => sc.studentId.equals(studentId) & sc.skinId.equals(skinId))).write(SkinCollectionsCompanion(
      isEquipped: const Value(false),
    ));
  }

  Future<bool> isUnlocked(String studentId, String skinId) async {
    final item = await getCollectionItem(studentId, skinId);
    return item?.isUnlocked ?? false;
  }

  Future<int> getUnlockedCount(String studentId) async {
    final result = await (selectOnly(skinCollections)
      ..addColumns([skinCollections.id.count()])
      ..where(skinCollections.studentId.equals(studentId) & skinCollections.isUnlocked.equals(true)))
      .getSingle();
    return result.read(skinCollections.id.count()) ?? 0;
  }

  Future<SkinCollection?> getEquippedByCategory(String studentId, String category) async {
    final collections = await getStudentCollection(studentId);
    for (final c in collections) {
      if (c.isEquipped) {
        final skin = await db.skinDao.getSkin(c.skinId);
        if (skin != null && skin.category == category) {
          return c;
        }
      }
    }
    return null;
  }
}