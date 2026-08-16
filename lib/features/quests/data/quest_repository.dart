import 'dart:math';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/quests/domain/quest_models.dart';

class DailyQuestRepository {
  final AppDatabase _db;
  DailyQuestRepository(this._db);

  static final _rng = Random();

  /// Generate 3 daily quests for a profile. Idempotent (won't overwrite existing today's quests).
  Future<List<DailyQuestRow>> generateToday(String profileId) async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    // Check if already generated
    final existing = await (_db.select(_db.dailyQuests)
          ..where((t) => t.profileId.equals(profileId) & t.date.equals(todayStr)))
        .get();
    if (existing.isNotEmpty) return existing;

    final questPool = List.of(QuestTemplate.questPool);
    questPool.shuffle(_rng);
    final selected = questPool.take(3).toList();

    final rows = <DailyQuestRow>[];
    for (int i = 0; i < selected.length; i++) {
      final q = selected[i];
      final quest = DailyQuest(
        id: '${profileId}_${todayStr}_$i',
        profileId: profileId,
        title: q.title,
        description: q.description,
        xpReward: q.xp,
        done: false,
        date: todayStr,
      );
      await _db.into(_db.dailyQuests).insert(DailyQuestsCompanion(
        id: Value(quest.id),
        profileId: Value(quest.profileId),
        title: Value(quest.title),
        description: Value(quest.description),
        xpReward: Value(quest.xpReward),
        date: Value(quest.date),
      ));
      rows.add(DailyQuestRow(
        id: quest.id, profileId: quest.profileId, title: quest.title,
        description: quest.description, xpReward: quest.xpReward, done: quest.done, date: quest.date,
      ));
    }
    return rows;
  }

  Future<List<DailyQuestRow>> todayQuests(String profileId) async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    return (_db.select(_db.dailyQuests)
          ..where((t) => t.profileId.equals(profileId) & t.date.equals(todayStr)))
        .get();
  }

  Future<void> complete(String questId) async {
    await (_db.update(_db.dailyQuests)
          ..where((t) => t.id.equals(questId)))
        .write(const DailyQuestsCompanion(done: Value(true)));
  }

  Future<int> totalCompleted(String profileId) async {
    final rows = await (_db.select(_db.dailyQuests)
          ..where((t) => t.profileId.equals(profileId) & t.done.equals(true)))
        .get();
    return rows.length;
  }
}
