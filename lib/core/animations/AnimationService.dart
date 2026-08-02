import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Central animation and haptic feedback service for ProfileForge.
/// Purely static — animation controllers belong in screen widgets.
class AnimationService {
  const AnimationService._();

  // ── Haptic feedback ──
  static Future<void> lightImpact() => HapticFeedback.lightImpact();
  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();
  static Future<void> heavyImpact() => HapticFeedback.heavyImpact();
  static Future<void> selectionClick() => HapticFeedback.selectionClick();

  // ── Duration tokens (Linear/Duolingo research) ──
  static const instant = Duration(milliseconds: 80);
  static const fast = Duration(milliseconds: 180);
  static const normal = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 600);
  static const crawl = Duration(milliseconds: 1000);

  // ── Curve tokens ──
  static const snappy = Curves.easeOutCubic;
  static const gentle = Curves.easeOutExpo;
  static const bouncy = Curves.elasticOut;
  static const sharp = Curves.easeInOutCubic;
  static const linear = Curves.linear;

  // ── Scale tokens ──
  static const scaleSubtle = 0.98;
  static const scalePress = 0.95;
  static const scalePop = 1.04;

  // ── Distance tokens ──
  static const distXs = 4.0;
  static const distSm = 8.0;
  static const distMd = 16.0;
  static const distLg = 24.0;
  static const distXl = 48.0;

  // ── Stagger ──
  static const staggerDelay = Duration(milliseconds: 80);
  static const staggerDuration = Duration(milliseconds: 400);
  static const staggerCurve = Curves.easeOutCubic;

  // ── Celebration hierarchy ──
  static void celebrateTaskComplete() => lightImpact();
  static void celebrateStreak() => mediumImpact();
  static void celebrateWeeklyMilestone() => mediumImpact();
  static void celebrateLevelUp() => heavyImpact();
  static void celebrateAchievement() => heavyImpact();

  // ── Button interaction ──
  static Future<void> buttonTap() async => mediumImpact();
  static Future<void> buttonSuccess() async => lightImpact();

  // ── Card interaction ──
  static Future<void> cardTap() async => lightImpact();

  // ── Stagger helper ──
  static Widget staggerChild(int index, Widget child) {
    return child
        .animate(delay: Duration(milliseconds: index * staggerDelay.inMilliseconds))
        .fadeIn(duration: staggerDuration, curve: staggerCurve)
        .slideY(begin: 0.15, duration: staggerDuration, curve: staggerCurve);
  }
}
