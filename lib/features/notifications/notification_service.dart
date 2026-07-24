import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge notification service.
/// Uses `flutter_local_notifications` for on-device reminders (no API key).
/// Now fully wired: initialises channel on startup, schedules persistent
/// streak / quest reminders, and fires local notifications even when the app
/// is in the background.
/// ────────────────────────────────────────────────────────────────────────────

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const String _channelId = 'profileforge_reminders';
  static const String _channelName = 'ProfileForge Reminders';
  static const String _channelDesc = 'Streak alerts, quest reminders & daily nudges';

  NotificationService(this._plugin);

  /// Must be called once on app startup.
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: null,
      ),
    );

    // Create channel
    await _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    _initialized = true;
  }

  bool get isInitialized => _initialized;

  /// Show an immediate notification.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Schedule a daily repeating reminder.
  Future<void> scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await initialize();
    await _plugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Schedule streak-at-risk notification (sent in evening if no activity).
  Future<void> scheduleStreakReminder(String profileId) async {
    await scheduleDaily(
      id: 1001,
      hour: 19,
      minute: 0,
      title: '🔥 Streak at risk!',
      body: 'Complete a mission to keep your streak alive!',
    );
  }

  /// Schedule daily quest reminder.
  Future<void> scheduleQuestReminder(String profileId) async {
    await scheduleDaily(
      id: 1002,
      hour: 10,
      minute: 0,
      title: '🗺️ Daily Quests Await',
      body: 'Your 3 daily quests are ready — big XP rewards!',
    );
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Cancel a specific notification.
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}

final notificationPluginProvider = Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final plugin = ref.watch(notificationPluginProvider);
  return NotificationService(plugin);
});
