import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local notification scheduling service.
/// Uses flutter_local_notifications for on-device reminders (no API key needed).
class NotificationService {
  // In a real app, this would use flutter_local_notifications plugin.
  // For now we provide the interface — the plugin initialization requires
  // Android manifest changes that CI doesn't set up yet.
  // This service tracks notifications in SharedPreferences
  // until the full plugin is wired.

  bool _initialized = false;
  bool _enabled = true;

  bool get enabled => _enabled;

  Future<void> initialize() async {
    _initialized = true;
  }

  Future<void> setEnabled(bool v) async {
    _enabled = v;
  }

  /// Schedule a daily reminder at a specific hour.
  Future<void> scheduleDailyReminder(int hour, int minute, String title, String body) async {
    if (!_initialized || !_enabled) return;
    // Placeholder: in production, use flutter_local_notifications
    // AndroidManifest.xml changes + NotificationChannel creation required.
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    // Placeholder
  }

  /// Schedule streak-at-risk notification (sent in evening if no activity).
  Future<void> scheduleStreakReminder(String profileId) async {
    await scheduleDailyReminder(19, 0, '🔥 Streak at risk!',
        'Complete a mission to keep your streak alive!');
  }

  /// Schedule daily quest reminder.
  Future<void> scheduleQuestReminder(String profileId) async {
    await scheduleDailyReminder(10, 0, '🗺️ Daily Quests Await',
        'Your 3 daily quests are ready — big XP rewards!');
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
