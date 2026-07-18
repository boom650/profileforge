import 'package:workmanager/workmanager.dart';

/// H9 background sync registration. Registers a periodic Workmanager task
/// that flushes the offline outbox when the OS grants a background window.
/// Entrypoint runs in a separate isolate.
@pragma('vm:entry-point')
void syncCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // TODO: resolve ProviderContainer + run syncFlushProvider.
    // For now the outbox is flushed opportunistically on connectivity restore.
    return Future.value(true);
  });
}

class BackgroundSync {
  static const _syncTask = 'profileforge_periodic_sync';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      syncCallbackDispatcher,
      isInDebugMode: false,
    );
    await Workmanager().registerPeriodicTask(
      _syncTask,
      _syncTask,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
