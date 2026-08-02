import 'dart:math';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';
import 'package:profileforge/features/onboarding/domain/user_preferences.dart';
import 'persona_detector.dart';

/// Task granularity — how big is this task?
enum TaskSize {
  daily,    // 30min - 1hr, one small step
  weekly,   // 2-3hrs, a meaningful chunk
  monthly,  // full project/milestone
}

/// A single recommended task.
class ProfileTask {
  const ProfileTask({
    required this.title,
    required this.description,
    required this.size,
    required this.category,
    required this.estimatedMinutes,
    required this.skillTags,
    this.parentTaskId,
    this.monthGoal,
    this.progressStep,
  });

  final String title;
  final String description;
  final TaskSize size;
  final String category;
  final int estimatedMinutes;
  final List<String> skillTags;
  final String? parentTaskId; // links daily → weekly → monthly
  final String? monthGoal;   // what this builds toward
  final int? progressStep;   // step number in the progression
}

/// Generates progressive tasks based on user persona and profile.
/// Uses BOTH OnboardingProfile (subjects, activities, universities)
/// AND UserPreferences (likes, dislikes, skills, values, time).
class TaskHierarchyEngine {
  TaskHierarchyEngine({Random? rng}) : _rng = rng ?? Random();

  final Random _rng;

  /// Generates today's daily task — uses preferences for personalization.
  ProfileTask generateDailyTask(OnboardingProfile profile, UserPreferences prefs) {
    final persona = detectPersona(profile);
    final allTasks = _dailyTasks[persona] ?? _dailyTasks[UserPersona.generalist]!;

    // Score each task based on user preferences.
    final scored = allTasks.map((t) {
      var score = 0;

      // Boost if task matches liked activities.
      for (final liked in prefs.likedActivities) {
        if (t.skillTags.any((tag) => liked.toLowerCase().contains(tag))) {
          score += 5;
        }
      }

      // Penalize if task matches disliked activities.
      for (final disliked in prefs.dislikedActivities) {
        if (t.skillTags.any((tag) => disliked.toLowerCase().contains(tag))) {
          score -= 10;
        }
      }

      // Boost if task matches skills they have.
      for (final skill in prefs.skills) {
        if (t.skillTags.any((tag) => skill.toLowerCase().contains(tag))) {
          score += 3;
        }
      }

      // Boost if task matches what they want to learn.
      for (final want in prefs.wantToLearn) {
        if (t.skillTags.any((tag) => want.toLowerCase().contains(tag))) {
          score += 4;
        }
      }

      // Boost if task matches their values.
      for (final value in prefs.values) {
        if (value.toLowerCase().contains('impact') && t.category == 'Service') score += 3;
        if (value.toLowerCase().contains('creative') && t.category == 'Creation') score += 3;
        if (value.toLowerCase().contains('learn') && t.category == 'Learning') score += 3;
        if (value.toLowerCase().contains('build') && t.category == 'Project') score += 3;
        if (value.toLowerCase().contains('leader') && t.category == 'Leadership') score += 3;
      }

      // Small random factor for variety.
      score += _rng.nextInt(3);

      return (task: t, score: score);
    }).toList();

    // Sort by score, pick from top 3.
    scored.sort((a, b) => b.score.compareTo(a.score));
    final top = scored.take(3).toList();
    return top[_rng.nextInt(top.length)].task;
  }

  /// Generates this week's weekly task.
  ProfileTask generateWeeklyTask(OnboardingProfile profile, UserPreferences prefs) {
    final persona = detectPersona(profile);
    final allTasks = _weeklyTasks[persona] ?? _weeklyTasks[UserPersona.generalist]!;

    final scored = allTasks.map((t) {
      var score = 0;
      for (final liked in prefs.likedActivities) {
        if (t.skillTags.any((tag) => liked.toLowerCase().contains(tag))) score += 5;
      }
      for (final disliked in prefs.dislikedActivities) {
        if (t.skillTags.any((tag) => disliked.toLowerCase().contains(tag))) score -= 10;
      }
      score += _rng.nextInt(3);
      return (task: t, score: score);
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    final top = scored.take(2).toList();
    return top[_rng.nextInt(top.length)].task;
  }

  /// Generates this month's big project.
  ProfileTask generateMonthlyTask(OnboardingProfile profile, UserPreferences prefs) {
    final persona = detectPersona(profile);
    final allTasks = _monthlyTasks[persona] ?? _monthlyTasks[UserPersona.generalist]!;

    final scored = allTasks.map((t) {
      var score = 0;
      for (final liked in prefs.likedActivities) {
        if (t.skillTags.any((tag) => liked.toLowerCase().contains(tag))) score += 5;
      }
      for (final value in prefs.values) {
        if (value.toLowerCase().contains('impact') && t.category == 'Launch') score += 4;
        if (value.toLowerCase().contains('creative') && t.category == 'Portfolio') score += 4;
      }
      score += _rng.nextInt(3);
      return (task: t, score: score);
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    final top = scored.take(2).toList();
    return top[_rng.nextInt(top.length)].task;
  }

  /// Generates the daily breakdown for a weekly task.
  List<ProfileTask> breakWeeklyIntoDails(ProfileTask weeklyTask) {
    final steps = _weeklyBreakdowns[weeklyTask.title] ?? [
      'Plan and outline the approach',
      'Do the first half of the work',
      'Complete and polish the final result',
    ];

    return List.generate(steps.length, (i) {
      return ProfileTask(
        title: steps[i],
        description: 'Step ${i + 1} of ${steps.length}: ${steps[i]}',
        size: TaskSize.daily,
        category: weeklyTask.category,
        estimatedMinutes: 45,
        skillTags: weeklyTask.skillTags,
        parentTaskId: weeklyTask.title,
        monthGoal: weeklyTask.monthGoal,
        progressStep: i + 1,
      );
    });
  }

  // ─── DAILY TASKS (30min - 1hr each) ───

  static final Map<UserPersona, List<ProfileTask>> _dailyTasks = {
    UserPersona.maker: [
      ProfileTask(
        title: 'Sketch your app\'s next screen',
        description: 'Draw the wireframe for one screen of your app. Focus on layout, buttons, and flow. Even rough pencil sketches count.',
        size: TaskSize.daily,
        category: 'Project',
        estimatedMinutes: 45,
        skillTags: ['code', 'app', 'design', 'maker'],
      ),
      ProfileTask(
        title: 'Fix one bug in your project',
        description: 'Find one bug or issue in your current project and fix it. Document what was wrong and how you fixed it.',
        size: TaskSize.daily,
        category: 'Project',
        estimatedMinutes: 45,
        skillTags: ['code', 'app', 'maker', 'engineering'],
      ),
      ProfileTask(
        title: 'Research one new API or library',
        description: 'Find one API or library that could help your project. Read the docs, try a hello-world example.',
        size: TaskSize.daily,
        category: 'Learning',
        estimatedMinutes: 30,
        skillTags: ['code', 'app', 'maker', 'technology'],
      ),
      ProfileTask(
        title: 'Write 200 lines of code',
        description: 'Write 200 lines of working code for your project. Doesn\'t need to be perfect — just progress.',
        size: TaskSize.daily,
        category: 'Project',
        estimatedMinutes: 60,
        skillTags: ['code', 'app', 'maker', 'engineering'],
      ),
      ProfileTask(
        title: 'Watch one maker tutorial',
        description: 'Watch a 15-20 minute tutorial on a technique relevant to your project. Take notes on what you learn.',
        size: TaskSize.daily,
        category: 'Learning',
        estimatedMinutes: 30,
        skillTags: ['code', 'app', 'maker', 'robot'],
      ),
      ProfileTask(
        title: 'Test your project on a friend',
        description: 'Show your project to one person. Get their honest feedback. Write down 3 things they liked and 3 things to improve.',
        size: TaskSize.daily,
        category: 'Feedback',
        estimatedMinutes: 30,
        skillTags: ['code', 'app', 'maker', 'design'],
      ),
      ProfileTask(
        title: 'Design one feature end-to-end',
        description: 'Pick one feature. Write what it does, how it looks, what data it needs, and how it connects to other features.',
        size: TaskSize.daily,
        category: 'Planning',
        estimatedMinutes: 45,
        skillTags: ['code', 'app', 'maker', 'design'],
      ),
      ProfileTask(
        title: 'Write project documentation',
        description: 'Write or update your README. Explain what your project does, how to use it, and what you learned building it.',
        size: TaskSize.daily,
        category: 'Documentation',
        estimatedMinutes: 30,
        skillTags: ['code', 'app', 'maker', 'writing'],
      ),
    ],

    UserPersona.researcher: [
      ProfileTask(
        title: 'Read one research paper abstract',
        description: 'Find one paper related to your interest area. Read the abstract and write a 3-sentence summary.',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['research', 'science', 'paper', 'journal'],
      ),
      ProfileTask(
        title: 'Write 300 words of your research paper',
        description: 'Write 300 words of your research paper or literature review. Focus on getting ideas down, not perfection.',
        size: TaskSize.daily,
        category: 'Writing',
        estimatedMinutes: 60,
        skillTags: ['research', 'paper', 'writing', 'academic'],
      ),
      ProfileTask(
        title: 'Find 3 sources for your topic',
        description: 'Search for 3 academic sources related to your research topic. Save the titles, authors, and key findings.',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['research', 'paper', 'journal', 'study'],
      ),
      ProfileTask(
        title: 'Analyze one dataset',
        description: 'Take one dataset (or create a small one). Run basic analysis: mean, median, trends. Write what you find.',
        size: TaskSize.daily,
        category: 'Analysis',
        estimatedMinutes: 45,
        skillTags: ['research', 'data', 'analysis', 'math'],
      ),
      ProfileTask(
        title: 'Summarize one chapter or section',
        description: 'Read one section of a textbook or paper. Write a 200-word summary of the key concepts.',
        size: TaskSize.daily,
        category: 'Study',
        estimatedMinutes: 30,
        skillTags: ['research', 'study', 'academic', 'science'],
      ),
    ],

    UserPersona.socialWorker: [
      ProfileTask(
        title: 'Plan one tutoring session',
        description: 'Plan a 1-hour tutoring session for a student. Write the topic, 3 key points, and one activity.',
        size: TaskSize.daily,
        category: 'Service',
        estimatedMinutes: 30,
        skillTags: ['volunteer', 'tutor', 'teach', 'community'],
      ),
      ProfileTask(
        title: 'Write a reflection on your service',
        description: 'Write 200 words about a recent volunteer experience. What did you learn? What was hard? What would you do differently?',
        size: TaskSize.daily,
        category: 'Reflection',
        estimatedMinutes: 30,
        skillTags: ['volunteer', 'community', 'service', 'social'],
      ),
      ProfileTask(
        title: 'Research one community need',
        description: 'Find one specific need in your community. Who is affected? What exists to help? What\'s missing?',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['community', 'service', 'social', 'help'],
      ),
      ProfileTask(
        title: 'Draft an outreach email',
        description: 'Write an email to a local organization offering to volunteer. Be specific about what you can offer.',
        size: TaskSize.daily,
        category: 'Outreach',
        estimatedMinutes: 20,
        skillTags: ['volunteer', 'community', 'outreach', 'social'],
      ),
      ProfileTask(
        title: 'Create one teaching material',
        description: 'Make one worksheet, quiz, or visual aid for your tutoring. Keep it simple but useful.',
        size: TaskSize.daily,
        category: 'Service',
        estimatedMinutes: 45,
        skillTags: ['tutor', 'teach', 'volunteer', 'help'],
      ),
    ],

    UserPersona.creative: [
      ProfileTask(
        title: 'Write 300 words of anything',
        description: 'Write 300 words — a story, essay, poem, or journal entry. Just write.',
        size: TaskSize.daily,
        category: 'Writing',
        estimatedMinutes: 30,
        skillTags: ['write', 'writing', 'story', 'poetry'],
      ),
      ProfileTask(
        title: 'Take 10 intentional photos',
        description: 'Take 10 photos with intent. Each one should tell a story or capture a mood. Pick your best 3.',
        size: TaskSize.daily,
        category: 'Photography',
        estimatedMinutes: 30,
        skillTags: ['photo', 'art', 'creative', 'design'],
      ),
      ProfileTask(
        title: 'Sketch or draw for 30 minutes',
        description: 'Draw or sketch for 30 minutes. Anything — still life, character design, abstract. Just practice.',
        size: TaskSize.daily,
        category: 'Art',
        estimatedMinutes: 30,
        skillTags: ['art', 'draw', 'paint', 'design'],
      ),
      ProfileTask(
        title: 'Listen and analyze one song',
        description: 'Listen to one song closely. Write about the structure, lyrics, emotions, and what makes it work.',
        size: TaskSize.daily,
        category: 'Analysis',
        estimatedMinutes: 20,
        skillTags: ['music', 'creative', 'art', 'writing'],
      ),
      ProfileTask(
        title: 'Draft one creative piece',
        description: 'Start a short story, essay, or poem. Write the first draft — don\'t edit yet, just create.',
        size: TaskSize.daily,
        category: 'Writing',
        estimatedMinutes: 45,
        skillTags: ['writing', 'creative', 'story', 'poetry'],
      ),
    ],

    UserPersona.leader: [
      ProfileTask(
        title: 'Draft one announcement',
        description: 'Write one announcement for your club or organization. Make it clear, engaging, and actionable.',
        size: TaskSize.daily,
        category: 'Communication',
        estimatedMinutes: 20,
        skillTags: ['leader', 'organize', 'manage', 'president'],
      ),
      ProfileTask(
        title: 'Plan one meeting agenda',
        description: 'Create an agenda for your next meeting. Include topics, time limits, and who leads each item.',
        size: TaskSize.daily,
        category: 'Planning',
        estimatedMinutes: 20,
        skillTags: ['leader', 'organize', 'captain', 'manage'],
      ),
      ProfileTask(
        title: 'Check in with one team member',
        description: 'Reach out to one person on your team. Ask how they\'re doing, what they need, and what\'s going well.',
        size: TaskSize.daily,
        category: 'Leadership',
        estimatedMinutes: 15,
        skillTags: ['leader', 'team', 'captain', 'president'],
      ),
      ProfileTask(
        title: 'Review and improve one process',
        description: 'Pick one thing your organization does. How could it be done better? Write one improvement idea.',
        size: TaskSize.daily,
        category: 'Strategy',
        estimatedMinutes: 30,
        skillTags: ['leader', 'organize', 'manage', 'direct'],
      ),
    ],

    UserPersona.advocate: [
      ProfileTask(
        title: 'Write 200 words on an issue you care about',
        description: 'Write 200 words about a social issue that matters to you. Why does it matter? What\'s happening?',
        size: TaskSize.daily,
        category: 'Writing',
        estimatedMinutes: 30,
        skillTags: ['advocate', 'activism', 'campaign', 'rights'],
      ),
      ProfileTask(
        title: 'Research one policy or law',
        description: 'Find one policy or law related to your cause. Who made it? What does it do? What\'s the debate?',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['advocate', 'policy', 'rights', 'reform'],
      ),
      ProfileTask(
        title: 'Draft a social media post',
        description: 'Write one social media post about your cause. Make it informative, not preachy. Use one fact or story.',
        size: TaskSize.daily,
        category: 'Outreach',
        estimatedMinutes: 15,
        skillTags: ['advocate', 'activism', 'campaign', 'awareness'],
      ),
      ProfileTask(
        title: 'Contact one local organization',
        description: 'Find one organization working on your issue. Send them an email or message asking how you can help.',
        size: TaskSize.daily,
        category: 'Outreach',
        estimatedMinutes: 20,
        skillTags: ['advocate', 'activism', 'social', 'community'],
      ),
    ],

    UserPersona.entrepreneur: [
      ProfileTask(
        title: 'Validate one idea',
        description: 'Pick one business or nonprofit idea. Talk to 2 people who might use it. Would they actually pay/use it?',
        size: TaskSize.daily,
        category: 'Validation',
        estimatedMinutes: 45,
        skillTags: ['startup', 'business', 'founder', 'venture'],
      ),
      ProfileTask(
        title: 'Write one-page business plan',
        description: 'Write one page: What\'s the problem? Who has it? How do you solve it? Why you?',
        size: TaskSize.daily,
        category: 'Planning',
        estimatedMinutes: 45,
        skillTags: ['startup', 'business', 'entrepreneur', 'venture'],
      ),
      ProfileTask(
        title: 'Research one competitor',
        description: 'Find one organization doing something similar. What do they do well? What\'s missing?',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['startup', 'business', 'enterprise', 'innovation'],
      ),
      ProfileTask(
        title: 'Sketch your product/service',
        description: 'Draw or describe what your product or service looks like. What does the user see and do?',
        size: TaskSize.daily,
        category: 'Design',
        estimatedMinutes: 30,
        skillTags: ['startup', 'business', 'founder', 'design'],
      ),
    ],

    UserPersona.generalist: [
      ProfileTask(
        title: 'Try something new for 30 minutes',
        description: 'Spend 30 minutes on something you\'ve never tried before. A new skill, a new topic, a new activity.',
        size: TaskSize.daily,
        category: 'Exploration',
        estimatedMinutes: 30,
        skillTags: ['general'],
      ),
      ProfileTask(
        title: 'Write about what excites you',
        description: 'Write 200 words about something that genuinely excites you. No wrong answers.',
        size: TaskSize.daily,
        category: 'Reflection',
        estimatedMinutes: 20,
        skillTags: ['general'],
      ),
      ProfileTask(
        title: 'Research one career path',
        description: 'Look up one career that interests you. What do people in that field actually do day-to-day?',
        size: TaskSize.daily,
        category: 'Research',
        estimatedMinutes: 30,
        skillTags: ['general'],
      ),
    ],
  };

  // ─── WEEKLY TASKS (2-3hrs each) ───

  static final Map<UserPersona, List<ProfileTask>> _weeklyTasks = {
    UserPersona.maker: [
      ProfileTask(
        title: 'Build a feature prototype',
        description: 'Build a working prototype of one feature. It doesn\'t need to be polished — just functional enough to demo.',
        size: TaskSize.weekly,
        category: 'Project',
        estimatedMinutes: 180,
        skillTags: ['code', 'app', 'maker', 'build'],
        monthGoal: 'Complete app MVP',
      ),
      ProfileTask(
        title: 'Submit to a hackathon',
        description: 'Find an online hackathon and submit your project. Even if you don\'t win, the deadline forces focus.',
        size: TaskSize.weekly,
        category: 'Competition',
        estimatedMinutes: 120,
        skillTags: ['code', 'hackathon', 'maker', 'app'],
        monthGoal: 'Build competitive project',
      ),
      ProfileTask(
        title: 'Contribute to open source',
        description: 'Find an open-source project and make one contribution — fix a bug, improve docs, add a feature.',
        size: TaskSize.weekly,
        category: 'Community',
        estimatedMinutes: 120,
        skillTags: ['code', 'open source', 'maker', 'engineering'],
        monthGoal: 'Build public portfolio',
      ),
      ProfileTask(
        title: 'Record a project demo video',
        description: 'Record a 3-5 minute video showing your project in action. Explain what it does and why you built it.',
        size: TaskSize.weekly,
        category: 'Portfolio',
        estimatedMinutes: 150,
        skillTags: ['code', 'app', 'maker', 'video'],
        monthGoal: 'Create portfolio content',
      ),
      ProfileTask(
        title: 'Learn a new programming concept',
        description: 'Pick one concept you don\'t know well (APIs, databases, algorithms). Spend 2 hours learning and building a small example.',
        size: TaskSize.weekly,
        category: 'Learning',
        estimatedMinutes: 120,
        skillTags: ['code', 'app', 'maker', 'engineering'],
        monthGoal: 'Expand technical skills',
      ),
    ],

    UserPersona.researcher: [
      ProfileTask(
        title: 'Write a literature review section',
        description: 'Write 1000 words reviewing 5-10 sources on your topic. Compare findings, identify gaps.',
        size: TaskSize.weekly,
        category: 'Writing',
        estimatedMinutes: 180,
        skillTags: ['research', 'paper', 'writing', 'academic'],
        monthGoal: 'Complete research paper draft',
      ),
      ProfileTask(
        title: 'Conduct one experiment or data collection',
        description: 'Design and run one small experiment or collect one dataset. Record your method and initial findings.',
        size: TaskSize.weekly,
        category: 'Research',
        estimatedMinutes: 180,
        skillTags: ['research', 'experiment', 'data', 'science'],
        monthGoal: 'Complete research project',
      ),
      ProfileTask(
        title: 'Present your research to someone',
        description: 'Explain your research to a friend, teacher, or family member in 10 minutes. Note their questions.',
        size: TaskSize.weekly,
        category: 'Communication',
        estimatedMinutes: 120,
        skillTags: ['research', 'presentation', 'academic', 'writing'],
        monthGoal: 'Develop research communication',
      ),
    ],

    UserPersona.socialWorker: [
      ProfileTask(
        title: 'Organize one tutoring session',
        description: 'Find a student who needs help. Plan and deliver a 1-hour tutoring session. Document what you taught.',
        size: TaskSize.weekly,
        category: 'Service',
        estimatedMinutes: 150,
        skillTags: ['tutor', 'teach', 'volunteer', 'community'],
        monthGoal: 'Establish regular tutoring',
      ),
      ProfileTask(
        title: 'Visit a local community organization',
        description: 'Visit one local organization (shelter, food bank, community center). Learn what they do and how you can help.',
        size: TaskSize.weekly,
        category: 'Research',
        estimatedMinutes: 120,
        skillTags: ['community', 'volunteer', 'service', 'outreach'],
        monthGoal: 'Build community partnerships',
      ),
      ProfileTask(
        title: 'Create a volunteer recruitment plan',
        description: 'Design a plan to recruit 5 volunteers for a cause you care about. Who, how, when, why.',
        size: TaskSize.weekly,
        category: 'Planning',
        estimatedMinutes: 120,
        skillTags: ['volunteer', 'community', 'organize', 'lead'],
        monthGoal: 'Build volunteer network',
      ),
    ],

    UserPersona.creative: [
      ProfileTask(
        title: 'Complete one creative piece',
        description: 'Finish a short story, essay, poem, or artwork. Start to finish in one sitting if possible.',
        size: TaskSize.weekly,
        category: 'Creation',
        estimatedMinutes: 180,
        skillTags: ['writing', 'art', 'creative', 'story'],
        monthGoal: 'Build creative portfolio',
      ),
      ProfileTask(
        title: 'Start a creative series',
        description: 'Begin a series — 5 blog posts, 5 photos, 5 sketches. Commit to completing all 5 this month.',
        size: TaskSize.weekly,
        category: 'Series',
        estimatedMinutes: 150,
        skillTags: ['writing', 'photo', 'art', 'creative'],
        monthGoal: 'Create consistent body of work',
      ),
    ],

    UserPersona.leader: [
      ProfileTask(
        title: 'Lead one meeting',
        description: 'Plan and lead one meeting for your organization. Set agenda, facilitate discussion, assign action items.',
        size: TaskSize.weekly,
        category: 'Leadership',
        estimatedMinutes: 120,
        skillTags: ['leader', 'organize', 'captain', 'manage'],
        monthGoal: 'Develop leadership skills',
      ),
      ProfileTask(
        title: 'Organize one event',
        description: 'Plan and execute one small event — a workshop, discussion, or community gathering.',
        size: TaskSize.weekly,
        category: 'Events',
        estimatedMinutes: 180,
        skillTags: ['leader', 'organize', 'event', 'community'],
        monthGoal: 'Build event management skills',
      ),
    ],

    UserPersona.advocate: [
      ProfileTask(
        title: 'Write an op-ed or blog post',
        description: 'Write and publish (school paper, blog, Medium) an 800-word piece on a social issue you care about.',
        size: TaskSize.weekly,
        category: 'Writing',
        estimatedMinutes: 180,
        skillTags: ['advocate', 'writing', 'activism', 'campaign'],
        monthGoal: 'Build public voice',
      ),
      ProfileTask(
        title: 'Organize an awareness event',
        description: 'Plan one awareness event — film screening, panel discussion, letter-writing campaign.',
        size: TaskSize.weekly,
        category: 'Events',
        estimatedMinutes: 150,
        skillTags: ['advocate', 'activism', 'campaign', 'awareness'],
        monthGoal: 'Build advocacy campaign',
      ),
    ],

    UserPersona.entrepreneur: [
      ProfileTask(
        title: 'Build one landing page',
        description: 'Create a simple landing page for your idea. One headline, one description, one call to action.',
        size: TaskSize.weekly,
        category: 'Build',
        estimatedMinutes: 150,
        skillTags: ['startup', 'business', 'founder', 'web'],
        monthGoal: 'Launch MVP',
      ),
      ProfileTask(
        title: 'Interview 5 potential users',
        description: 'Talk to 5 people who might use your product/service. Ask open-ended questions, not leading ones.',
        size: TaskSize.weekly,
        category: 'Research',
        estimatedMinutes: 150,
        skillTags: ['startup', 'business', 'validate', 'research'],
        monthGoal: 'Validate product-market fit',
      ),
    ],

    UserPersona.generalist: [
      ProfileTask(
        title: 'Explore one activity deeply',
        description: 'Pick one activity and spend 2 hours on it. Go deeper than surface level. Write about what you learned.',
        size: TaskSize.weekly,
        category: 'Exploration',
        estimatedMinutes: 120,
        skillTags: ['general'],
        monthGoal: 'Find your spike',
      ),
      ProfileTask(
        title: 'Talk to someone in a career you\'re curious about',
        description: 'Find one person in a field you\'re interested in. Ask them about their work, their path, and what they wish they knew.',
        size: TaskSize.weekly,
        category: 'Research',
        estimatedMinutes: 90,
        skillTags: ['general'],
        monthGoal: 'Discover career interests',
      ),
    ],
  };

  // ─── MONTHLY TASKS (big projects) ───

  static final Map<UserPersona, List<ProfileTask>> _monthlyTasks = {
    UserPersona.maker: [
      ProfileTask(
        title: 'Launch your app or project publicly',
        description: 'Get your project to a state where others can use it. Publish to GitHub, App Store, or share a demo link.',
        size: TaskSize.monthly,
        category: 'Launch',
        estimatedMinutes: 600,
        skillTags: ['code', 'app', 'maker', 'launch'],
      ),
      ProfileTask(
        title: 'Complete a hackathon project end-to-end',
        description: 'From idea to submission. Build, test, document, and present a complete project in a hackathon.',
        size: TaskSize.monthly,
        category: 'Competition',
        estimatedMinutes: 600,
        skillTags: ['code', 'hackathon', 'maker', 'project'],
      ),
      ProfileTask(
        title: 'Build a portfolio website',
        description: 'Create a personal website showcasing your projects, skills, and what you\'re learning.',
        size: TaskSize.monthly,
        category: 'Portfolio',
        estimatedMinutes: 600,
        skillTags: ['code', 'web', 'maker', 'design'],
      ),
    ],

    UserPersona.researcher: [
      ProfileTask(
        title: 'Complete and submit a research paper',
        description: 'Finish your research paper and submit it to a journal, conference, or science fair.',
        size: TaskSize.monthly,
        category: 'Publication',
        estimatedMinutes: 600,
        skillTags: ['research', 'paper', 'academic', 'submit'],
      ),
      ProfileTask(
        title: 'Present at a science fair or conference',
        description: 'Prepare and deliver a presentation of your research. Create a poster or slide deck.',
        size: TaskSize.monthly,
        category: 'Presentation',
        estimatedMinutes: 600,
        skillTags: ['research', 'presentation', 'science', 'fair'],
      ),
    ],

    UserPersona.socialWorker: [
      ProfileTask(
        title: 'Start a recurring volunteer program',
        description: 'Create a sustainable volunteer program — weekly tutoring, monthly community service, ongoing mentoring.',
        size: TaskSize.monthly,
        category: 'Program',
        estimatedMinutes: 600,
        skillTags: ['volunteer', 'tutor', 'community', 'program'],
      ),
      ProfileTask(
        title: 'Organize a community service event',
        description: 'Plan and execute one community service event — fundraiser, awareness campaign, volunteer day.',
        size: TaskSize.monthly,
        category: 'Event',
        estimatedMinutes: 600,
        skillTags: ['community', 'event', 'volunteer', 'organize'],
      ),
    ],

    UserPersona.creative: [
      ProfileTask(
        title: 'Publish a portfolio of your work',
        description: 'Compile your best work into a portfolio — 10 pieces, well-presented, with descriptions.',
        size: TaskSize.monthly,
        category: 'Portfolio',
        estimatedMinutes: 600,
        skillTags: ['creative', 'portfolio', 'art', 'writing'],
      ),
      ProfileTask(
        title: 'Complete a creative project with a deadline',
        description: 'Commit to finishing one substantial creative project — short film, story collection, art series.',
        size: TaskSize.monthly,
        category: 'Project',
        estimatedMinutes: 600,
        skillTags: ['creative', 'project', 'film', 'art'],
      ),
    ],

    UserPersona.leader: [
      ProfileTask(
        title: 'Grow your organization\'s membership by 50%',
        description: 'Develop and execute a recruitment plan. Track numbers. Document what worked.',
        size: TaskSize.monthly,
        category: 'Growth',
        estimatedMinutes: 600,
        skillTags: ['leader', 'grow', 'recruit', 'organize'],
      ),
      ProfileTask(
        title: 'Establish a partnership with another organization',
        description: 'Find one organization to partner with. Formalize the relationship with a plan.',
        size: TaskSize.monthly,
        category: 'Partnerships',
        estimatedMinutes: 600,
        skillTags: ['leader', 'partner', 'organize', 'community'],
      ),
    ],

    UserPersona.advocate: [
      ProfileTask(
        title: 'Launch a month-long awareness campaign',
        description: 'Design and execute a 30-day campaign — daily posts, one event, measurable impact.',
        size: TaskSize.monthly,
        category: 'Campaign',
        estimatedMinutes: 600,
        skillTags: ['advocate', 'campaign', 'activism', 'awareness'],
      ),
    ],

    UserPersona.entrepreneur: [
      ProfileTask(
        title: 'Get 10 people to use your product/service',
        description: 'Ship something minimal. Get 10 real users. Get their feedback. Iterate.',
        size: TaskSize.monthly,
        category: 'Launch',
        estimatedMinutes: 600,
        skillTags: ['startup', 'launch', 'users', 'validate'],
      ),
    ],

    UserPersona.generalist: [
      ProfileTask(
        title: 'Commit to one activity for the entire month',
        description: 'Pick one activity. Do it every week for a month. At the end, decide if this is your thing.',
        size: TaskSize.monthly,
        category: 'Exploration',
        estimatedMinutes: 600,
        skillTags: ['general'],
      ),
    ],
  };

  // ─── WEEKLY BREAKDOWNS (how to split weekly tasks into daily steps) ───

  static final Map<String, List<String>> _weeklyBreakdowns = {
    'Build a feature prototype': [
      'Decide which feature to build and sketch the interface',
      'Set up the project structure and basic architecture',
      'Implement the core logic and data flow',
      'Connect the UI to the logic and test basic functionality',
      'Polish, fix bugs, and prepare a demo',
    ],
    'Submit to a hackathon': [
      'Research and register for an upcoming hackathon',
      'Brainstorm your idea and plan the architecture',
      'Build the core functionality',
      'Create the presentation/demo',
      'Write submission materials and submit',
    ],
    'Write a literature review section': [
      'Find and read 5 key papers on your topic',
      'Take detailed notes and identify common themes',
      'Write the introduction and methodology section',
      'Write the analysis and comparison section',
      'Write the conclusion and revise the full draft',
    ],
    'Organize one tutoring session': [
      'Find a student who needs help and understand their needs',
      'Plan your session outline and materials',
      'Prepare practice problems or activities',
      'Deliver the tutoring session',
      'Write a reflection on what worked and what to improve',
    ],
    'Complete one creative piece': [
      'Choose your topic and create an outline or rough draft',
      'Write/draw/create the first half',
      'Complete the second half',
      'Revise and polish the final version',
      'Share it with someone for feedback',
    ],
    'Launch your app or project publicly': [
      'Finalize the core features and fix critical bugs',
      'Write documentation and create a README',
      'Set up hosting or publishing (GitHub/App Store)',
      'Test on multiple devices/environments',
      'Publish and announce to your network',
    ],
    'Complete and submit a research paper': [
      'Finalize your research question and methodology',
      'Complete data collection and analysis',
      'Write the results and discussion sections',
      'Revise the full draft and format citations',
      'Submit to journal, conference, or science fair',
    ],
  };
}
