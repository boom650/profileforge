import 'package:flutter/services.dart';
import 'package:profileforge/core/audio/sound_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// HapticFeedbackService — Centralized haptic choreography for premium UX.
/// Different vibration patterns for different interaction types.
/// Every tap, swipe, and gesture has a unique physical signature.
/// ────────────────────────────────────────────────────────────────────────────
class HapticService {
  HapticService._();
  static final instance = HapticService._();

  // ── Selection Feedback ──
  /// Light tap — chip selection, toggle, radio button
  void select() {
    HapticFeedback.lightImpact();
    SoundService.instance.tap();
  }

  /// Medium tap — card tap, button press
  void tap() {
    HapticFeedback.mediumImpact();
    SoundService.instance.tap();
  }

  /// Heavy tap — confirm, complete, submit
  void confirm() {
    HapticFeedback.heavyImpact();
    SoundService.instance.success();
  }

  /// Success — mission complete, achievement unlock, level up
  void success() {
    HapticFeedback.heavyImpact();
    SoundService.instance.success();
    // Double pulse for extra satisfaction
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Error — wrong action, validation fail
  void error() {
    HapticFeedback.heavyImpact();
    SoundService.instance.error();
  }

  /// Warning — destructive action, streak about to break
  void warning() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 50), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.heavyImpact();
    });
  }

  // ── Navigation Feedback ──
  /// Page forward — swipe to next page, tap next
  void pageForward() {
    HapticFeedback.mediumImpact();
  }

  /// Page back — swipe to previous page, tap back
  void pageBack() {
    HapticFeedback.lightImpact();
  }

  // ── Scroll Feedback ──
  /// Scroll tick — every N items in a list
  void scrollTick() {
    HapticFeedback.selectionClick();
  }

  /// Scroll end — reached bottom/end of list
  void scrollEnd() {
    HapticFeedback.mediumImpact();
  }

  // ── Gesture Feedback ──
  /// Long press — context menu, drag start
  void longPress() {
    HapticFeedback.heavyImpact();
  }

  /// Drag start — begin reordering items
  void dragStart() {
    HapticFeedback.mediumImpact();
  }

  /// Drag end — drop item in new position
  void dragEnd() {
    HapticFeedback.mediumImpact();
  }

  // ── Achievement Feedback ──
  /// Achievement unlock — full celebration sequence
  void achievementUnlock() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.heavyImpact();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Level up — ascending vibration pattern
  void levelUp() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.heavyImpact();
    });
  }

  /// Streak fire — quick double pulse
  void streakFire() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 80), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Timer tick — subtle pulse every second (for countdown)
  void timerTick() {
    HapticFeedback.selectionClick();
  }

  /// Timer complete — satisfying completion burst
  void timerComplete() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.lightImpact();
    });
  }
}
