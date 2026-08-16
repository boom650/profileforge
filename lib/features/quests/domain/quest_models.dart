/// A template quest definition (title / description / XP) from which the
/// daily quest pool is drawn. Pure domain data — no DB or Flutter deps.
class QuestTemplate {
  final String title;
  final String description;
  final int xp;

  const QuestTemplate(this.title, this.description, this.xp);

  /// The full pool of quest templates. The repository draws 3 of these per
  /// day per profile.
  static const List<QuestTemplate> questPool = [
    QuestTemplate('Review class notes', 'Spend 15 minutes reviewing your notes', 25),
    QuestTemplate('Practice a problem', 'Solve one practice question', 30),
    QuestTemplate('Read an article', 'Read one educational article', 20),
    QuestTemplate('Quiz yourself', 'Test yourself on recent material', 35),
    QuestTemplate('Teach someone', 'Explain a concept to a friend', 40),
    QuestTemplate('Watch an educational video', 'Watch a tutorial or lecture', 20),
    QuestTemplate('Organize your notes', 'Clean up and organize your study notes', 25),
    QuestTemplate("Set tomorrow's goal", 'Plan what to study tomorrow', 15),
    QuestTemplate('Flashcard review', 'Review 10 flashcards', 25),
    QuestTemplate('Study competition material', 'Practice competition-specific content', 35),
    QuestTemplate('Write a summary', 'Summarize what you learned today', 30),
    QuestTemplate('Take a timed quiz', 'Time yourself on practice questions', 40),
    QuestTemplate('Research a topic', 'Spend 15 min researching something new', 25),
    QuestTemplate('Mind map', 'Create a mind map of a subject', 30),
    QuestTemplate('Peer review', "Review a classmate's work", 35),
  ];
}

/// A daily quest as a domain object — mirrors one `daily_quests` row.
class DailyQuest {
  final String id;
  final String profileId;
  final String title;
  final String description;
  final int xpReward;
  final bool done;
  final String date;

  const DailyQuest({
    required this.id,
    required this.profileId,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.done,
    required this.date,
  });

  bool get isDone => done;
}