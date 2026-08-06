import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profileforge/core/analytics/analytics_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Error Handler — Centralized error handling.
/// ────────────────────────────────────────────────────────────────────────────
class PfErrorHandler {
  PfErrorHandler._();

  static void init() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError('FlutterError', details.exception, details.stack);
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError('PlatformDispatcher', error, stack);
      return true;
    };
  }

  static void _logError(String source, Object error, StackTrace? stack) {
    if (kDebugMode) {
      print('[$source] $error');
      if (stack != null) print('Stack: $stack');
    }

    // Track in analytics
    AnalyticsService.instance.trackError(
      error.toString(),
      context: source,
    );
  }

  /// Wrap a function with error handling.
  static Future<T?> safeCall<T>(
    Future<T> Function() call, {
    String? context,
    T? fallback,
    void Function(Object error)? onError,
  }) async {
    try {
      return await call();
    } catch (e, stack) {
      _logError(context ?? 'safeCall', e, stack);
      onError?.call(e);
      return fallback;
    }
  }

  /// Wrap a synchronous function with error handling.
  static T? safeSync<T>(
    T Function() call, {
    String? context,
    T? fallback,
    void Function(Object error)? onError,
  }) {
    try {
      return call();
    } catch (e, stack) {
      _logError(context ?? 'safeSync', e, stack);
      onError?.call(e);
      return fallback;
    }
  }

  /// Get user-friendly error message.
  static String getUserMessage(Object error) {
    if (error is FormatException) {
      return 'Invalid format. Please check your input.';
    }
    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }
    if (error is ArgumentError) {
      return 'Invalid argument. Please check your input.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Check if error is network-related.
  static bool isNetworkError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('socket') ||
        message.contains('connection') ||
        message.contains('network') ||
        message.contains('timeout') ||
        message.contains('internet');
  }

  /// Check if error is auth-related.
  static bool isAuthError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('unauthorized') ||
        message.contains('authentication') ||
        message.contains('token') ||
        message.contains('401');
  }

  /// Check if error is rate limit.
  static bool isRateLimitError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('rate limit') ||
        message.contains('429') ||
        message.contains('too many');
  }
}
