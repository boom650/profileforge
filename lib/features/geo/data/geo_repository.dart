import 'package:profileforge/features/geo/domain/geo_engine.dart';

/// Repository boundary for H11 geo discovery. Wraps the seed opportunity set
/// and the pure GeoEngine. In production this fetches from Google Places and
/// verifies each opportunity (TODO: Places API key).
class GeoRepository {
  const GeoRepository(this._seed);

  final List<Opportunity> _seed;

  List<Opportunity> withinRadius(double lat, double lng, double radiusKm) {
    return GeoEngine().withinRadius(_seed, lat, lng, radiusKm);
  }

  int travelMinutes(double lat, double lng, double oLat, double oLng) {
    return GeoEngine().travelMinutes(lat, lng, oLat, oLng);
  }
}
