import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Animation Constants — Reusable animation presets.
/// ────────────────────────────────────────────────────────────────────────────
class PfAnimations {
  PfAnimations._();

  // ════════════════════════════════════════════════════════════════════════════
  // DURATIONS
  // ════════════════════════════════════════════════════════════════════════════

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
  static const Duration snappy = Duration(milliseconds: 150);

  // ════════════════════════════════════════════════════════════════════════════
  // CURVES
  // ════════════════════════════════════════════════════════════════════════════

  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutQuart = Curves.easeOutQuart;
  static const Curve easeOutExpo = Curves.easeOutExpo;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve spring = Curves.elasticOut;

  // ════════════════════════════════════════════════════════════════════════════
  // COMMON ANIMATIONS
  // ════════════════════════════════════════════════════════════════════════════

  /// Fade in animation.
  static Animation<double> fadeIn(
    AnimationController controller, {
    Curve curve = easeOutCubic,
  }) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Fade out animation.
  static Animation<double> fadeOut(
    AnimationController controller, {
    Curve curve = easeOutCubic,
  }) {
    return Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide up animation.
  static Animation<Offset> slideUp(
    AnimationController controller, {
    double beginY = 0.3,
    Curve curve = easeOutCubic,
  }) {
    return Tween<Offset>(
      begin: Offset(0, beginY),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }

  /// Slide down animation.
  static Animation<Offset> slideDown(
    AnimationController controller, {
    double beginY = -0.3,
    Curve curve = easeOutCubic,
  }) {
    return Tween<Offset>(
      begin: Offset(0, beginY),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }

  /// Slide left animation.
  static Animation<Offset> slideLeft(
    AnimationController controller, {
    double beginX = 0.3,
    Curve curve = easeOutCubic,
  }) {
    return Tween<Offset>(
      begin: Offset(beginX, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }

  /// Slide right animation.
  static Animation<Offset> slideRight(
    AnimationController controller, {
    double beginX = -0.3,
    Curve curve = easeOutCubic,
  }) {
    return Tween<Offset>(
      begin: Offset(beginX, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));
  }

  /// Scale animation.
  static Animation<double> scale(
    AnimationController controller, {
    double begin = 0.8,
    Curve curve = easeOutCubic,
  }) {
    return Tween<double>(begin: begin, end: 1).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Rotation animation.
  static Animation<double> rotation(
    AnimationController controller, {
    double begin = 0,
    double end = 1,
    Curve curve = easeOutCubic,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Size animation.
  static Animation<double> size(
    AnimationController controller, {
    double begin = 0,
    double end = 1,
    Curve curve = easeOutCubic,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PRESETS
  // ════════════════════════════════════════════════════════════════════════════

  /// Stagger delay for list items.
  static Duration staggerDelay(int index, {int total = 10}) {
    final delay = (index * 50).clamp(0, 500);
    return Duration(milliseconds: delay);
  }

  /// Get scale transform for stagger animation.
  static double staggerScale(int index, {double base = 0.95}) {
    return base + (0.05 * (1 - index / 10).clamp(0, 1));
  }
}
