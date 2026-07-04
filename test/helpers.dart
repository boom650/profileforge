import 'package:profileforge/models/gamification/streak.dart';
import 'package:profileforge/models/gamification/xp.dart';
import 'package:profileforge/models/gamification/missions.dart';
import 'package:profileforge/models/gamification/skins.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import 'package:profileforge/models/student_profile.dart';
import 'package:profileforge/services/gamification/gamification_service.dart';

// ---------------------------------------------------------------------------
// Sample Student Profiles
// ---------------------------------------------------------------------------

StudentProfile sampleStudentProfile() => StudentProfile(
      id: 'test-student-001',
      name: 'Priya Sharma',
      email: 'priya@test.com',
      phone: '+919****3210',
      board: 'CBSE',
      stream: 'Science',
      grade: 11,
      subjects: {
        'Mathematics': 92.0,
        'Physics': 88.0,
        'Chemistry': 85.0,
        'English': 90.0,
      },
      tenthPercentage: 89.5,
      coachingInstitute: 'FIITJEE',
      coachingHoursPerWeek: 12,
      satScore: 1450,
      ieltsScore: null,
      targetCountries: ['USA', 'UK'],
      targetMajor: 'Computer Science',
      reachUniversities: ['MIT', 'Stanford'],
      matchUniversities: ['UC Berkeley', 'UCLA'],
      safetyUniversities: ['UC Davis', 'UC Santa Cruz'],
      activities: [],
      schedule: WeeklySchedule.empty(),
      motivation: MotivationProfile.empty(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 15),
    );

// ---------------------------------------------------------------------------
// Sample Streaks
// ---------------------------------------------------------------------------

Streak sampleFreshStreak() => Streak.initial();

Streak sampleActiveStreak({int currentStreak = 7}) =>
    Streak.initial().copyWith(
      currentStreak: currentStreak,
      longestStreak: currentStreak,
      totalActiveDays: currentStreak,
      lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
      streakStartDate: DateTime.now().subtract(Duration(days: currentStreak)),
    );

Streak sampleLongStreak({int currentStreak = 45}) =>
    sampleActiveStreak(currentStreak: currentStreak).copyWith(
      freezeTokens: 2,
      freezeTokensEarned: 3,
      graceDaysRemaining: 1,
    );

// ---------------------------------------------------------------------------
// Sample XP States
// ---------------------------------------------------------------------------

XPState sampleFreshXP() => XPState.initial();

XPState sampleMidGameXP() => XPState.initial().copyWith(
      totalXP: 2500,
      currentLevel: XPUtils.levelFromXP(2500),
      xpToNextLevel: XPUtils.xpToNextLevel(2500),
      pillarXP: {
        AdmissionsPillar.academics: 800,
        AdmissionsPillar.evidence: 500,
        AdmissionsPillar.consistency: 400,
        AdmissionsPillar.research: 200,
        AdmissionsPillar.leadership: 300,
        AdmissionsPillar.creativity: 150,
        AdmissionsPillar.communityImpact: 150,
      },
      lifetimeXPEarned: 2500,
    );

// ---------------------------------------------------------------------------
// Sample Missions
// ---------------------------------------------------------------------------

Mission sampleDailyMission() => Mission(
      id: 'mission_daily_001',
      title: 'Daily Check-in',
      description: 'Just open the app and check in',
      type: MissionType.daily,
      category: MissionCategory.wellbeing,
      difficulty: MissionDifficulty.easy,
      xpReward: 20,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'daily_checkin', 'count': 1},
      prerequisites: [],
      isCompleted: false,
      isClaimed: false,
      completedAt: null,
      claimedAt: null,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      metadata: null,
      progressCurrent: 0,
      progressTarget: 1,
      progressUnit: 'check-in',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'habit'],
    );

Mission sampleWeeklyMission() => Mission(
      id: 'mission_weekly_001',
      title: 'Create Weekly Plan',
      description: 'Map out your week',
      type: MissionType.weekly,
      category: MissionCategory.profile,
      difficulty: MissionDifficulty.easy,
      xpReward: 100,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'create_weekly_plan', 'count': 1},
      prerequisites: [],
      isCompleted: false,
      isClaimed: false,
      completedAt: null,
      claimedAt: null,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      metadata: null,
      progressCurrent: 0,
      progressTarget: 1,
      progressUnit: 'plan',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'planning'],
    );

Mission sampleProgressMission({int target = 3, int current = 0}) => Mission(
      id: 'mission_progress_001',
      title: 'Practice Problem Set',
      description: 'Complete 3 problem sets',
      type: MissionType.daily,
      category: MissionCategory.academics,
      difficulty: MissionDifficulty.medium,
      xpReward: 100,
      pillar: AdmissionsPillar.academics,
      completionCriteria: {'action': 'practice_problems', 'count': target},
      prerequisites: [],
      isCompleted: current >= target,
      isClaimed: false,
      completedAt: null,
      claimedAt: null,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      metadata: null,
      progressCurrent: current,
      progressTarget: target,
      progressUnit: 'problems',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'practice'],
    );

// ---------------------------------------------------------------------------
// Sample Services
// ---------------------------------------------------------------------------

GamificationService createFreshGamificationService() => GamificationService();

// ---------------------------------------------------------------------------
// Assertion Helpers
// ---------------------------------------------------------------------------

void assertStreakDefaults(Streak streak) {
  assert(streak.currentStreak == 0, 'currentStreak should be 0');
  assert(streak.longestStreak == 0, 'longestStreak should be 0');
  assert(streak.totalActiveDays == 0, 'totalActiveDays should be 0');
  assert(streak.freezeTokens == 3, 'freezeTokens should be 3');
  assert(streak.maxFreezeTokens == 5, 'maxFreezeTokens should be 5');
  assert(streak.freezeTokensEarned == 0, 'freezeTokensEarned should be 0');
  assert(streak.graceDaysRemaining == 2, 'graceDaysRemaining should be 2');
  assert(streak.graceDaysUsedThisWeek == 0, 'graceDaysUsedThisWeek should be 0');
  assert(streak.lastActiveDate == null, 'lastActiveDate should be null');
  assert(streak.streakStartDate == null, 'streakStartDate should be null');
  assert(streak.milestonesAchieved.isEmpty, 'milestonesAchieved should be empty');
  assert(streak.graceDayHistory.isEmpty, 'graceDayHistory should be empty');
  assert(streak.lastFreezeTokenEarned == null, 'lastFreezeTokenEarned should be null');
  assert(streak.weeklyCheckInTarget == 5, 'weeklyCheckInTarget should be 5');
  assert(streak.weeklyCheckInsCompleted == 0, 'weeklyCheckInsCompleted should be 0');
  assert(streak.hasWeekendAmulet == false, 'hasWeekendAmulet should be false');
  assert(streak.weekendAmuletExpiresAt == null, 'weekendAmuletExpiresAt should be null');
  assert(streak.weeklyActivityPattern.length == 7, 'weeklyActivityPattern should have 7 items');
  assert(
    streak.weeklyActivityPattern.every((e) => e == 0),
    'weeklyActivityPattern should be all zeros',
  );
}

void assertXPDefaults(XPState xp) {
  assert(xp.totalXP == 0, 'totalXP should be 0');
  assert(xp.currentLevel == 1, 'currentLevel should be 1');
  assert(xp.xpToNextLevel == 100, 'xpToNextLevel should be 100');
  assert(xp.lifetimeXPEarned == 0, 'lifetimeXPEarned should be 0');
  assert(xp.transactionHistory.isEmpty, 'transactionHistory should be empty');
  assert(xp.pillarXP.length == 7, 'pillarXP should have 7 entries');
  assert(
    xp.pillarXP.values.every((v) => v == 0),
    'all pillar XP should be 0',
  );
  assert(xp.pillarLevels.length == 7, 'pillarLevels should have 7 entries');
  assert(
    xp.pillarLevels.values.every((v) => v == 1),
    'all pillar levels should start at 1',
  );
}
