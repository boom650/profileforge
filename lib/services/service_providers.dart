import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import 'gamification/gamification_service.dart';
import 'encryption_service.dart';

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
