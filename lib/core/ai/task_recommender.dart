/// AI-powered task recommendation engine (local, no API).
class TaskRecommender {
  /// Generate personalized task recommendations based on profile.
  static List<TaskRecommendation> generate({
    required List<String> interests,
    required List<String> targetSchools,
    required int grade,
    required int hoursPerWeek,
    required String energyPeak,
    List<String> completedTasks = const [],
  }) {
    final tasks = <TaskRecommendation>[];

    // Academic tasks
    if (interests.any((i) => ['Math', 'Physics', 'CS', 'Chemistry'].contains(i))) {
      tasks.add(TaskRecommendation(
        title: 'Solve 5 problems from your hardest STEM subject',
        reason: 'Based on your interest in STEM — challenge yourself daily',
        category: 'academics',
        xp: 15,
        duration: '30 min',
        priority: Priority.high,
      ));
    }

    // Research tasks for target schools
    for (final school in targetSchools.take(3)) {
      tasks.add(TaskRecommendation(
        title: 'Research $school\'s essay prompts and deadlines',
        reason: 'Application season prep for $school',
        category: 'research',
        xp: 20,
        duration: '45 min',
        priority: Priority.high,
      ));
    }

    // Interest-based tasks
    if (interests.contains('Writing')) {
      tasks.add(TaskRecommendation(
        title: 'Write 300 words of your personal essay',
        reason: 'Writing is your strength — leverage it for applications',
        category: 'creativity',
        xp: 18,
        duration: '40 min',
        priority: Priority.high,
      ));
    }
    if (interests.contains('Research')) {
      tasks.add(TaskRecommendation(
        title: 'Read and summarize 1 research paper',
        reason: 'Research experience is valued by top universities',
        category: 'research',
        xp: 20,
        duration: '60 min',
        priority: Priority.medium,
      ));
    }
    if (interests.contains('Debate')) {
      tasks.add(TaskRecommendation(
        title: 'Practice a 5-minute impromptu speech',
        reason: 'Debate skills translate to interview confidence',
        category: 'leadership',
        xp: 15,
        duration: '15 min',
        priority: Priority.medium,
      ));
    }
    if (interests.contains('Robotics')) {
      tasks.add(TaskRecommendation(
        title: 'Work on your robotics project for 30 minutes',
        reason: 'Projects demonstrate passion and technical skill',
        category: 'creativity',
        xp: 18,
        duration: '30 min',
        priority: Priority.high,
      ));
    }
    if (interests.contains('Volunteering')) {
      tasks.add(TaskRecommendation(
        title: 'Log 1 hour of community service',
        reason: 'Service hours build your character profile',
        category: 'service',
        xp: 15,
        duration: '60 min',
        priority: Priority.medium,
      ));
    }

    // Grade-specific tasks
    if (grade >= 11) {
      tasks.add(TaskRecommendation(
        title: 'Start drafting your Common App personal statement',
        reason: 'Grade $grade — time to begin your application story',
        category: 'academics',
        xp: 25,
        duration: '60 min',
        priority: Priority.critical,
      ));
      tasks.add(TaskRecommendation(
        title: 'Create a college application timeline',
        reason: 'Organization is key in Grade $grade',
        category: 'personal',
        xp: 12,
        duration: '20 min',
        priority: Priority.high,
      ));
    }

    // Schedule-based tasks
    if (hoursPerWeek >= 20) {
      tasks.add(TaskRecommendation(
        title: 'Start a passion project this week',
        reason: 'You have $hoursPerWeek hours/week — use the extra time for something ambitious',
        category: 'creativity',
        xp: 30,
        duration: '2 hours',
        priority: Priority.medium,
      ));
    }

    // Energy-peak based
    if (energyPeak == 'morning') {
      tasks.add(TaskRecommendation(
        title: 'Do your hardest task first thing tomorrow morning',
        reason: 'Morning person — tackle challenges when energy is highest',
        category: 'personal',
        xp: 12,
        duration: '45 min',
        priority: Priority.high,
      ));
    } else if (energyPeak == 'night') {
      tasks.add(TaskRecommendation(
        title: 'Schedule deep work for 9-11 PM tonight',
        reason: 'Night owl — your peak hours are evening. Protect them.',
        category: 'personal',
        xp: 12,
        duration: '2 hours',
        priority: Priority.high,
      ));
    }

    // General high-value tasks
    tasks.addAll([
      TaskRecommendation(
        title: 'Review and organize your study notes',
        reason: 'Active review prevents the forgetting curve',
        category: 'academics',
        xp: 10,
        duration: '15 min',
        priority: Priority.low,
      ),
      TaskRecommendation(
        title: 'Plan tomorrow with 3 specific goals',
        reason: 'People who plan are 3x more likely to achieve goals',
        category: 'personal',
        xp: 8,
        duration: '5 min',
        priority: Priority.medium,
      ),
      TaskRecommendation(
        title: 'Send a thank-you email to a teacher or mentor',
        reason: 'Relationships matter — nurture them intentionally',
        category: 'leadership',
        xp: 12,
        duration: '10 min',
        priority: Priority.low,
      ),
    ]);

    // Remove duplicates by title, then sort by priority
    final seen = <String>{};
    final unique = tasks.where((t) => seen.add(t.title)).toList();
    unique.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    return unique.take(12).toList();
  }
}

enum Priority { critical, high, medium, low }

class TaskRecommendation {
  final String title;
  final String reason;
  final String category;
  final int xp;
  final String duration;
  final Priority priority;

  const TaskRecommendation({
    required this.title,
    required this.reason,
    required this.category,
    required this.xp,
    required this.duration,
    required this.priority,
  });

  String get priorityLabel {
    switch (priority) {
      case Priority.critical:
        return '🔥 CRITICAL';
      case Priority.high:
        return '⚡ HIGH';
      case Priority.medium:
        return '📌 MEDIUM';
      case Priority.low:
        return '💎 LOW';
    }
  }
}
