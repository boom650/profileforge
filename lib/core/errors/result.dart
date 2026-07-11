/// Result/Either pattern for robust error handling in async operations.
///
/// Pure Dart — no flutter or riverpod imports so codegen builders
/// (drift_dev, freezed, riverpod_generator) can parse it without errors.

/// Successful result
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

/// Represents the result of an operation that can succeed or fail
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
