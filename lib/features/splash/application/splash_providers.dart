import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/splash/data/splash_repository.dart';
import 'package:profileforge/features/splash/domain/splash_models.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepository();
});

/// Real first-run status — decides where the splash screen routes.
final splashStatusProvider = FutureProvider<SplashStatus>((ref) async {
  return ref.watch(splashRepositoryProvider).currentStatus();
});