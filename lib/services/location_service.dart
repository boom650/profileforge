/// Free geolocation service using device GPS.
/// No API key needed — uses Flutter's geolocator package.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// Simple location result.
class UserLocation {
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;
  final String? country;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
    this.country,
  });

  UserLocation copyWith({String? city, String? state, String? country}) {
    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }

  @override
  String toString() => 'UserLocation($latitude, $longitude, $city, $state)';
}

class LocationService {
  /// Check if location services are enabled and permissions granted.
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// Get current device location (lat/lng).
  Future<UserLocation?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

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
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Current user location — auto-fetched on first access.
final userLocationProvider = FutureProvider<UserLocation?>((ref) async {
  final service = ref.read(locationServiceProvider);
  return service.getCurrentLocation();
});
