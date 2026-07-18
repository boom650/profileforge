import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/geo/domain/geo_engine.dart';

final geoEngineProvider = Provider<GeoEngine>((ref) => GeoEngine());

/// Seed opportunities (in production fetched via Google Places + verification).
/// TODO: replace with live Places API when key is configured.
final opportunitiesProvider = Provider<List<Opportunity>>((ref) => [
  const Opportunity(
    id: 'o1',
    title: 'City Library Study Hall',
    category: 'library',
    lat: 1.3521,
    lng: 103.8198,
    address: '100 Victoria St',
    verified: true,
  ),
  const Opportunity(
    id: 'o2',
    title: 'Youth Hackathon 2026',
    category: 'hackathon',
    lat: 1.3099,
    lng: 103.7738,
    address: 'NUS UTown',
    verified: true,
  ),
  const Opportunity(
    id: 'o3',
    title: 'Local NGO Tutoring',
    category: 'volunteer',
    lat: 1.3331,
    lng: 103.8500,
    address: 'Toa Payoh',
    verified: false,
  ),
  const Opportunity(
    id: 'o4',
    title: 'Science Centre Seminar',
    category: 'seminar',
    lat: 1.3770,
    lng: 103.7360,
    address: 'Jurong East',
    verified: true,
  ),
]);

/// Opportunities within [radiusKm] of [lat,lng], nearest first.
final nearbyOpportunitiesProvider =
    Provider.family<List<Opportunity>, ({double lat, double lng, double radiusKm})>(
        (ref, args) {
  final engine = ref.watch(geoEngineProvider);
  return engine.withinRadius(
      ref.watch(opportunitiesProvider), args.lat, args.lng, args.radiusKm);
});
