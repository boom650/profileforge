import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/sync/data/sync_repository.dart';
import 'package:profileforge/features/sync/domain/sync_engine.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(ref.watch(appDatabaseProvider));
});

final syncEngineProvider = Provider<SyncEngine>((ref) => SyncEngine());

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Flushes the outbox when online. In production this POSTs to the REST
/// backend and applies conflict resolution; here it models the retry loop.
final syncFlushProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(syncRepositoryProvider);
  final engine = ref.watch(syncEngineProvider);
  final online = await Connectivity().checkConnectivity();
  if (online.contains(ConnectivityResult.none)) return;
  final pending = await repo.pending();
  for (final op in pending) {
    // TODO: send op.payload to backend via REST/WebSocket.
    if (engine.shouldRetry(op.attempts)) {
      await repo.markDone(op.id); // simulate success
    } else {
      await repo.bumpAttempts(op.id);
    }
  }
});

/// Live count of unsynced operations (for a badge).
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  return (await ref.watch(syncRepositoryProvider).pending()).length;
});
