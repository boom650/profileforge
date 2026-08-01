import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumPageTransitions — Custom page route transitions for premium feel.
/// Each screen type has its own transition style.
/// ────────────────────────────────────────────────────────────────────────────
class PremiumPageTransitions {
  PremiumPageTransitions._();

  /// Fade + Scale — for modals, overlays, celebration screens
  static Route<T> fadeScale<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Slide + Fade — for main navigation (bottom bar screens)
  static Route<T> slideFade<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Slide from Right — for detail screens, push navigation
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.15, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Slide from Bottom — for sheets, settings, chat
  static Route<T> slideFromBottom<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Parallax — for horizontal scrolling lists (achievements, missions)
  static Route<T> parallax<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        // Background fades and slides slower
        final bgSlide = Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.6, curve: Curves.easeOut),
        ));
        // Foreground slides faster
        final fgSlide = Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 1, curve: Curves.easeOut),
        ));
        return Stack(
          children: [
            SlideTransition(
              position: bgSlide,
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0, 0.5),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Hero morph — for card-to-detail transitions (mission → detail)
  static Route<T> heroMorph<T>(Widget page, {String? tag}) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: child,
        );
      },
    );
  }
}
