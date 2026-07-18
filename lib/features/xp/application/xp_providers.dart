import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/xp/data/xp_repository.dart';

final xpRepositoryProvider = Provider<XpRepository>((ref) {
  return XpRepository(ref.watch(appDatabaseProvider));
});

/// Running total XP for a profile (single source of truth via XpEvents ledger).
final totalXpProvider = FutureProvider.family<int, String>((ref, profileId) async {
  return ref.watch(xpRepositoryProvider).totalXp(profileId);
});
