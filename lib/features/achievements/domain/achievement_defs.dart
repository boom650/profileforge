/// Achievement/badge definitions used in the app.
class AchievementDef {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String criteriaType; // 'streak', 'xp_total', 'missions_total', 'focus_total', 'quests_total', 'daily_login', 'skins_unlocked', 'focus_sessions'
  final int criteriaValue; // threshold to unlock

  const AchievementDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.criteriaType,
    required this.criteriaValue,
  });

  static const List<AchievementDef> all = [
    // Streak badges
    AchievementDef(id: 'streak_3', name: 'Getting Started', description: 'Maintain a 3-day streak', icon: '🔥', criteriaType: 'streak', criteriaValue: 3),
    AchievementDef(id: 'streak_7', name: 'Week Warrior', description: 'Maintain a 7-day streak', icon: '💪', criteriaType: 'streak', criteriaValue: 7),
    AchievementDef(id: 'streak_14', name: 'Two Weeks Strong', description: 'Maintain a 14-day streak', icon: '⚡', criteriaType: 'streak', criteriaValue: 14),
    AchievementDef(id: 'streak_30', name: 'Monthly Master', description: 'Maintain a 30-day streak', icon: '👑', criteriaType: 'streak', criteriaValue: 30),
    AchievementDef(id: 'streak_60', name: 'Diamond Streak', description: 'Maintain a 60-day streak', icon: '💎', criteriaType: 'streak', criteriaValue: 60),
    AchievementDef(id: 'streak_100', name: 'Legendary Streak', description: 'Maintain a 100-day streak', icon: '🌟', criteriaType: 'streak', criteriaValue: 100),

    // XP badges
    AchievementDef(id: 'xp_100', name: 'First Steps', description: 'Earn 100 XP total', icon: '⭐', criteriaType: 'xp_total', criteriaValue: 100),
    AchievementDef(id: 'xp_500', name: 'XP Apprentice', description: 'Earn 500 XP total', icon: '🌟', criteriaType: 'xp_total', criteriaValue: 500),
    AchievementDef(id: 'xp_1000', name: 'XP Adept', description: 'Earn 1,000 XP total', icon: '🌙', criteriaType: 'xp_total', criteriaValue: 1000),
    AchievementDef(id: 'xp_5000', name: 'XP Master', description: 'Earn 5,000 XP total', icon: '☀️', criteriaType: 'xp_total', criteriaValue: 5000),
    AchievementDef(id: 'xp_10000', name: 'XP Legend', description: 'Earn 10,000 XP total', icon: '🏆', criteriaType: 'xp_total', criteriaValue: 10000),

    // Missions badges
    AchievementDef(id: 'missions_5', name: 'Mission Starter', description: 'Complete 5 missions', icon: '📋', criteriaType: 'missions_total', criteriaValue: 5),
    AchievementDef(id: 'missions_25', name: 'Mission Seeker', description: 'Complete 25 missions', icon: '📚', criteriaType: 'missions_total', criteriaValue: 25),
    AchievementDef(id: 'missions_100', name: 'Mission Machine', description: 'Complete 100 missions', icon: '🚀', criteriaType: 'missions_total', criteriaValue: 100),

    // Focus timer badges
    AchievementDef(id: 'focus_1', name: 'First Focus', description: 'Complete your first focus session', icon: '⏱️', criteriaType: 'focus_sessions', criteriaValue: 1),
    AchievementDef(id: 'focus_10', name: 'Focus Apprentice', description: 'Complete 10 focus sessions', icon: '🎯', criteriaType: 'focus_sessions', criteriaValue: 10),
    AchievementDef(id: 'focus_30', name: 'Focus Master', description: 'Complete 30 focus sessions', icon: '🧠', criteriaType: 'focus_sessions', criteriaValue: 30),
    AchievementDef(id: 'focus_100', name: 'Zen Master', description: 'Complete 100 focus sessions', icon: '🧘', criteriaType: 'focus_sessions', criteriaValue: 100),

    // Quests badges
    AchievementDef(id: 'quests_5', name: 'Quest Beginner', description: 'Complete 5 daily quests', icon: '🗺️', criteriaType: 'quests_total', criteriaValue: 5),
    AchievementDef(id: 'quests_25', name: 'Quest Adventurer', description: 'Complete 25 daily quests', icon: '🗡️', criteriaType: 'quests_total', criteriaValue: 25),
    AchievementDef(id: 'quests_100', name: 'Quest Legend', description: 'Complete 100 daily quests', icon: '🏰', criteriaType: 'quests_total', criteriaValue: 100),

    // Login badges
    AchievementDef(id: 'login_7', name: 'Week of Welcome', description: 'Claim 7 daily login rewards', icon: '📅', criteriaType: 'daily_login', criteriaValue: 7),
    AchievementDef(id: 'login_30', name: 'Monthly Member', description: 'Claim 30 daily login rewards', icon: '📆', criteriaType: 'daily_login', criteriaValue: 30),

    // Skin collector
    AchievementDef(id: 'skins_3', name: 'Skin Collector', description: 'Unlock 3 skins', icon: '🎨', criteriaType: 'skins_unlocked', criteriaValue: 3),
    AchievementDef(id: 'skins_10', name: 'Fashion Icon', description: 'Unlock 10 skins', icon: '💃', criteriaType: 'skins_unlocked', criteriaValue: 10),

    // Minutes studied
    AchievementDef(id: 'focus_min_60', name: 'Hour of Power', description: 'Study for 60 total minutes', icon: '⌛', criteriaType: 'focus_total', criteriaValue: 60),
    AchievementDef(id: 'focus_min_300', name: '5 Hours Strong', description: 'Study for 300 total minutes', icon: '⏳', criteriaType: 'focus_total', criteriaValue: 300),
    AchievementDef(id: 'focus_min_1000', name: 'Study Marathon', description: 'Study for 1,000 total minutes', icon: '🏃', criteriaType: 'focus_total', criteriaValue: 1000),
  ];

  static AchievementDef? byId(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
