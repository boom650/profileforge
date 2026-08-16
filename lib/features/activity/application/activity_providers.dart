import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/activity/data/activity_repository.dart';
import 'package:profileforge/features/activity/domain/activity_models.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(ref.watch(appDatabaseProvider));
});

/// Real activity feed — the XP ledger, mapped to timeline entries.
final activityFeedProvider =
    FutureProvider.family<List<ActivityEntry>, String>((ref, profileId) async {
  return ref.watch(activityRepositoryProvider).history(profileId);
});