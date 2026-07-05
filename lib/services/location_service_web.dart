/// Web location service — returns null (user can search by city instead).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_models.dart';

class WebLocationService implements LocationServiceBase {
  @override
  Future<UserLocation?> getCurrentLocation() async => null;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<bool> isLocationServiceEnabled() async => false;
}

LocationServiceBase createLocationService() => WebLocationService();

final locationServiceProvider = Provider<LocationServiceBase>((ref) {
  return createLocationService();
});
