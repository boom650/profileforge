import 'package:freezed_annotation/freezed_annotation.dart';

part 'league.freezed.dart';
part 'league.g.dart';

/// League tiers from Bronze to Obsidian (Duolingo-style)
enum LeagueTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  obsidian;

  static const List<LeagueTier> all = [
    LeagueTier.bronze,
    LeagueTier.silver,
    LeagueTier.gold,
    LeagueTier.platinum,
    LeagueTier.diamond,
    LeagueTier.obsidian,
  ];

  static int indexOf(LeagueTier tier) => all.indexOf(tier);
  
  static LeagueTier? fromIndex(int index) {
    if (index >= 0 && index < all.length) return all[index];
    return null;
  }
}

extension LeagueTierExtension on LeagueTier {
  String get name => name;

  String get displayName {
    switch (this) {
      case LeagueTier.bronze:
        return 'Bronze League';
      case LeagueTier.silver:
        return 'Silver League';
      case LeagueTier.gold:
        return 'Gold League';
      case LeagueTier.platinum:
        return 'Platinum League';
      case LeagueTier.diamond:
        return 'Diamond League';
      case LeagueTier.obsidian:
        return 'Obsidian League';
    }
  }

  String get shortName {
    switch (this) {
      case LeagueTier.bronze:
        return 'Bronze';
      case LeagueTier.silver:
        return 'Silver';
      case LeagueTier.gold:
        return 'Gold';
      case LeagueTier.platinum:
        return 'Platinum';
      case LeagueTier.diamond:
        return 'Diamond';
      case LeagueTier.obsidian:
        return 'Obsidian';
    }
  }

  int get tierOrder {
    switch (this) {
      case LeagueTier.bronze:
        return 1;
      case LeagueTier.silver:
        return 2;
      case LeagueTier.gold:
        return 3;
      case LeagueTier.platinum:
        return 4;
      case LeagueTier.diamond:
        return 5;
      case LeagueTier.obsidian:
        return 6;
    }
  }

  int get minXP {
    switch (this) {
      case LeagueTier.bronze:
        return 0;
      case LeagueTier.silver:
        return 1000;
      case LeagueTier.gold:
        return 3000;
      case LeagueTier.platinum:
        return 7000;
      case LeagueTier.diamond:
        return 15000;
      case LeagueTier.obsidian:
        return 30000;
    }
  }

  int get maxXP {
    switch (this) {
      case LeagueTier.bronze:
        return 999;
      case LeagueTier.silver:
        return 2999;
      case LeagueTier.gold:
        return 6999;
      case LeagueTier.platinum:
        return 14999;
      case LeagueTier.diamond:
        return 29999;
      case LeagueTier.obsidian:
        return 999999;
    }
  }

  int get leagueSize {
    switch (this) {
      case LeagueTier.bronze:
        return 30;
      case LeagueTier.silver:
        return 30;
      case LeagueTier.gold:
        return 25;
      case LeagueTier.platinum:
        return 20;
      case LeagueTier.diamond:
        return 15;
      case LeagueTier.obsidian:
        return 10;
    }
  }

  int get promotionSpots {
    switch (this) {
      case LeagueTier.bronze:
        return 10;
      case LeagueTier.silver:
        return 8;
      case LeagueTier.gold:
        return 5;
      case LeagueTier.platinum:
        return 3;
      case LeagueTier.diamond:
        return 2;
      case LeagueTier.obsidian:
        return 0;
    }
  }

  int get demotionSpots {
    switch (this) {
      case LeagueTier.bronze:
        return 0;
      case LeagueTier.silver:
        return 5;
      case LeagueTier.gold:
        return 5;
      case LeagueTier.platinum:
        return 5;
      case LeagueTier.diamond:
        return 5;
      case LeagueTier.obsidian:
        return 3;
    }
  }

  String get colorHex {
    switch (this) {
      case LeagueTier.bronze:
        return '#CD7F32';
      case LeagueTier.silver:
        return '#C0C0C0';
      case LeagueTier.gold:
        return '#FFD700';
      case LeagueTier.platinum:
        return '#E5E4E2';
      case LeagueTier.diamond:
        return '#B9F2FF';
      case LeagueTier.obsidian:
        return '#1A1A2E';
    }
  }

  String get gradientStart {
    switch (this) {
      case LeagueTier.bronze:
        return '#CD7F32';
      case LeagueTier.silver:
        return '#C0C0C0';
      case LeagueTier.gold:
        return '#FFD700';
      case LeagueTier.platinum:
        return '#E5E4E2';
      case LeagueTier.diamond:
        return '#B9F2FF';
      case LeagueTier.obsidian:
        return '#1A1A2E';
    }
  }

  String get gradientEnd {
    switch (this) {
      case LeagueTier.bronze:
        return '#8B5A2B';
      case LeagueTier.silver:
        return '#A8A8A8';
      case LeagueTier.gold:
        return '#DAA520';
      case LeagueTier.platinum:
        return '#B0BEC5';
      case LeagueTier.diamond:
        return '#00BFFF';
      case LeagueTier.obsidian:
        return '#0F0F1A';
    }
  }

  String get iconAsset {
    switch (this) {
      case LeagueTier.bronze:
        return 'assets/images/leagues/bronze_icon.png';
      case LeagueTier.silver:
        return 'assets/images/leagues/silver_icon.png';
      case LeagueTier.gold:
        return 'assets/images/leagues/gold_icon.png';
      case LeagueTier.platinum:
        return 'assets/images/leagues/platinum_icon.png';
      case LeagueTier.diamond:
        return 'assets/images/leagues/diamond_icon.png';
      case LeagueTier.obsidian:
        return 'assets/images/leagues/obsidian_icon.png';
    }
  }

  String get badgeAsset {
    switch (this) {
      case LeagueTier.bronze:
        return 'assets/images/leagues/bronze_badge.png';
      case LeagueTier.silver:
        return 'assets/images/leagues/silver_badge.png';
      case LeagueTier.gold:
        return 'assets/images/leagues/gold_badge.png';
      case LeagueTier.platinum:
        return 'assets/images/leagues/platinum_badge.png';
      case LeagueTier.diamond:
        return 'assets/images/leagues/diamond_badge.png';
      case LeagueTier.obsidian:
        return 'assets/images/leagues/obsidian_badge.png';
    }
  }

  List<String> get rewards {
    switch (this) {
      case LeagueTier.bronze:
        return [
          'Bronze League Badge',
          '500 XP',
          '1 Freeze Token',
        ];
      case LeagueTier.silver:
        return [
          'Silver League Badge',
          '1500 XP',
          '2 Freeze Tokens',
          '1 Grace Day',
        ];
      case LeagueTier.gold:
        return [
          'Gold League Badge',
          '3000 XP',
          '3 Freeze Tokens',
          '2 Grace Days',
          'Gold Frame Skin',
        ];
      case LeagueTier.platinum:
        return [
          'Platinum League Badge',
          '5000 XP',
          '5 Freeze Tokens',
          '3 Grace Days',
          'Platinum Frame Skin',
          'Exclusive Title',
        ];
      case LeagueTier.diamond:
        return [
          'Diamond League Badge',
          '10000 XP',
          '10 Freeze Tokens',
          '5 Grace Days',
          'Diamond Frame Skin',
          'Exclusive Title',
          'Profile Background',
        ];
      case LeagueTier.obsidian:
        return [
          'Obsidian League Badge',
          '25000 XP',
          '20 Freeze Tokens',
          '10 Grace Days',
          'Obsidian Frame Skin',
          'Legendary Title',
          'Animated Profile Background',
          'Custom Particle Effect',
        ];
    }
  }

  String get description {
    switch (this) {
      case LeagueTier.bronze:
        return 'Welcome to the leagues! Build your streak and climb.';
      case LeagueTier.silver:
        return 'You\'re gaining momentum. Keep the streak alive!';
      case LeagueTier.gold:
        return 'Impressive consistency. You\'re becoming a habit master.';
      case LeagueTier.platinum:
        return 'Elite tier. Your dedication is inspiring.';
      case LeagueTier.diamond:
        return 'Among the best. Your profile shines bright.';
      case LeagueTier.obsidian:
        return 'Legendary. You define what\'s possible.';
    }
  }
}

/// Individual player's league standing
@freezed
abstract class LeagueStanding with _$LeagueStanding {
  const factory LeagueStanding({
    required String userId,
    required String username,
    required String avatarUrl,
    required LeagueTier currentTier,
    required int weeklyXP,
    required int rank,
    required int previousRank,
    required int streakDays,
    required bool isPromoted,
    required bool isDemoted,
    required bool isNewEntry,
    required List<LeagueAchievement> achievements,
  }) = _LeagueStanding;

  factory LeagueStanding.fromJson(Map<String, dynamic> json) => _$LeagueStandingFromJson(json);
}

/// League achievements for special accomplishments
@freezed
abstract class LeagueAchievement with _$LeagueAchievement {
  const factory LeagueAchievement({
    required String id,
    required String name,
    required String description,
    required String iconAsset,
    required DateTime earnedAt,
    required LeagueTier tierWhenEarned,
  }) = _LeagueAchievement;

  factory LeagueAchievement.fromJson(Map<String, dynamic> json) => _$LeagueAchievementFromJson(json);
}

/// League configuration for a season/week
@freezed
abstract class LeagueSeason with _$LeagueSeason {
  const factory LeagueSeason({
    required int seasonNumber,
    required int weekNumber,
    required int year,
    required DateTime startDate,
    required DateTime endDate,
    required Map<LeagueTier, LeagueTierConfig> tierConfigs,
    required LeagueRewardPool rewardPool,
    required bool isActive,
  }) = _LeagueSeason;

  factory LeagueSeason.fromJson(Map<String, dynamic> json) => _$LeagueSeasonFromJson(json);
}

@freezed
abstract class LeagueTierConfig with _$LeagueTierConfig {
  const factory LeagueTierConfig({
    required LeagueTier tier,
    required int leagueSize,
    required int promotionSpots,
    required int demotionSpots,
    required int minXPToEnter,
    required List<LeagueReward> rewards,
    required String divisionName,
  }) = _LeagueTierConfig;

  factory LeagueTierConfig.fromJson(Map<String, dynamic> json) => _$LeagueTierConfigFromJson(json);
}

@freezed
abstract class LeagueReward with _$LeagueReward {
  const factory LeagueReward({
    required String id,
    required String name,
    required String description,
    required String iconAsset,
    required RewardType type,
    required int amount,
    required int rankRequired,
  }) = _LeagueReward;

  factory LeagueReward.fromJson(Map<String, dynamic> json) => _$LeagueRewardFromJson(json);
}

enum RewardType {
  xp,
  freezeToken,
  graceDay,
  skin,
  frame,
  badge,
  title,
  background,
  particleEffect,
  coins,
}

@freezed
abstract class LeagueRewardPool with _$LeagueRewardPool {
  const factory LeagueRewardPool({
    required int totalXP,
    required int totalFreezeTokens,
    required int totalGraceDays,
    required List<String> exclusiveSkins,
    required List<String> exclusiveFrames,
    required List<String> exclusiveTitles,
    required List<String> exclusiveBackgrounds,
  }) = _LeagueRewardPool;

  factory LeagueRewardPool.fromJson(Map<String, dynamic> json) => _$LeagueRewardPoolFromJson(json);
}

/// Player's league profile
@freezed
abstract class LeagueProfile with _$LeagueProfile {
  const factory LeagueProfile({
    required String userId,
    required LeagueTier currentTier,
    required int totalLeagueXP,
    required int currentSeasonNumber,
    required int currentWeekNumber,
    required int currentRank,
    required int highestTierReached,
    required int highestRankAchieved,
    required int weeksInCurrentTier,
    required int totalPromotions,
    required int totalDemotions,
    required Map<int, LeagueStanding> seasonHistory,
    required List<LeagueAchievement> achievements,
    required DateTime lastWeekReset,
    required bool isShielded,
    required int shieldUsesRemaining,
  }) = _LeagueProfile;

  factory LeagueProfile.fromJson(Map<String, dynamic> json) => _$LeagueProfileFromJson(json);

  factory LeagueProfile.initial(String userId) => LeagueProfile(
        userId: userId,
        currentTier: LeagueTier.bronze,
        totalLeagueXP: 0,
        currentSeasonNumber: 1,
        currentWeekNumber: 1,
        currentRank: 0,
        highestTierReached: 1,
        highestRankAchieved: 0,
        weeksInCurrentTier: 0,
        totalPromotions: 0,
        totalDemotions: 0,
        seasonHistory: {},
        achievements: [],
        lastWeekReset: DateTime.now(),
        isShielded: false,
        shieldUsesRemaining: 0,
      );
}

/// Weekly league matchmaking group
@freezed
abstract class LeagueGroup with _$LeagueGroup {
  const factory LeagueGroup({
    required String groupId,
    required LeagueTier tier,
    required int weekNumber,
    required int year,
    required List<String> memberIds,
    required Map<String, int> memberXP,
    required Map<String, int> memberRanks,
    required DateTime createdAt,
    required DateTime endsAt,
    required bool isFinalized,
  }) = _LeagueGroup;

  factory LeagueGroup.fromJson(Map<String, dynamic> json) => _$LeagueGroupFromJson(json);
}

/// League notification types
@freezed
abstract class LeagueNotification with _$LeagueNotification {
  const factory LeagueNotification.promotion({
    required String id,
    required String userId,
    required LeagueTier fromTier,
    required LeagueTier toTier,
    required int rank,
    required DateTime timestamp,
    required bool isRead,
  }) = _PromotionNotification;

  const factory LeagueNotification.demotion({
    required String id,
    required String userId,
    required LeagueTier fromTier,
    required LeagueTier toTier,
    required int rank,
    required DateTime timestamp,
    required bool isRead,
  }) = _DemotionNotification;

  const factory LeagueNotification.rankChange({
    required String id,
    required String userId,
    required int oldRank,
    required int newRank,
    required LeagueTier tier,
    required DateTime timestamp,
    required bool isRead,
  }) = _RankChangeNotification;

  const factory LeagueNotification.achievementEarned({
    required String id,
    required String userId,
    required LeagueAchievement achievement,
    required DateTime timestamp,
    required bool isRead,
  }) = _AchievementNotification;

  const factory LeagueNotification.weeklyRewards({
    required String id,
    required String userId,
    required LeagueTier tier,
    required int rank,
    required List<LeagueReward> rewards,
    required DateTime timestamp,
    required bool isRead,
  }) = _WeeklyRewardsNotification;

  const factory LeagueNotification.leagueStarting({
    required String id,
    required String userId,
    required LeagueTier tier,
    required DateTime startTime,
    required bool isRead,
  }) = _LeagueStartingNotification;

  const factory LeagueNotification.shieldEarned({
    required String id,
    required String userId,
    required int shieldCount,
    required DateTime timestamp,
    required bool isRead,
  }) = _ShieldEarnedNotification;

  factory LeagueNotification.fromJson(Map<String, dynamic> json) => _$LeagueNotificationFromJson(json);
}

/// League settings/configuration
@freezed
abstract class LeagueSettings with _$LeagueSettings {
  const factory LeagueSettings({
    required bool leaguesEnabled,
    required bool autoJoin,
    required bool notificationsEnabled,
    required bool showInLeaderboard,
    required bool shareProgress,
    required LeagueTier preferredTier,
    required bool competitiveMode,
  }) = _LeagueSettings;

  factory LeagueSettings.fromJson(Map<String, dynamic> json) => _$LeagueSettingsFromJson(json);

  factory LeagueSettings.defaultSettings() => LeagueSettings(
        leaguesEnabled: true,
        autoJoin: true,
        notificationsEnabled: true,
        showInLeaderboard: true,
        shareProgress: false,
        preferredTier: LeagueTier.bronze,
        competitiveMode: false,
      );
}