import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/share/data/share_repository.dart';
import 'package:profileforge/features/share/domain/share_models.dart';

final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  return ShareRepository(ref.watch(appDatabaseProvider));
});

/// Real progress snapshot for a profile — ledger-backed, never fabricated.
final shareSnapshotProvider =
    FutureProvider.family<ShareSnapshot, String>((ref, profileId) async {
  return ref.watch(shareRepositoryProvider).snapshot(profileId);
});