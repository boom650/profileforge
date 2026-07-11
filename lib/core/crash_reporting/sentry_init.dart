// Sentry crash reporting initialization — STUB
// Uncomment Sentry.init() when a valid DSN is available in the environment.

import 'package:flutter/foundation.dart';

// ignore: avoid_importing_packages_not_in_dependencies
// import 'package:sentry_flutter/sentry_flutter.dart';

/// Initialize Sentry crash reporting.
/// Currently a no-op — uncomment the Sentry.init call and add the
/// sentry_flutter dependency to pubspec.yaml when a DSN is available.
Future<void> initCrashReporting() async {
  if (!kReleaseMode) {
    // In debug mode, just log to console
    debugPrint('[Sentry] Crash reporting disabled in debug mode');
    return;
  }

  // TODO: Add sentry_flutter to pubspec.yaml and uncomment below when DSN is available.
  // await SentryFlutter.init(
  //   options: Options(
  //     dsn: const String.fromEnvironment('SENTRY_DSN'),
  //     // Only send events in release mode
  //     environment: const String.fromEnvironment('ENVIRONMENT', defaultValue: 'production'),
  //     // Sample rate for performance monitoring (0.0 to 1.0)
  //     tracesSampleRate: 0.2,
  //     // Capture 100% of crashes
  //     // ignoreErrors: [NullPointerException], // Ignore certain errors if needed
  //     beforeSend: (event, hint) {
  //       // Add custom context before sending
  //       event.contexts['app'] = {'build_number': '1.0.0+1'};
  //       return event;
  //     },
  //   ),
  //   appRunner: () => runApp(const MyApp()), // App will be wrapped by main.dart
  // );
  debugPrint('[Sentry] Initialization stub — add SENTRY_DSN env var to enable');
}

/// Report an error to Sentry (no-op stub).
void reportError(Object error, [StackTrace? stackTrace]) {
  debugPrint('[Sentry] Error captured: $error');
  if (stackTrace != null) {
    debugPrint('[Sentry] Stack trace: $stackTrace');
  }

  // TODO: Uncomment when Sentry is initialized
  // if (kReleaseMode) {
  //   Sentry.captureException(error, stackTrace: stackTrace);
  // }
}

/// Add breadcrumb for debugging (no-op stub).
void addBreadcrumb(String message, {Map<String, dynamic>? data}) {
  debugPrint('[Sentry] Breadcrumb: $message ${data ?? ''}');

  // TODO: Uncomment when Sentry is initialized
  // Sentry.addBreadcrumb(Breadcrumb(message: message, data: data));
}