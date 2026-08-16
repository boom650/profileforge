import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/summary/data/weekly_summary_repository.dart';
import 'package:profileforge/features/summary/domain/weekly_summary_models.dart';

final weeklySummaryRepositoryProvider = Provider<WeeklySummaryRepository>((ref) {
  return WeeklySummaryRepository(ref.watch(appDatabaseProvider));
});

/// Real weekly aggregates for a profile — ledger-backed, never fabricated.
final weeklySummaryProvider =
    FutureProvider.family<WeeklySummary, String>((ref, profileId) async {
  return ref.watch(weeklySummaryRepositoryProvider).fetch(profileId);
});