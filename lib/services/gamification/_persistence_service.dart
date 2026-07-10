import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/missions.dart';

mixin PersistenceService on GamificationService {
  static const String _prefsKey = 'gamification_state';

  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString == null) return;

      final state = jsonDecode(jsonString) as Map<String, dynamic>;

      try {
        final xpJson = state['xpState'];
        if (xpJson is Map<String, dynamic>) {
          xpState = XPState.fromJson(xpJson);
        }
      } catch (_) {
        // Keep default XPState
      }

      try {
        final streakJson = state['streak'];
        if (streakJson is Map<String, dynamic>) {
          streak = Streak.fromJson(streakJson);
        }
      } catch (_) {
        // Keep default Streak
      }

      try {
        final missionsJson = state['missions'];
        if (missionsJson is List) {
          missions
            ..clear()
            ..addAll(
              missionsJson
                  .whereType<Map<String, dynamic>>()
                  .map((m) => Mission.fromJson(m)),
            );
        }
      } catch (_) {
        // Keep default (empty) missions
      }

      try {
        final wmsJson = state['weeklyMissionSet'];
        if (wmsJson is Map<String, dynamic>) {
          weeklyMissionSet = WeeklyMissionSet.fromJson(wmsJson);
        } else {
          weeklyMissionSet = null;
        }
      } catch (_) {
        weeklyMissionSet = null;
      }

      try {
        final skinsJson = state['ownedSkins'];
        if (skinsJson is Map<String, dynamic>) {
          ownedSkins.clear();
          for (final entry in skinsJson.entries) {
            try {
              final tier = SkinTier.values.firstWhere(
                (t) => t.name == entry.key,
                orElse: () => SkinTier.explorer,
              );
              if (entry.value is Map<String, dynamic>) {
                ownedSkins[tier] = Skin.fromJson(entry.value);
              }
            } catch (_) {
              // Skip corrupt skin entry
            }
          }
          // Ensure explorer is always present
          if (!ownedSkins.containsKey(SkinTier.explorer)) {
            ownedSkins[SkinTier.explorer] = SkinCatalog.getConfig(
              SkinTier.explorer,
            ).toSkin(unlocked: true);
          }
        }
      } catch (_) {
        // Keep default owned skins (explorer)
      }

      try {
        final skinName = state['equippedSkin'] as String?;
        if (skinName != null) {
          equippedSkinTier = SkinTier.values.firstWhere(
            (t) => t.name == skinName,
            orElse: () => SkinTier.explorer,
          );
        }
      } catch (_) {
        // Keep default equipped skin
      }

      try {
        final frameId = state['equippedFrameId'] as String?;
        if (frameId != null) {
          equippedFrameId = frameId;
        }
      } catch (_) {
        // Keep default frame
      }

      try {
        final badges = state['equippedBadges'];
        if (badges is List) {
          equippedBadges
            ..clear()
            ..addAll(badges.whereType<String>());
        }
      } catch (_) {
        // Keep default badges
      }

      try {
        final daily = state['dailyActivityCounts'];
        if (daily is Map<String, dynamic>) {
          dailyActivityCounts
            ..clear()
            ..addAll(daily.map((k, v) => MapEntry(k, v as int)));
        }
      } catch (_) {
        // Keep default
      }

      try {
        final weekly = state['weeklyActivityCounts'];
        if (weekly is Map<String, dynamic>) {
          weeklyActivityCounts
            ..clear()
            ..addAll(weekly.map((k, v) => MapEntry(k, v as int)));
        }
      } catch (_) {
        // Keep default
      }

      try {
        final dayReset = state['lastDayReset'] as String?;
        if (dayReset != null) {
          lastDayReset = DateTime.parse(dayReset);
        }
      } catch (_) {
        // Keep default
      }

      try {
        final weekReset = state['lastWeekReset'] as String?;
        if (weekReset != null) {
          lastWeekReset = DateTime.parse(weekReset);
        }
      } catch (_) {
        // Keep default
      }
    } catch (_) {
      // Entire load failed — defaults are fine for first-time users
    }
  }

  void saveToPrefs() {
    try {
      final state = <String, dynamic>{
        'xpState': xpState.toJson(),
        'streak': streak.toJson(),
        'missions': missions.map((m) => m.toJson()).toList(),
        'weeklyMissionSet': weeklyMissionSet?.toJson(),
        'ownedSkins': ownedSkins.map(
          (tier, skin) => MapEntry(tier.name, skin.toJson()),
        ),
        'equippedSkin': equippedSkinTier.name,
        'equippedFrameId': equippedFrameId,
        'equippedBadges': equippedBadges,
        'dailyActivityCounts': dailyActivityCounts,
        'weeklyActivityCounts': weeklyActivityCounts,
        'lastDayReset': lastDayReset.toIso8601String(),
        'lastWeekReset': lastWeekReset.toIso8601String(),
      };
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_prefsKey, jsonEncode(state));
      });
    } catch (_) {
      // Silently fail — don't crash the app for persistence issues
    }
  }
}
