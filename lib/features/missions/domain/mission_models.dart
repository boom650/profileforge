import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_models.freezed.dart';

enum MissionCadence { daily, weekly, monthly, special, seasonal, university }

enum MissionPillar {
  academics,
  leadership,
  research,
  creativity,
  community,
  service,
  sports,
  personal;

  String get label => name[0].toUpperCase() + name.substring(1);

  String get emoji {
    switch (this) {
      case MissionPillar.academics:
        return '📚';
      case MissionPillar.leadership:
        return '👑';
      case MissionPillar.research:
        return '🔬';
      case MissionPillar.creativity:
        return '🎨';
      case MissionPillar.community:
        return '🤝';
      case MissionPillar.service:
        return '❤️';
      case MissionPillar.sports:
        return '⚽';
      case MissionPillar.personal:
        return '🧘';
    }
  }

  String get description {
    switch (this) {
      case MissionPillar.academics:
        return 'Master your coursework and ace exams';
      case MissionPillar.leadership:
        return 'Lead teams and inspire others';
      case MissionPillar.research:
        return 'Explore the frontiers of knowledge';
      case MissionPillar.creativity:
        return 'Express yourself and innovate';
      case MissionPillar.community:
        return 'Build meaningful connections';
      case MissionPillar.service:
        return 'Make a difference in your community';
      case MissionPillar.sports:
        return 'Stay fit and competitive';
      case MissionPillar.personal:
        return 'Grow as a person every day';
    }
  }
}

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String profileId,
    required String title,
    required String description,
    required MissionCadence cadence,
    required MissionPillar pillar,
    required int xpReward,
    required int gemReward,
    required DateTime? dueAt,
    required bool completed,
    @Default(0) int progress,
    @Default(100) int target,
  }) = _Mission;
}

/// Comprehensive mission-generation engine with 60+ unique missions.
class MissionEngine {
  // ── Daily missions: 8+ per pillar, rotated by day ──
  static const Map<MissionPillar, List<Map<String, dynamic>>> _dailyTemplates = {
    MissionPillar.academics: [
      {'title': 'Complete 1 past exam paper under timed conditions', 'desc': 'Simulate exam pressure to build confidence and speed.', 'xp': 15, 'gems': 2},
      {'title': 'Review a weak topic for 30 minutes', 'desc': 'Identify your weakest subject and spend focused time improving.', 'xp': 12, 'gems': 1},
      {'title': 'Teach a concept to a peer or sibling', 'desc': 'If you can teach it, you know it. Explaining reinforces learning.', 'xp': 18, 'gems': 3},
      {'title': 'Create flashcards for 20 key terms', 'desc': 'Active recall is the #1 study technique. Build your card deck.', 'xp': 10, 'gems': 1},
      {'title': 'Solve 5 advanced problems in your hardest subject', 'desc': 'Push beyond your comfort zone with challenging problems.', 'xp': 20, 'gems': 3},
      {'title': 'Read 1 chapter of a subject textbook', 'desc': 'Deep reading builds the foundation for all academic success.', 'xp': 12, 'gems': 1},
      {'title': 'Write a summary of today\'s most important lesson', 'desc': 'Reflection consolidates learning and improves retention.', 'xp': 8, 'gems': 1},
      {'title': 'Complete an online practice quiz', 'desc': 'Test your knowledge with interactive quizzes.', 'xp': 14, 'gems': 2},
    ],
    MissionPillar.leadership: [
      {'title': 'Lead a 15-minute study group session', 'desc': 'Take charge and help your peers learn.', 'xp': 20, 'gems': 3},
      {'title': 'Organize a team activity for your club', 'desc': 'Plan and execute a meaningful club event.', 'xp': 18, 'gems': 2},
      {'title': 'Mentor a younger student for 20 minutes', 'desc': 'Share your knowledge and inspire the next generation.', 'xp': 15, 'gems': 2},
      {'title': 'Give a 5-minute presentation to your class', 'desc': 'Public speaking is a superpower. Practice it daily.', 'xp': 22, 'gems': 3},
      {'title': 'Resolve a conflict between two team members', 'desc': 'Great leaders mediate and find common ground.', 'xp': 25, 'gems': 4},
      {'title': 'Create a shared document for your team', 'desc': 'Documentation is leadership. Make information accessible.', 'xp': 10, 'gems': 1},
      {'title': 'Delegate a task and follow up on progress', 'desc': 'Trust others and verify. True leadership is empowering.', 'xp': 15, 'gems': 2},
      {'title': 'Write a thank-you note to a mentor', 'desc': 'Gratitude strengthens relationships and shows maturity.', 'xp': 8, 'gems': 1},
    ],
    MissionPillar.research: [
      {'title': 'Read 1 research paper in your field', 'desc': 'Stay current with the latest discoveries.', 'xp': 15, 'gems': 2},
      {'title': 'Email a professor about research opportunities', 'desc': 'Cold emails lead to extraordinary opportunities.', 'xp': 20, 'gems': 3},
      {'title': 'Draft a hypothesis for a research project', 'desc': 'Every great discovery starts with a question.', 'xp': 18, 'gems': 2},
      {'title': 'Summarize a paper in 3 sentences', 'desc': 'Distilling complex ideas is a critical research skill.', 'xp': 12, 'gems': 1},
      {'title': 'Find 3 potential research topics', 'desc': 'Explore different fields to find your passion.', 'xp': 14, 'gems': 2},
      {'title': 'Watch a TED talk on a science topic', 'desc': 'Inspiration fuels curiosity and innovation.', 'xp': 8, 'gems': 1},
      {'title': 'Write a literature review paragraph', 'desc': 'Synthesize existing research to build your argument.', 'xp': 16, 'gems': 2},
      {'title': 'Analyze data from a published study', 'desc': 'Critical analysis of data is essential for research.', 'xp': 20, 'gems': 3},
    ],
    MissionPillar.creativity: [
      {'title': 'Spend 20 minutes on a creative project', 'desc': 'Consistent creative practice builds mastery.', 'xp': 15, 'gems': 2},
      {'title': 'Sketch a product or app idea', 'desc': 'Turn your ideas into visual concepts.', 'xp': 12, 'gems': 1},
      {'title': 'Write 200 words of a creative piece', 'desc': 'Writing is thinking. Express yourself through words.', 'xp': 14, 'gems': 2},
      {'title': 'Design a logo for your personal brand', 'desc': 'Your brand is your identity. Design it intentionally.', 'xp': 18, 'gems': 3},
      {'title': 'Create a photo collage of your week', 'desc': 'Visual storytelling captures memories and patterns.', 'xp': 10, 'gems': 1},
      {'title': 'Write and record a 30-second voice memo', 'desc': 'Audio content is the future. Start creating.', 'xp': 12, 'gems': 1},
      {'title': 'Build a prototype of a simple app or project', 'desc': 'Ship fast, learn faster. Build something real.', 'xp': 22, 'gems': 3},
      {'title': 'Redesign a product you use daily', 'desc': 'Design thinking starts with questioning the status quo.', 'xp': 16, 'gems': 2},
    ],
    MissionPillar.community: [
      {'title': 'Attend a school or community event', 'desc': 'Show up. Being present is the first step to belonging.', 'xp': 12, 'gems': 1},
      {'title': 'Start a conversation with someone new', 'desc': 'Every connection is a potential friendship or collaboration.', 'xp': 10, 'gems': 1},
      {'title': 'Help organize a workshop or meetup', 'desc': 'Communities thrive when members contribute.', 'xp': 18, 'gems': 2},
      {'title': 'Join an online study or interest group', 'desc': 'Digital communities connect you with like-minded people.', 'xp': 8, 'gems': 1},
      {'title': 'Write a post about something you learned', 'desc': 'Share knowledge to strengthen your community.', 'xp': 14, 'gems': 2},
      {'title': 'Attend a cultural or diversity event', 'desc': 'Broaden your perspective through cultural exposure.', 'xp': 12, 'gems': 1},
      {'title': 'Organize a neighborhood clean-up', 'desc': 'Environmental stewardship shows leadership and care.', 'xp': 20, 'gems': 3},
      {'title': 'Volunteer at a local food bank or shelter', 'desc': 'Service connects you to real-world impact.', 'xp': 22, 'gems': 3},
    ],
    MissionPillar.service: [
      {'title': 'Log 1 hour of community service', 'desc': 'Service hours build character and your college profile.', 'xp': 15, 'gems': 2},
      {'title': 'Plan a service initiative for next month', 'desc': 'Great service starts with thoughtful planning.', 'xp': 12, 'gems': 1},
      {'title': 'Research a local NGO\'s mission', 'desc': 'Understanding organizations helps you contribute effectively.', 'xp': 10, 'gems': 1},
      {'title': 'Tutor someone for 30 minutes', 'desc': 'Teaching others is the highest form of service.', 'xp': 18, 'gems': 2},
      {'title': 'Donate old books or clothes', 'desc': 'Decluttering with purpose creates impact.', 'xp': 8, 'gems': 1},
      {'title': 'Write a thank-you letter to a community helper', 'desc': 'Recognition motivates continued service.', 'xp': 10, 'gems': 1},
      {'title': 'Organize a charity fundraiser idea', 'desc': 'Creative fundraising combines leadership and service.', 'xp': 16, 'gems': 2},
      {'title': 'Spend 20 minutes on an environmental project', 'desc': 'Small actions compound into meaningful change.', 'xp': 14, 'gems': 2},
    ],
    MissionPillar.sports: [
      {'title': 'Train for 30 minutes', 'desc': 'Physical fitness sharpens mental focus.', 'xp': 12, 'gems': 1},
      {'title': 'Join a pickup game or intramural match', 'desc': 'Team sports build discipline and social bonds.', 'xp': 15, 'gems': 2},
      {'title': 'Set a fitness goal for this week', 'desc': 'Clear goals drive consistent progress.', 'xp': 10, 'gems': 1},
      {'title': 'Try a new sport or physical activity', 'desc': 'Stepping outside your comfort zone builds resilience.', 'xp': 14, 'gems': 2},
      {'title': 'Go for a 20-minute walk or jog', 'desc': 'Movement resets your brain and boosts creativity.', 'xp': 8, 'gems': 1},
      {'title': 'Stretch for 10 minutes before bed', 'desc': 'Flexibility and recovery are essential for performance.', 'xp': 6, 'gems': 1},
      {'title': 'Track your exercise progress', 'desc': 'What gets measured gets improved.', 'xp': 10, 'gems': 1},
      {'title': 'Complete a physical challenge', 'desc': 'Push your limits. Growth happens at the edge.', 'xp': 18, 'gems': 3},
    ],
    MissionPillar.personal: [
      {'title': 'Plan your week with time blocks', 'desc': 'Structure creates freedom. Plan to succeed.', 'xp': 12, 'gems': 1},
      {'title': 'Reflect on 3 wins from today', 'desc': 'Gratitude and reflection build mental resilience.', 'xp': 8, 'gems': 1},
      {'title': 'Sleep 7+ hours tonight', 'desc': 'Sleep is the ultimate performance enhancer.', 'xp': 10, 'gems': 1},
      {'title': 'Write in your journal for 10 minutes', 'desc': 'Journaling clarifies thoughts and processes emotions.', 'xp': 12, 'gems': 1},
      {'title': 'Limit social media to 30 minutes today', 'desc': 'Digital discipline protects your focus and time.', 'xp': 14, 'gems': 2},
      {'title': 'Practice 5 minutes of mindfulness', 'desc': 'Mindfulness reduces stress and improves attention.', 'xp': 8, 'gems': 1},
      {'title': 'Read 20 pages of a non-fiction book', 'desc': 'Continuous learning is a competitive advantage.', 'xp': 12, 'gems': 1},
      {'title': 'Set 3 goals for tomorrow', 'desc': 'Tomorrow\'s success starts with tonight\'s planning.', 'xp': 6, 'gems': 1},
    ],
  };

  // ── Weekly missions: bigger, multi-day challenges ──
  static const List<Map<String, dynamic>> _weeklyTemplates = [
    {'title': 'Complete 5 study sessions this week', 'desc': 'Consistency is king. Show up every day.', 'pillar': MissionPillar.academics, 'xp': 50, 'gems': 8, 'target': 5},
    {'title': 'Write a draft of your personal essay', 'desc': 'Your story matters. Start writing it.', 'pillar': MissionPillar.creativity, 'xp': 60, 'gems': 10, 'target': 1},
    {'title': 'Research 3 universities in depth', 'desc': 'Know your targets inside and out.', 'pillar': MissionPillar.research, 'xp': 45, 'gems': 7, 'target': 3},
    {'title': 'Lead 2 group study sessions', 'desc': 'Teaching others elevates everyone.', 'pillar': MissionPillar.leadership, 'xp': 55, 'gems': 9, 'target': 2},
    {'title': 'Log 3 hours of community service', 'desc': 'Service hours build character and your profile.', 'pillar': MissionPillar.service, 'xp': 40, 'gems': 6, 'target': 3},
    {'title': 'Exercise 4 times this week', 'desc': 'Physical health drives mental performance.', 'pillar': MissionPillar.sports, 'xp': 35, 'gems': 5, 'target': 4},
    {'title': 'Attend 2 community events', 'desc': 'Show up and connect with your community.', 'pillar': MissionPillar.community, 'xp': 30, 'gems': 5, 'target': 2},
    {'title': 'Journal every day for 7 days', 'desc': 'Reflection builds self-awareness and clarity.', 'pillar': MissionPillar.personal, 'xp': 40, 'gems': 6, 'target': 7},
    {'title': 'Read 100 pages total this week', 'desc': 'Reading broadens your mind and vocabulary.', 'pillar': MissionPillar.academics, 'xp': 45, 'gems': 7, 'target': 100},
    {'title': 'Practice a creative skill for 5 hours', 'desc': 'Mastery requires deliberate practice.', 'pillar': MissionPillar.creativity, 'xp': 50, 'gems': 8, 'target': 5},
    {'title': 'Network: reach out to 3 professionals', 'desc': 'Your network is your net worth.', 'pillar': MissionPillar.leadership, 'xp': 45, 'gems': 7, 'target': 3},
    {'title': 'Complete an online course module', 'desc': 'Self-directed learning shows initiative.', 'pillar': MissionPillar.research, 'xp': 40, 'gems': 6, 'target': 1},
    {'title': 'Help 3 people this week', 'desc': 'Small acts of kindness create ripple effects.', 'pillar': MissionPillar.service, 'xp': 35, 'gems': 5, 'target': 3},
    {'title': 'Cook a healthy meal from scratch', 'desc': 'Self-sufficiency is a life skill colleges value.', 'pillar': MissionPillar.personal, 'xp': 20, 'gems': 3, 'target': 1},
    {'title': 'Learn 50 new vocabulary words', 'desc': 'Language skills open doors to opportunity.', 'pillar': MissionPillar.academics, 'xp': 35, 'gems': 5, 'target': 50},
  ];

  // ── Monthly missions: ambitious, long-term goals ──
  static const List<Map<String, dynamic>> _monthlyTemplates = [
    {'title': 'Submit a research paper or project', 'desc': 'Publish your work and contribute to knowledge.', 'pillar': MissionPillar.research, 'xp': 200, 'gems': 30, 'target': 1},
    {'title': 'Build and deploy a personal website', 'desc': 'Your online presence is your digital business card.', 'pillar': MissionPillar.creativity, 'xp': 180, 'gems': 25, 'target': 1},
    {'title': 'Complete 20 study sessions', 'desc': 'Consistency compounds. 20 sessions = unstoppable momentum.', 'pillar': MissionPillar.academics, 'xp': 150, 'gems': 20, 'target': 20},
    {'title': 'Organize a community event', 'desc': 'Leadership in action. Create something that matters.', 'pillar': MissionPillar.leadership, 'xp': 200, 'gems': 30, 'target': 1},
    {'title': 'Log 10 hours of service', 'desc': 'Deep service commitment builds real impact.', 'pillar': MissionPillar.service, 'xp': 120, 'gems': 15, 'target': 10},
    {'title': 'Run 20km total this month', 'desc': 'Endurance training builds physical and mental toughness.', 'pillar': MissionPillar.sports, 'xp': 100, 'gems': 12, 'target': 20},
    {'title': 'Write a 1000-word essay on a passion topic', 'desc': 'Deep writing reveals deep thinking.', 'pillar': MissionPillar.creativity, 'xp': 150, 'gems': 20, 'target': 1},
    {'title': 'Connect with 5 alumni or professionals', 'desc': 'Mentorship accelerates growth exponentially.', 'pillar': MissionPillar.leadership, 'xp': 130, 'gems': 18, 'target': 5},
    {'title': 'Complete a passion project milestone', 'desc': 'Finish what you start. Projects show commitment.', 'pillar': MissionPillar.personal, 'xp': 160, 'gems': 22, 'target': 1},
    {'title': 'Read 4 books this month', 'desc': 'A book a week keeps you ahead of 99% of peers.', 'pillar': MissionPillar.academics, 'xp': 140, 'gems': 18, 'target': 4},
  ];

  static const Map<MissionCadence, int> _rewards = {
    MissionCadence.daily: 10,
    MissionCadence.weekly: 40,
    MissionCadence.monthly: 120,
    MissionCadence.special: 60,
    MissionCadence.seasonal: 200,
    MissionCadence.university: 150,
  };

  /// Generate daily missions — rotated by day of year for variety.
  List<Mission> generateDaily(String profileId) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final missions = <Mission>[];
    for (final pillar in MissionPillar.values) {
      final templates = _dailyTemplates[pillar]!;
      final idx = dayOfYear % templates.length;
      final t = templates[idx];
      missions.add(Mission(
        id: 'd-${profileId}-${pillar.name}-${DateTime.now().day}',
        profileId: profileId,
        title: t['title'] as String,
        description: t['desc'] as String,
        cadence: MissionCadence.daily,
        pillar: pillar,
        xpReward: t['xp'] as int,
        gemReward: t['gems'] as int,
        dueAt: DateTime.now().add(const Duration(days: 1)),
        completed: false,
        target: 1,
      ));
    }
    return missions;
  }

  /// Generate weekly missions — 5 random from the pool.
  List<Mission> generateWeekly(String profileId) {
    final weekNum = DateTime.now().difference(DateTime(DateTime.now().year)).inDays ~/ 7;
    final missions = <Mission>[];
    for (var i = 0; i < 5; i++) {
      final idx = (weekNum + i) % _weeklyTemplates.length;
      final t = _weeklyTemplates[idx];
      missions.add(Mission(
        id: 'w-${profileId}-$i-${DateTime.now().month}',
        profileId: profileId,
        title: t['title'] as String,
        description: t['desc'] as String,
        cadence: MissionCadence.weekly,
        pillar: t['pillar'] as MissionPillar,
        xpReward: t['xp'] as int,
        gemReward: t['gems'] as int,
        dueAt: DateTime.now().add(const Duration(days: 7)),
        completed: false,
        target: t['target'] as int,
      ));
    }
    return missions;
  }

  /// Generate monthly missions — top 3 from the pool.
  List<Mission> generateMonthly(String profileId) {
    final monthIdx = DateTime.now().month % _monthlyTemplates.length;
    final missions = <Mission>[];
    for (var i = 0; i < 3; i++) {
      final idx = (monthIdx + i) % _monthlyTemplates.length;
      final t = _monthlyTemplates[idx];
      missions.add(Mission(
        id: 'm-${profileId}-$i-${DateTime.now().month}',
        profileId: profileId,
        title: t['title'] as String,
        description: t['desc'] as String,
        cadence: MissionCadence.monthly,
        pillar: t['pillar'] as MissionPillar,
        xpReward: t['xp'] as int,
        gemReward: t['gems'] as int,
        dueAt: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
        completed: false,
        target: t['target'] as int,
      ));
    }
    return missions;
  }

  /// University-specific mission for a target school.
  Mission universityMission(String profileId, String university) => Mission(
        id: 'u-${profileId}-$university',
        profileId: profileId,
        title: 'Research $university\'s admission essay prompt',
        description: 'Understand what $university values and tailor your story.',
        cadence: MissionCadence.university,
        pillar: MissionPillar.academics,
        xpReward: _rewards[MissionCadence.university]!,
        gemReward: 15,
        dueAt: DateTime.now().add(const Duration(days: 7)),
        completed: false,
      );

  /// All missions combined.
  List<Mission> generateAll(String profileId) {
    return [
      ...generateDaily(profileId),
      ...generateWeekly(profileId),
      ...generateMonthly(profileId),
    ];
  }

  /// The single next-due incomplete mission.
  Mission? nextDue(List<Mission> missions, DateTime now) {
    final open = missions.where((m) => !m.completed).toList()
      ..sort((a, b) => (a.dueAt ?? DateTime(0)).compareTo(b.dueAt ?? DateTime(0)));
    return open.isEmpty ? null : open.first;
  }
}
