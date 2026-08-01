import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Central animation and haptic feedback service for ProfileForge
/// Provides premium micro-interactions and celebration effects
class AnimationService {
  static final AnimationService _instance = AnimationService._internal();
  factory AnimationService() => _instance;
  AnimationService._internal();

  // Haptic feedback patterns
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  // Animation duration presets (from Linear/Duolingo research)
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration crawl = Duration(milliseconds: 1000);

  // Spring curves
  static const Curve snappy = Curves.easeOutCubic;        // buttons, chips
  static const Curve gentle = Curves.easeOutExpo;         // cards, modals
  static const Curve bouncy = Curves.elasticOut;          // celebrations
  static const Curve sharp = Curves.easeInOutCubic;       // quick transitions
  static const Curve linear = Curves.linear;              // progress bars

  // Scale tokens
  static const double scaleSubtle = 0.98;   // hover
  static const double scalePress = 0.95;    // press
  static const double scalePop = 1.04;      // success/attention

  // Distance tokens
  static const double distXs = 4;
  static const double distSm = 8;
  static const double distMd = 16;
  static const double distLg = 24;
  static const double distXl = 48;

  /// Celebration hierarchy - call appropriate method for event importance
  static void celebrateTaskComplete(BuildContext context) {
    lightImpact();
    // Task complete: checkmark fill + XP float + light tap (300ms)
  }

  static void celebrateStreak(BuildContext context) {
    mediumImpact();
    // Daily streak: flame pulse + counter roll + medium tap (500ms)
  }

  static void celebrateWeeklyMilestone(BuildContext context) {
    // Weekly milestone: confetti burst + double-tap success (800ms)
    _showConfetti(context);
  }

  static void celebrateLevelUp(BuildContext context) {
    heavyImpact();
    // Level up: full-screen overlay + badge reveal + heavy + success (1200ms)
  }

  static void celebrateAchievement(BuildContext context) {
    // Achievement: particle explosion + card slide-in + triple success (1500ms)
    _showConfetti(context, particleCount: 80);
  }

  // Private confetti helper
  static void _showConfetti(BuildContext context, {int particleCount = 40}) {
    // Note: Full confetti implementation requires confetti package
    // This is a placeholder for the actual implementation
  }

  /// Staggered list animation configuration
  static const Duration staggerDelay = Duration(milliseconds: 80);
  static const Duration staggerDuration = Duration(milliseconds: 400);
  static const Curve staggerCurve = Curves.easeOutCubic;

  /// Page transition configuration
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);
  static const Curve pageTransitionCurve = Curves.easeOutCubic;

  /// Button interaction stack
  static Future<void> buttonHover(VoidCallback onHover) async {
    // Called on pointer enter - scale up slightly
    await lightImpact();
  }

  static Future<void> buttonPress() async {
    // Called on pointer down - scale down + haptic
    await mediumImpact();
  }

  static Future<void> buttonRelease() async {
    // Called on pointer up - spring back
  }

  static Future<void> buttonSuccess() async {
    // Called on success - pop animation
    await lightImpact();
  }

  /// Card interaction stack
  static Future<void> cardHover() async {
    // Translate up + shadow - no haptic
  }

  static Future<void> cardPress() async {
    // Scale down + light haptic
    await lightImpact();
  }

  static Future<void> cardExpand() async {
    // Height animation + content fade - gentle spring
  }

  /// List item entrance (stagger)
  static Widget staggerChild(int index, Widget child) {
    return child
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn(duration: staggerDuration, curve: staggerCurve)
        .slideY(begin: 0.15, duration: staggerDuration, curve: staggerCurve);
  }

  /// Toast/Notification pattern
  static const Duration toastEnterDuration = Duration(milliseconds: 300);
  static const Duration toastExitDuration = Duration(milliseconds: 200);
  static const Curve toastCurve = Curves.easeOutCubic;

  /// Scroll reveal
  static const Duration scrollRevealDuration = Duration(milliseconds: 600);
  static const Curve scrollRevealCurve = Curves.easeOutCubic;
  static const double scrollRevealOffset = 24.0;

  /// XP counter animation
  static void animateXPCounter({
    required int from,
    required int to,
    required void Function(int) onUpdate,
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOutCubic,
  }) {
    // Implementation for rolling number counter
  }

  /// Progress ring animation
  static void animateProgressRing({
    required double from,
    required double to,
    required void Function(double) onUpdate,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
  }) {
    // Implementation for circular progress
  }

  /// Flame/streak pulse animation
  static void pulseFlame(BuildContext context) {
    // Implementation for streak flame pulse
  }
}

/// Mixin for widgets that need standard animation behaviors
mixin PremiumAnimationMixin<T extends StatefulWidget> on State<T> {
  AnimationController? _pressController;
  Animation<double>? _scaleAnimation;

  void initPremiumAnimations() {
    _pressController = AnimationController(
      duration: AnimationService.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: AnimationService.scalePress)
        .animate(CurvedAnimation(parent: _pressController!, curve: AnimationService.snappy));
  }

  void onTapDown(TapDownDetails details) {
    _pressController?.forward();
    AnimationService.buttonPress();
  }

  void onTapUp(TapUpDetails details) {
    _pressController?.reverse();
    AnimationService.buttonRelease();
  }

  void onTapCancel() {
    _pressController?.reverse();
  }

  @override
  void dispose() {
    _pressController?.dispose();
    super.dispose();
  }

  Widget withPressAnimation(Widget child) {
    return AnimatedBuilder(
      animation: _scaleAnimation!,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation!.value,
        child: child,
      ),
      child: child,
    );
  }
}

/// Extension for easy staggered animations
extension StaggeredAnimation on List<Widget> {
  Widget staggered({
    Duration delay = AnimationService.staggerDelay,
    Duration duration = AnimationService.staggerDuration,
    Curve curve = AnimationService.staggerCurve,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        return widget
            .animate(delay: Duration(milliseconds: index * delay.inMilliseconds))
            .fadeIn(duration: duration, curve: curve)
            .slideY(begin: 0.15, duration: duration, curve: curve);
      }).toList(),
    );
  }
}