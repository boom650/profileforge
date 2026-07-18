import 'dart:math';

/// H11 — Geo-Spatial Discovery domain. Opportunity model + distance/filter
/// logic. Map rendering + Google Places lookup require an API key (TODO).
class Opportunity {
  const Opportunity({
    required this.id,
    required this.title,
    required this.category, // ngo, hackathon, competition, internship, library, museum, seminar, volunteer, lab
    required this.lat,
    required this.lng,
    required this.address,
    required this.verified,
  });

  final String id;
  final String title;
  final String category;
  final double lat;
  final double lng;
  final String address;
  final bool verified;
}

/// Pure geo helpers (Haversine). No external dependency.
class GeoEngine {
  /// Great-circle distance in km.
  double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLng = _rad(lng2 - lng1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * pow(sin(dLng / 2), 2);
    return 2 * r * asin(sqrt(a));
  }

  /// Rough travel-time estimate: assume 30 km/h average urban speed.
  int travelMinutes(double lat1, double lng1, double lat2, double lng2) {
    final km = distanceKm(lat1, lng1, lat2, lng2);
    return (km / 30 * 60).round();
  }

  List<Opportunity> withinRadius(
    List<Opportunity> all,
    double lat,
    double lng,
    double radiusKm,
  ) =>
      all.where((o) => distanceKm(lat, lng, o.lat, o.lng) <= radiusKm).toList()
        ..sort((a, b) => distanceKm(lat, lng, a.lat, a.lng)
            .compareTo(distanceKm(lat, lng, b.lat, b.lng)));

  static double _rad(double d) => d * pi / 180;
}
