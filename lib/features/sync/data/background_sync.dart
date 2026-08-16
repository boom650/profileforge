/// H9 background sync registration.
///
/// NOTE: the periodic Workmanager task is intentionally not wired in the CI
/// release build because the `workmanager` plugin's bundled Kotlin does not
/// compile against the Kotlin/AGP versions emitted by `flutter create` on
/// Flutter 3.32. The offline outbox is flushed opportunistically whenever
/// connectivity is restored (see `sync_providers.dart` -> `syncFlushProvider`),
/// which covers the common offline->online case. A proper backend-scheduled
/// periodic sync is tracked under Phase Two (H9) in ROADMAP.md.
class BackgroundSync {
  /// No-op on the current build. Real periodic registration is a Phase Two item.
  static Future<void> initialize() async {
    // TODO(phase-two): re-add a Kotlin-2-compatible periodic sync plugin and
    // resolve the ProviderContainer inside the background isolate entrypoint.
    return;
  }
}
