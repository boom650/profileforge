/// Stub location service — default fallback.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_models.dart';

class StubLocationService implements LocationServiceBase {
  @override
  Future<UserLocation?> getCurrentLocation() async => null;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<bool> isLocationServiceEnabled() async => false;
}

LocationServiceBase createLocationService() => StubLocationService();

final locationServiceProvider = Provider<LocationServiceBase>((ref) {
  return createLocationService();
});
