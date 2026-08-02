import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/sync/application/sync_providers.dart';

/// Sync status indicator (H9). Shows pending operations and flushes on tap.
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingSyncCountProvider);
    return pending.when(
      data: (n) => Semantics(
        label: n == 0 ? 'All changes synced' : '$n changes pending sync',
        child: Chip(
          avatar: Icon(n == 0 ? Icons.cloud_done : Icons.cloud_upload),
          label: Text(n == 0 ? 'Synced' : '$n pending'),
          onDeleted: n == 0 ? null : () => ref.refresh(syncFlushProvider),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const Icon(Icons.cloud_off),
    );
  }
}
