import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AnalyticsService — Lightweight analytics tracking.
///
/// Tracks:
/// - Screen views
/// - Button taps
/// - Feature usage
/// - Session duration
/// - Errors
///
/// All data stored locally. Can be extended to send to remote analytics.
/// ────────────────────────────────────────────────────────────────────────────
class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance => _instance ??= AnalyticsService._();
  AnalyticsService._();

  DateTime? _sessionStart;
  final List<_AnalyticsEvent> _events = [];
  bool _enabled = true;

  /// Enable/disable analytics.
  void setEnabled(bool enabled) => _enabled = enabled;

  /// Start a new session.
  void startSession() {
    _sessionStart = DateTime.now();
    _track('session_start', {});
  }

  /// End the current session.
  void endSession() {
    if (_sessionStart != null) {
      final duration = DateTime.now().difference(_sessionStart!).inSeconds;
      _track('session_end', {'duration_seconds': duration});
    }
  }

  /// Track a screen view.
  void trackScreenView(String screenName) {
    _track('screen_view', {'screen': screenName});
  }

  /// Track a button tap.
  void trackButtonTap(String buttonName, {String? screen}) {
    _track('button_tap', {
      'button': buttonName,
      if (screen != null) 'screen': screen,
    });
  }

  /// Track a feature usage.
  void trackFeatureUsage(String featureName) {
    _track('feature_usage', {'feature': featureName});
  }

  /// Track a custom event.
  void trackEvent(String eventName, [Map<String, dynamic>? parameters]) {
    _track(eventName, parameters ?? {});
  }

  /// Track an error.
  void trackError(String error, {String? screen, String? context}) {
    _track('error', {
      'error': error,
      if (screen != null) 'screen': screen,
      if (context != null) 'context': context,
    });
  }

  /// Track AI interaction.
  void trackAIInteraction({
    required String action,
    String? model,
    int? tokens,
    Duration? latency,
  }) {
    _track('ai_interaction', {
      'action': action,
      if (model != null) 'model': model,
      if (tokens != null) 'tokens': tokens,
      if (latency != null) 'latency_ms': latency.inMilliseconds,
    });
  }

  /// Track score change.
  void trackScoreChange({
    required int oldScore,
    required int newScore,
    String? reason,
  }) {
    _track('score_change', {
      'old_score': oldScore,
      'new_score': newScore,
      'delta': newScore - oldScore,
      if (reason != null) 'reason': reason,
    });
  }

  /// Track onboarding progress.
  void trackOnboardingStep(int step, String stepName) {
    _track('onboarding_step', {
      'step': step,
      'step_name': stepName,
    });
  }

  /// Get all tracked events.
  List<_AnalyticsEvent> get events => List.unmodifiable(_events);

  /// Get events by name.
  List<_AnalyticsEvent> getEventsByName(String name) {
    return _events.where((e) => e.name == name).toList();
  }

  /// Get session duration.
  Duration? get sessionDuration {
    if (_sessionStart == null) return null;
    return DateTime.now().difference(_sessionStart!);
  }

  /// Get event count.
  int get eventCount => _events.length;

  /// Clear all events.
  void clearEvents() {
    _events.clear();
  }

  /// Export events as JSON.
  List<Map<String, dynamic>> exportEvents() {
    return _events.map((e) => e.toJson()).toList();
  }

  void _track(String name, Map<String, dynamic> parameters) {
    if (!_enabled) return;

    final event = _AnalyticsEvent(
      name: name,
      timestamp: DateTime.now(),
      parameters: parameters,
    );

    _events.add(event);

    // Debug logging
    if (kDebugMode) {
      print('[Analytics] $name: $parameters');
    }

    // Persist events periodically
    if (_events.length % 10 == 0) {
      _persistEvents();
    }
  }

  Future<void> _persistEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = exportEvents();
      // In production, save to file or send to server
    } catch (e) {
      // Silently fail
    }
  }
}

class _AnalyticsEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> parameters;

  const _AnalyticsEvent({
    required this.name,
    required this.timestamp,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'parameters': parameters,
    };
  }
}
