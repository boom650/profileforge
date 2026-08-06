import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Navigation — Premium navigation helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfNavigation {
  PfNavigation._();

  /// Navigate to a route.
  static void go(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }

  /// Push a route.
  static void push(BuildContext context, String route, {Object? extra}) {
    context.push(route, extra: extra);
  }

  /// Push and replace.
  static void pushReplacement(BuildContext context, String route, {Object? extra}) {
    context.pushReplacement(route, extra: extra);
  }

  /// Push and remove all routes.
  static void pushAndRemoveAll(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }

  /// Pop the current route.
  static void pop(BuildContext context) {
    context.pop();
  }

  /// Pop until a named route.
  static void popUntil(BuildContext context, String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  /// Maybe pop (handle Android back).
  static void maybePop(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  /// Check if can pop.
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// Get current route path.
  static String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Get current route name.
  static String? currentName(BuildContext context) {
    return GoRouterState.of(context).topRoute?.name;
  }

  /// Get route parameters.
  static Map<String, String> params(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }

  /// Get query parameters.
  static Map<String, String> queryParams(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }

  /// Get extra data.
  static T? extra<T>(BuildContext context) {
    return GoRouterState.of(context).extra as T?;
  }

  /// Navigate with slide transition.
  static Future<T?> pushSlide<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  /// Navigate with fade transition.
  static Future<T?> pushFade<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Navigate with scale transition.
  static Future<T?> pushScale<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Navigate with shared element transition.
  static Future<T?> pushHero<T>(
    BuildContext context, {
    required String tag,
    required Widget page,
  }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (_) => Hero(
          tag: tag,
          child: page,
        ),
      ),
    );
  }
}
