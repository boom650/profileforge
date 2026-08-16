/// A selectable primary-focus option. The `id` is what gets persisted in the
/// `user_goals.primary_goal` column, so the picker and the DB share one source
/// of truth.
class GoalOption {
  final String id;
  final String title;
  final String description;

  const GoalOption({
    required this.id,
    required this.title,
    required this.description,
  });

  static const List<GoalOption> all = [
    GoalOption(
      id: 'exam_prep',
      title: 'Exam Preparation',
      description: 'Prepare for upcoming exams with targeted study plans',
    ),
    GoalOption(
      id: 'competition',
      title: 'Competition Prep',
      description: 'Train for academic competitions and Olympiads',
    ),
    GoalOption(
      id: 'general',
      title: 'General Learning',
      description: 'Broad knowledge building across subjects',
    ),
    GoalOption(
      id: 'skill_building',
      title: 'Skill Building',
      description: 'Develop specific skills (coding, writing, etc.)',
    ),
    GoalOption(
      id: 'college_apps',
      title: 'College Applications',
      description: 'Build your profile for university admissions',
    ),
  ];

  static GoalOption byId(String id) => all.firstWhere(
        (o) => o.id == id,
        orElse: () => all[2], // 'general'
      );
}

/// A user's goal preferences: a single primary focus plus a list of
/// secondary focus areas.
class UserGoal {
  final String primaryGoal;
  final List<String> secondaryGoals;

  const UserGoal({required this.primaryGoal, this.secondaryGoals = const []});

  /// Secondary goals are stored comma-joined in the DB.
  static String encodeSecondary(List<String> goals) => goals.join(',');

  /// Inverse of [encodeSecondary] — tolerates empty / legacy rows.
  static List<String> decodeSecondary(String? stored) {
    if (stored == null || stored.isEmpty || stored == '[]') return const [];
    return stored
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  bool get hasPrimaryGoal => primaryGoal.isNotEmpty;

  GoalOption get primaryOption => GoalOption.byId(primaryGoal);
}