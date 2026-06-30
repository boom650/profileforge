import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak.freezed.dart';
part 'streak.g.dart';

/// Humane streak system with grace days (not punitive)
@freezed
abstract class Streak with _$Streak {
  const factory Streak({
    required int currentStreak,
    required int longestStreak,
    required int totalActiveDays,
    required int freezeTokens,
    required int graceDaysRemaining,
    required int graceDaysUsedThisWeek,
    required DateTime? lastActiveDate,
    required DateTime? streakStartDate,
    required List<StreakMilestone> milestonesAchieved,
    required List<GraceDayUsage> graceDayHistory,
    required DateTime? lastFreezeTokenEarned,
    required int weeklyCheckInTarget,
    required int weeklyCheckInsCompleted,
    required DateTime lastWeekReset,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);

  factory Streak.initial() => Streak(
        currentStreak: 0,
        longestStreak: 0,
        totalActiveDays: 0,
        freezeTokens: 3,
        graceDaysRemaining: 2,
        graceDaysUsedThisWeek: 0,
        lastActiveDate: null,
        streakStartDate: null,
        milestonesAchieved: [],
        graceDayHistory: [],
        lastFreezeTokenEarned: null,
        weeklyCheckInTarget: 5,
        weeklyCheckInsCompleted: 0,
        lastWeekReset: DateTime.now(),
      );
}

/// Streak milestones that grant rewards
@freezed
abstract class StreakMilestone with _$StreakMilestone {
  const factory StreakMilestone({
    required String id,
    required StreakMilestoneType type,
    required int daysRequired,
    required String title,
    required String description,
    required int xpReward,
    required int freezeTokenReward,
    required int graceDayReward,
    required DateTime achievedAt,
    required bool isClaimed,
  }) = _StreakMilestone;

  factory StreakMilestone.fromJson(Map<String, dynamic> json) => _$StreakMilestoneFromJson(json);
}

enum StreakMilestoneType {
  threeDay,       // 3 days
  sevenDay,       // 7 days (1 week)
  fourteenDay,    // 14 days (2 weeks)
  twentyOneDay,   // 21 days (3 weeks - habit formation)
  thirtyDay,      // 30 days (1 month)
  sixtyDay,       // 60 days
  ninetyDay,      // 90 days (quarter)
  oneEightyDay,   // 180 days (half year)
  threeSixtyFiveDay, // 365 days (1 year)
}

/// Grace day usage tracking
@freezed
abstract class GraceDayUsage with _$GraceDayUsage {
  const factory GraceDayUsage({
    required String id,
    required DateTime dateUsed,
    required GraceDayReason reason,
    required String? note,
    required bool wasAutoApplied,
  }) = _GraceDayUsage;

  factory GraceDayUsage.fromJson(Map<String, dynamic> json) => _$GraceDayUsageFromJson(json);
}

enum GraceDayReason {
  sick,           // Illness
  familyEmergency, // Family emergency
  travel,         // Travel/no internet
  exams,          // Exam period
  mentalHealth,   // Mental health day
  technicalIssue, // App/device issues
  other,          // Other valid reason
}

/// Humane streak configuration
@freezed
abstract class StreakConfig with _$StreakConfig {
  const factory StreakConfig({
    required int startingFreezeTokens,
    required int maxFreezeTokens,
    required int weeklyGraceDays,
    required int maxGraceDaysPerMonth,
    required int freezeTokenEarnIntervalDays, // Earn 1 token every N days of streak
    required List<StreakMilestoneConfig> milestones,
    required Map<GraceDayReason, int> graceDayCosts, // Some reasons cost more
    required bool allowRetroactiveGraceDays,
    required int retroactiveWindowDays,
  }) = _StreakConfig;

  factory StreakConfig.fromJson(Map<String, dynamic> json) => _$StreakConfigFromJson(json);

  factory StreakConfig.defaultConfig() => StreakConfig(
        startingFreezeTokens: 3,
        maxFreezeTokens: 5,
        weeklyGraceDays: 2,
        maxGraceDaysPerMonth: 6,
        freezeTokenEarnIntervalDays: 14,
        milestones: [
          StreakMilestoneConfig(
            type: StreakMilestoneType.threeDay,
            daysRequired: 3,
            title: 'Getting Started',
            description: '3 days of consistency',
            xpReward: 50,
            freezeTokenReward: 0,
            graceDayReward: 0,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.sevenDay,
            daysRequired: 7,
            title: 'One Week Wonder',
            description: '7 days straight - a habit is forming',
            xpReward: 100,
            freezeTokenReward: 1,
            graceDayReward: 0,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.fourteenDay,
            daysRequired: 14,
            title: 'Two Week Streak',
            description: '14 days - consistency compounding',
            xpReward: 200,
            freezeTokenReward: 1,
            graceDayReward: 0,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.twentyOneDay,
            daysRequired: 21,
            title: 'Habit Formed',
            description: '21 days - science says this builds habits',
            xpReward: 350,
            freezeTokenReward: 1,
            graceDayReward: 1,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.thirtyDay,
            daysRequired: 30,
            title: 'Monthly Master',
            description: '30 days - a full month of showing up',
            xpReward: 500,
            freezeTokenReward: 1,
            graceDayReward: 1,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.sixtyDay,
            daysRequired: 60,
            title: 'Quarterly Champion',
            description: '60 days - two months of dedication',
            xpReward: 1000,
            freezeTokenReward: 2,
            graceDayReward: 1,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.ninetyDay,
            daysRequired: 90,
            title: 'Quarterly Legend',
            description: '90 days - a full quarter of consistency',
            xpReward: 2000,
            freezeTokenReward: 2,
            graceDayReward: 2,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.oneEightyDay,
            daysRequired: 180,
            title: 'Half Year Hero',
            description: '180 days - half a year of unwavering commitment',
            xpReward: 4000,
            freezeTokenReward: 3,
            graceDayReward: 2,
          ),
          StreakMilestoneConfig(
            type: StreakMilestoneType.threeSixtyFiveDay,
            daysRequired: 365,
            title: 'Year of Mastery',
            description: '365 days - a full year. You ARE consistency.',
            xpReward: 10000,
            freezeTokenReward: 5,
            graceDayReward: 5,
          ),
        ],
        graceDayCosts: {
          GraceDayReason.sick: 1,
          GraceDayReason.familyEmergency: 1,
          GraceDayReason.travel: 1,
          GraceDayReason.exams: 1,
          GraceDayReason.mentalHealth: 1,
          GraceDayReason.technicalIssue: 1,
          GraceDayReason.other: 1,
        },
        allowRetroactiveGraceDays: true,
        retroactiveWindowDays: 3,
      );
}

@freezed
abstract class StreakMilestoneConfig with _$StreakMilestoneConfig {
  const factory StreakMilestoneConfig({
    required StreakMilestoneType type,
    required int daysRequired,
    required String title,
    required String description,
    required int xpReward,
    required int freezeTokenReward,
    required int graceDayReward,
  }) = _StreakMilestoneConfig;

  factory StreakMilestoneConfig.fromJson(Map<String, dynamic> json) => _$StreakMilestoneConfigFromJson(json);
}

/// Result of marking a day as active
@freezed
abstract class StreakActionResult with _$StreakActionResult {
  const factory StreakActionResult.success({
    required Streak newStreak,
    required List<StreakMilestone> newMilestones,
    required int xpEarned,
    required int freezeTokensEarned,
    required int graceDaysEarned,
    required String message,
  }) = _StreakActionResultSuccess;

  const factory StreakActionResult.graceDayUsed({
    required Streak newStreak,
    required GraceDayUsage graceDayUsage,
    required String message,
  }) = _StreakActionResultGraceDayUsed;

  const factory StreakActionResult.freezeTokenUsed({
    required Streak newStreak,
    required int tokensUsed,
    required String message,
  }) = _StreakActionResultFreezeTokenUsed;

  const factory StreakActionResult.streakBroken({
    required Streak newStreak,
    required int previousStreak,
    required String message,
    required String encouragementMessage,
  }) = _StreakActionResultStreakBroken;

  const factory StreakActionResult.alreadyMarked({
    required Streak streak,
    required String message,
  }) = _StreakActionResultAlreadyMarked;

  factory StreakActionResult.fromJson(Map<String, dynamic> json) => _$StreakActionResultFromJson(json);
}