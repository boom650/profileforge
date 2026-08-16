import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/features/notifications/data/notification_repository.dart';
import 'package:profileforge/features/notifications/domain/notification_models.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(appDatabaseProvider));
});

/// Real notifications for a profile, recomputed whenever the underlying
/// app state (streak, XP ledger, achievements) changes.
final notificationsProvider = FutureProvider.autoDispose
    .family<List<AppNotification>, String>((ref, profileId) async {
  // Keep the list live by re-running on the same real state the screen
  // used to watch directly.
  ref.watch(streakProvider(profileId));
  ref.watch(xpHistoryProvider(profileId));
  ref.watch(unlockedAchievementIdsProvider(profileId));
  ref.watch(achievementDefsProvider);
  return ref.watch(notificationRepositoryProvider).build(profileId);
});