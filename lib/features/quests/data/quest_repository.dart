import 'dart:math';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

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

    final questPool = _questPool();
    questPool.shuffle(_rng);
    final selected = questPool.take(3).toList();

    final rows = <DailyQuestRow>[];
    for (int i = 0; i < selected.length; i++) {
      final q = selected[i];
      final id = '${profileId}_${todayStr}_$i';
      await _db.into(_db.dailyQuests).insert(DailyQuestsCompanion(
        id: Value(id),
        profileId: Value(profileId),
        title: Value(q.title),
        description: Value(q.description),
        xpReward: Value(q.xp),
        date: Value(todayStr),
      ));
      rows.add(DailyQuestRow(
        id: id, profileId: profileId, title: q.title,
        description: q.description, xpReward: q.xp, done: false, date: todayStr,
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

  static List<_QuestTemplate> _questPool() => [
    _QuestTemplate('Review class notes', 'Spend 15 minutes reviewing your notes', 25),
    _QuestTemplate('Practice a problem', 'Solve one practice question', 30),
    _QuestTemplate('Read an article', 'Read one educational article', 20),
    _QuestTemplate('Quiz yourself', 'Test yourself on recent material', 35),
    _QuestTemplate('Teach someone', 'Explain a concept to a friend', 40),
    _QuestTemplate('Watch an educational video', 'Watch a tutorial or lecture', 20),
    _QuestTemplate('Organize your notes', 'Clean up and organize your study notes', 25),
    _QuestTemplate('Set tomorrow\'s goal', 'Plan what to study tomorrow', 15),
    _QuestTemplate('Flashcard review', 'Review 10 flashcards', 25),
    _QuestTemplate('Study competition material', 'Practice competition-specific content', 35),
    _QuestTemplate('Write a summary', 'Summarize what you learned today', 30),
    _QuestTemplate('Take a timed quiz', 'Time yourself on practice questions', 40),
    _QuestTemplate('Research a topic', 'Spend 15 min researching something new', 25),
    _QuestTemplate('Mind map', 'Create a mind map of a subject', 30),
    _QuestTemplate('Peer review', 'Review a classmate\'s work', 35),
  ];
}

class _QuestTemplate {
  final String title;
  final String description;
  final int xp;
  _QuestTemplate(this.title, this.description, this.xp);
}
