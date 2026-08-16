/// Pure conflict-resolution + retry logic for H9 (offline-first backend sync).
class SyncEngine {
  /// Last-write-wins merge. [local] and [remote] are ISO timestamps.
  T lww<T>({required T localValue, required String localTs, required T remoteValue, required String remoteTs, required T Function() fallback}) {
    final local = DateTime.tryParse(localTs);
    final remote = DateTime.tryParse(remoteTs);
    if (local == null && remote == null) return fallback();
    if (remote == null) return localValue;
    if (local == null) return remoteValue;
    return local.isAfter(remote) ? localValue : remoteValue;
  }

  /// Exponential backoff for a given attempt count (cap 5 min).
  Duration backoff(int attempts) {
    final base = 1000 * (1 << (attempts.clamp(0, 9)));
    return Duration(milliseconds: base.clamp(1000, 300000));
  }

  /// Whether an op should be retried (max 5 attempts).
  bool shouldRetry(int attempts) => attempts < 5;
}
