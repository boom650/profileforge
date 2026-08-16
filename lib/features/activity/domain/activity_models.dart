import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// The kind of activity a user performed. Mirrors the XP ledger sources.
enum ActivityType {
  scoreUpdate,
  aiChat,
  achievement,
  profileEdit,
  onboarding,
  system,
}

/// A single timeline entry — derived from a real XP ledger event.
class ActivityEntry {
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  const ActivityEntry({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  /// Maps an XP ledger source string to its activity type.
  static ActivityType typeForSource(String source) {
    return switch (source) {
      'mission' => ActivityType.scoreUpdate,
      'quest' => ActivityType.scoreUpdate,
      'focus' => ActivityType.aiChat,
      'login' => ActivityType.system,
      _ => ActivityType.system,
    };
  }

  /// Human title for an XP ledger source.
  static String titleForSource(String source) {
    return switch (source) {
      'mission' => 'Mission Completed',
      'quest' => 'Quest Completed',
      'focus' => 'Focus Session Ended',
      'login' => 'Daily Login',
      _ => 'XP Earned',
    };
  }

  /// Icon + color used by the timeline for a given XP ledger source.
  static ({IconData icon, Color color}) visualsForSource(String source) {
    return switch (source) {
      'mission' => (icon: Icons.task_alt, color: Palette.primary),
      'quest' => (icon: Icons.flag, color: Palette.success),
      'focus' => (icon: Icons.timer, color: Palette.info),
      'login' => (icon: Icons.login, color: Palette.textTertiary),
      _ => (icon: Icons.bolt, color: Palette.textTertiary),
    };
  }
}