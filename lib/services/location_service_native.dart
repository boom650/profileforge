/// Native (Android/iOS) location service using geolocator package.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'location_models.dart';

class NativeLocationService implements LocationServiceBase {
  @override
  Future<UserLocation?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> requestPermission() async {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) return true;
    final req = await Geolocator.requestPermission();
    return req == LocationPermission.always || req == LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() => Geolocator.isLocationServiceEnabled();
}

LocationServiceBase createLocationService() => NativeLocationService();

final locationServiceProvider = Provider<LocationServiceBase>((ref) {
  return createLocationService();
});
