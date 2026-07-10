// Result/Either pattern for robust error handling in async operations
import 'package:flutter/foundation.dart';

/// Represents the result of an operation that can succeed or fail
@immutable
abstract class Result<T> {
  const Result();

  /// Whether the result is a success
  bool get isSuccess => this is Success<T>;

  /// Whether the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the success value or throw
  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Cannot get value from Failure');
  }

  /// Get the failure error or throw
  Failure<T>? get failureOrNull => isFailure ? this as Failure<T> : null;

  /// Map success value
  Result<U> map<U>(U Function(T) f) {
    if (this is Success<T>) {
      return Success(f((this as Success<T>).value));
    }
    return this as Failure<U>;
  }

  /// FlatMap for chaining operations
  Result<U> flatMap<U>(Result<U> Function(T) f) {
    if (this is Success<T>) {
      return f((this as Success<T>).value);
    }
    return this as Failure<U>;
  }

  /// Handle both cases
  U fold<U>(U Function(T) onSuccess, U Function(Failure<T>) onFailure) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure(this as Failure<T>);
  }
}

/// Successful result
@immutable
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  bool operator ==(Object other) => other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failed result
@immutable
class Failure<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  final String? userMessage;
  final bool isRetryable;

  const Failure(
    this.error, {
    this.stackTrace,
    this.userMessage,
    this.isRetryable = true,
  });

  @override
  bool operator ==(Object other) =>
      other is Failure<T> &&
      other.error == error &&
      other.stackTrace == stackTrace;

  @override
  int get hashCode => Object.hash(error, stackTrace);

  @override
  String toString() => 'Failure($error)';
}

/// Extension to easily create Results
extension ResultExtension<T> on T {
  Result<T> toSuccess() => Success(this);
}

extension FutureResultExtension<T> on Future<T> {
  Future<Result<T>> toResult() async {
    try {
      final value = await this;
      return Success(value);
    } catch (error, stackTrace) {
      return Failure<T>(error, stackTrace: stackTrace);
    }
  }
}

/// AsyncValue wrapper with built-in retry
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced AsyncValue with retry capability
class RetryableAsyncValue<T> {
  final AsyncValue<T> value;
  final void Function()? onRetry;

  const RetryableAsyncValue(this.value, {this.onRetry});

  bool get isLoading => value.isLoading;
  bool get hasError => value.hasError;
  bool get hasValue => value.hasValue;
  T? get data => value.value;
  Object? get error => value.error;
  StackTrace? get stackTrace => value.stackTrace;

  T requireValue => value.requireValue;

  Widget when({
    required Widget Function(T data) data,
    required Widget Function() loading,
    required Widget Function(Object error, StackTrace stackTrace, VoidCallback? retry) error,
  }) {
    return value.when(
      data: data,
      loading: loading,
      error: (e, st) => error(e, st, onRetry),
    );
  }
}

/// Provider helper for retryable async operations
Future<Result<T>> retryableAsync<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration delay = const Duration(seconds: 2),
  bool Function(Object)? shouldRetry,
}) async {
  int attempts = 0;
  while (true) {
    try {
      final result = await operation();
      return Success(result);
    } catch (error, stackTrace) {
      attempts++;
      if (attempts >= maxRetries || (shouldRetry != null && !shouldRetry(error))) {
        return Failure<T>(error, stackTrace: stackTrace);
      }
      await Future.delayed(delay * attempts);
    }
  }
}

/// Extension for AsyncNotifier to add retry capability
extension AsyncNotifierRetry<T> on AutoDisposeAsyncNotifier<T> {
  Future<Result<T>> runWithRetry(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
    bool Function(Object)? shouldRetry,
  }) async {
    state = const AsyncLoading();
    final result = await retryableAsync(
      operation,
      maxRetries: maxRetries,
      delay: delay,
      shouldRetry: shouldRetry,
    );
    state = result.fold(
      (value) => AsyncData(value),
      (failure) => AsyncError(failure.error, failure.stackTrace ?? StackTrace.current),
    );
    return result;
  }
}