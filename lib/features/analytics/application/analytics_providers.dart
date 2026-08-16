import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/analytics/data/analytics_repository.dart';
import 'package:profileforge/features/analytics/domain/analytics_models.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(appDatabaseProvider));
});

/// Full analytics snapshot for a profile, computed live from the DB ledger.
final analyticsSnapshotProvider = FutureProvider.family<AnalyticsSnapshot, String>((ref, profileId) async {
  return ref.watch(analyticsRepositoryProvider).snapshot(profileId);
});