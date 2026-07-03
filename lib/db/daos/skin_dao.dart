import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'skin_dao.g.dart';

@DriftAccessor(tables: [Skins, SkinCollections])
class SkinDao extends DatabaseAccessor<AppDatabase> with _$SkinDaoMixin {
  SkinDao(super.db);

  Future<List<Skin>> getAllSkins() => 
      (select(skins)..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).get();

  Stream<List<Skin>> watchAllSkins() => 
      (select(skins)..orderBy([(s) => OrderingTerm.asc(s.sortOrder)])).watch();

  Future<List<Skin>> getSkinsByCategory(SkinCategory category) => 
      (select(skins)
        ..where((s) => s.category.equals(category.name))
        ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .get();

  Future<Skin?> getSkin(String id) => 
      (select(skins)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<int> insertSkin(SkinsCompanion skin) => 
      into(skins).insert(skin);

  Future<bool> updateSkin(SkinsCompanion skin) => 
      update(skins).replace(skin);

  Future<int> deleteSkin(String id) => 
      (delete(skins)..where((s) => s.id.equals(id))).go();

  // Skin Collection
  Future<SkinCollection?> getCollectionItem(String studentId, String skinId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId) & sc.skinId.equals(skinId)))
        .getSingleOrNull();

  Future<List<SkinCollection>> getStudentCollection(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId))
        ..join([innerJoin(skins, skins.id.equalsExp(skinCollections.skinId))]))
        .get();

  Stream<List<SkinCollection>> watchStudentCollection(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId))
        ..join([innerJoin(skins, skins.id.equalsExp(skinCollections.skinId))]))
        .watch();

  Future<List<SkinCollection>> getUnlockedSkins(String studentId) => 
      (select(skinCollections)
        ..where((sc) => sc.studentId.equals(studentId) & sc.isUnlocked.equals(true))
        ..join([innerJoin(skins, skins.id.equalsExp(skinCollections.skinId))]))
        .get();

  Future<SkinCollection?> getEquippedSkin(String studentId, SkinCategory category) async {
    final collections = await getStudentCollection(studentId);
    for (final c in collections) {
      if (c.isEquipped) {
        final skin = await getSkin(c.skinId);
        if (skin != null && skin.category == category.name) {
          return c;
        }
      }
    }
    return null;
  }

  Future<int> upsertCollectionItem(SkinCollectionsCompanion item) => 
      into(skinCollections).insertOnConflictUpdate(item);

  Future<void> unlockSkin(String studentId, String skinId, {int? progress}) async {
    final existing = await getCollectionItem(studentId, skinId);
    final skin = await getSkin(skinId);
    if (skin == null) return;

    await upsertCollectionItem(SkinCollectionsCompanion(
      id: Value(existing?.id ?? const Uuid().v4()),
      studentId: Value(studentId),
      skinId: Value(skinId),
      isUnlocked: const Value(true),
      unlockProgress: Value(progress ?? skin.unlockTarget),
      unlockedAt: Value(DateTime.now()),
    ));
  }

  Future<void> equipSkin(String studentId, String skinId) async {
    final skin = await getSkin(skinId);
    if (skin == null) return;

    // Unequip current skin of same category
    final currentEquipped = await (select(skinCollections)
      ..where((sc) => sc.studentId.equals(studentId) & sc.isEquipped.equals(true))
      ..join([innerJoin(skins, skins.id.equalsExp(skinCollections.skinId))]))
      .get();

    for (final item in currentEquipped) {
      final itemSkin = await getSkin(item.skinId);
      if (itemSkin != null && itemSkin.category == skin.category) {
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

  Future<int> getUnlockedCount(String studentId) async {
    final result = await (selectOnly(skinCollections)
      ..addColumns([skinCollections.id.count()])
      ..where(skinCollections.studentId.equals(studentId) & skinCollections.isUnlocked.equals(true)))
      .getSingle();
    return result.read(skinCollections.id.count()) ?? 0;
  }

  Future<int> getTotalSkinsCount() async {
    final result = await (selectOnly(skins)..addColumns([skins.id.count()])).getSingle();
    return result.read(skins.id.count()) ?? 0;
  }
}