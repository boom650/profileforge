import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import 'gamification/gamification_service.dart';
import 'encryption_service.dart';
import 'api_service.dart';
import '../core/connectivity/connectivity_service.dart';

// Re-export all services for easy access
export 'location_service.dart';
export 'nominatim_service.dart';
export 'overpass_service.dart';
export 'ngo_darpan_service.dart';
export 'competition_calendar_service.dart';
export 'opportunity_feed.dart';
export 'api_service.dart';

/// AppDatabase provider — initialized in main.dart via ProviderScope overrides.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'AppDatabase must be provided via ProviderScope overrides in main.dart',
  );
});

/// Singleton EncryptionService for AES-256 encryption of student PII.
final encryptionServiceProvider = FutureProvider<EncryptionService>((ref) async {
  final service = EncryptionService();
  // Await initialization to ensure keys are ready before first use
  await service.initialize();
  ref.onDispose(() => service.deleteKeys());
  return service;
});

/// Singleton GamificationService that lives for the app's lifetime.
final gamificationServiceProvider = Provider<GamificationService>((ref) {
  final service = GamificationService();
  // Auto-generate weekly missions on creation
  service.generateWeeklyMissions();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Connectivity service for monitoring network status.
/// Initialize early in app startup.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// API Service with built-in retry, connectivity check, and error propagation.
final apiServiceProvider = Provider<ApiService>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return ApiService(connectivity: connectivity);
});