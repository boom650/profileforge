// Global error handling provider
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'result.dart';

/// Provider for capturing and reporting errors globally
final errorReporterProvider = Provider<ErrorReporter>((ref) {
  return ErrorReporter();
});

class ErrorReporter {
  void reportError(Object error, StackTrace stackTrace, {String? context}) {
    // In production, send to Sentry/Crashlytics
    debugPrint('ERROR${context != null ? ' [$context]' : ''}: $error');
    debugPrint('STACK: $stackTrace');
  }

  void reportFailure<T>(Failure<T> failure, {String? context}) {
    reportError(failure.error, failure.stackTrace ?? StackTrace.current, context: context);
  }
}

/// Provider for managing global error state
final globalErrorProvider = StateProvider<String?>((ref) => null);

/// Mixin for providers to add consistent error handling
mixin ErrorHandlingMixin<T> on Notifier<T> {
  ErrorReporter get _reporter => ref.read(errorReporterProvider);

  Future<Result<R>> safeAsync<R>(Future<R> Function() operation, {String? context}) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (error, stackTrace) {
      _reporter.reportError(error, stackTrace, context: context);
      return Failure<R>(error, stackTrace: stackTrace);
    }
  }

  void handleError(Object error, StackTrace stackTrace, {String? context}) {
    _reporter.reportError(error, stackTrace, context: context);
    // Update global error state for UI
    ref.read(globalErrorProvider.notifier).state = error.toString();
  }
}

/// StateNotifier with built-in error handling
abstract class SafeAsyncNotifier<T> extends AutoDisposeAsyncNotifier<T> {
  ErrorReporter get _reporter => ref.read(errorReporterProvider);

  @override
  FutureOr<T> build() {
    // Override in subclasses
    throw UnimplementedError();
  }

  Future<Result<T>> safeAsync(Future<T> Function() operation, {String? context}) async {
    state = const AsyncLoading();
    try {
      final result = await operation();
      state = AsyncData(result);
      return Success(result);
    } catch (error, stackTrace) {
      _reporter.reportError(error, stackTrace, context: context);
      final failure = Failure<T>(error, stackTrace: stackTrace);
      state = AsyncError(failure.error, failure.stackTrace ?? StackTrace.current);
      return failure;
    }
  }
}