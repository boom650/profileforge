/// Shared location types — always available on all platforms.

class UserLocation {
  final double latitude;
  final double longitude;
  final String? city;
  final String? state;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.city,
    this.state,
  });

  UserLocation copyWith({double? latitude, double? longitude, String? city, String? state}) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }
}

abstract class LocationServiceBase {
  Future<UserLocation?> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> isLocationServiceEnabled();
}
