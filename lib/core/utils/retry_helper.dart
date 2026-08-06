import 'dart:async';
import 'dart:math';

/// ────────────────────────────────────────────────────────────────────────────
/// RetryHelper — Retry failed operations with exponential backoff.
/// ────────────────────────────────────────────────────────────────────────────
class RetryHelper {
  RetryHelper._();

  /// Retry a function with exponential backoff.
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 30),
    double backoffFactor = 2.0,
    bool Function(Object error)? retryIf,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      attempt++;
      try {
        return await operation();
      } catch (e) {
        if (attempt >= maxAttempts) rethrow;
        if (retryIf != null && !retryIf(e)) rethrow;

        // Add jitter
        final jitter = Random().nextDouble() * 0.5 + 0.75;
        final actualDelay = Duration(
          milliseconds: (delay.inMilliseconds * jitter).round(),
        );

        await Future.delayed(actualDelay);
        delay = Duration(
          milliseconds: min(
            (delay.inMilliseconds * backoffFactor).round(),
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }

  /// Retry with specific exception types.
  static Future<T> retryOn<T>(
    Future<T> Function() operation, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
    Type? exceptionType,
  }) async {
    return retry(
      operation,
      maxAttempts: maxAttempts,
      initialDelay: delay,
      retryIf: exceptionType != null
          ? (e) => e.runtimeType == exceptionType
          : null,
    );
  }

  /// Fire and forget with retry.
  static void fireAndForget(
    Future<void> Function() operation, {
    int maxAttempts = 3,
    void Function(Object error)? onError,
  }) {
    retry(operation, maxAttempts: maxAttempts).catchError((e) {
      onError?.call(e);
    });
  }
}

/// Debouncer — Debounce rapid calls.
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler — Throttle rapid calls.
class Throttler {
  Throttler({this.interval = const Duration(milliseconds: 300)});

  final Duration interval;
  DateTime? _lastCall;

  bool call() {
    final now = DateTime.now();
    if (_lastCall == null || now.difference(_lastCall!) >= interval) {
      _lastCall = now;
      return true;
    }
    return false;
  }

  void reset() {
    _lastCall = null;
  }
}

/// RateLimiter — Limit calls per time window.
class RateLimiter {
  RateLimiter({
    this.maxCalls = 10,
    this.window = const Duration(minutes: 1),
  });

  final int maxCalls;
  final Duration window;
  final List<DateTime> _calls = [];

  bool get canCall {
    _cleanup();
    return _calls.length < maxCalls;
  }

  void recordCall() {
    _calls.add(DateTime.now());
  }

  int get remainingCalls {
    _cleanup();
    return maxCalls - _calls.length;
  }

  Duration? get waitTime {
    _cleanup();
    if (_calls.length < maxCalls) return null;
    final oldest = _calls.first;
    final elapsed = DateTime.now().difference(oldest);
    return window > elapsed ? window - elapsed : Duration.zero;
  }

  void _cleanup() {
    final cutoff = DateTime.now().subtract(window);
    _calls.removeWhere((t) => t.isBefore(cutoff));
  }
}
