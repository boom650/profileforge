import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// HapticFeedbackPatterns — Standardized haptic feedback for ProfileForge.
///
/// Based on research:
/// - 12-uiux-animation-motion-design.md (micro-interactions)
/// - 12-uiux-gamification-engagement.md (reward feedback)
/// ────────────────────────────────────────────────────────────────────────────

enum HapticPattern {
  /// Light tap — navigation, selection
  light,

  /// Medium impact — button press, confirmation
  medium,

  /// Heavy impact — achievement, celebration
  heavy,

  /// Selection click — toggle, switch
  selection,

  /// Success — score increase, completion
  success,

  /// Error — validation failure, error state
  error,

  /// Warning — caution, important notice
  warning,

  /// Achievement unlocked — badge, milestone
  achievement,

  /// Streak — daily streak maintained
  streak,

  /// Level up — level progression
  levelUp,
}

class HapticService {
  static HapticService? _instance;
  static HapticService get instance => _instance ??= HapticService._();
  HapticService._();

  bool _enabled = true;

  /// Initialize haptic service and load preferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('pf_haptics_enabled') ?? true;
  }

  /// Enable or disable haptic feedback.
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_haptics_enabled', enabled);
  }

  /// Check if haptic feedback is enabled.
  bool get isEnabled => _enabled;

  /// Trigger haptic feedback pattern.
  void trigger(HapticPattern pattern) {
    if (!_enabled) return;

    switch (pattern) {
      case HapticPattern.light:
        _light();
        break;
      case HapticPattern.medium:
        _medium();
        break;
      case HapticPattern.heavy:
        _heavy();
        break;
      case HapticPattern.selection:
        _selection();
        break;
      case HapticPattern.success:
        _success();
        break;
      case HapticPattern.error:
        _error();
        break;
      case HapticPattern.warning:
        _warning();
        break;
      case HapticPattern.achievement:
        _achievement();
        break;
      case HapticPattern.streak:
        _streak();
        break;
      case HapticPattern.levelUp:
        _levelUp();
        break;
    }
  }

  /// Light tap for navigation and selection.
  void _light() {
    HapticFeedback.lightImpact();
  }

  /// Medium impact for button press and confirmation.
  void _medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy impact for achievement and celebration.
  void _heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Selection click for toggle and switch.
  void _selection() {
    HapticFeedback.selectionClick();
  }

  /// Success pattern — quick double tap.
  void _success() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Error pattern — triple quick tap.
  void _error() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 80), () {
      HapticFeedback.heavyImpact();
    });
    Future.delayed(const Duration(milliseconds: 160), () {
      HapticFeedback.heavyImpact();
    });
  }

  /// Warning pattern — two medium taps with delay.
  void _warning() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Achievement pattern — light, medium, heavy sequence.
  void _achievement() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 80), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 160), () {
      HapticFeedback.heavyImpact();
    });
  }

  /// Streak pattern — three ascending taps.
  void _streak() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.heavyImpact();
    });
  }

  /// Level up pattern — crescendo of five taps.
  void _levelUp() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 60), () {
      HapticFeedback.lightImpact();
    });
    Future.delayed(const Duration(milliseconds: 120), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 180), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 240), () {
      HapticFeedback.heavyImpact();
    });
  }

  // ── Convenience Methods ──

  /// Navigation tap.
  void tap() => trigger(HapticPattern.light);

  /// Button press.
  void press() => trigger(HapticPattern.medium);

  /// Toggle switch.
  void toggle() => trigger(HapticPattern.selection);

  /// Score increase.
  void scoreIncrease() => trigger(HapticPattern.success);

  /// Score decrease.
  void scoreDecrease() => trigger(HapticPattern.error);

  /// Achievement unlocked.
  void achievement() => trigger(HapticPattern.achievement);

  /// Daily streak maintained.
  void streak() => trigger(HapticPattern.streak);

  /// Level up.
  void levelUp() => trigger(HapticPattern.levelUp);

  /// Form validation error.
  void validationError() => trigger(HapticPattern.error);

  /// Important warning.
  void warning() => trigger(HapticPattern.warning);

  /// Celebration.
  void celebrate() => trigger(HapticPattern.heavy);
}
