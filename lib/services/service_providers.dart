
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gamification/gamification_service.dart';
import 'location_service.dart';

// Service providers are singletons that provide access to services.
// They are used to decouple services from the UI.

// This provider creates a singleton instance of the GamificationService.
final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService();
});

// Resolves whether location permission has been granted.
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.requestPermission();
});
