import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/stats/data/stats_repository.dart';
import 'package:profileforge/features/stats/domain/stats_models.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(appDatabaseProvider));
});

/// Aggregate stats for a profile — real ledger numbers, never fabricated.
final statsOverviewProvider =
    FutureProvider.family<StatsOverview, String>((ref, profileId) async {
  return ref.watch(statsRepositoryProvider).overview(profileId);
});