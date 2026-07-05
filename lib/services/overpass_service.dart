/// Free nearby place discovery using OpenStreetMap Overpass API.
/// No API key needed. Finds ATL Labs, makerspaces, libraries, community centers.
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NearbyPlace {
  final String id;
  final String name;
  final String type; // 'library', 'school', 'community_center', 'makerspace'
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String? address;

  const NearbyPlace({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.distanceKm = 0,
    this.address,
  });
}

class OverpassService {
  static const _baseUrl = 'https://overpass-api.de/api/interpreter';

  /// Find nearby places within radiusKm.
  Future<List<NearbyPlace>> findNearby(
    double lat,
    double lng, {
    double radiusKm = 25,
    List<String> types = const ['library', 'school', 'community_centre'],
  }) async {
    try {
      final radiusM = (radiusKm * 1000).toInt();
      final tags = types.map((t) => '["amenity"="$t"]').join('');
      final query = '''
[out:json][timeout:15];
(
  node$tags(around:$radiusM,$lat,$lng);
  way$tags(around:$radiusM,$lat,$lng);
);
out center tags;
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {'data': query},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final elements = data['elements'] as List? ?? [];

      List<NearbyPlace> places = [];
      for (final el in elements) {
        final tags = el['tags'] as Map<String, dynamic>? ?? {};
        final name = tags['name'] as String?;
        if (name == null || name.isEmpty) continue;

        double elLat = (el['lat'] ?? el['center']?['lat'] ?? 0).toDouble();
        double elLng = (el['lon'] ?? el['center']?['lon'] ?? 0).toDouble();
        double dist = _haversine(lat, lng, elLat, elLng);

        String type = 'place';
        String? amenity = tags['amenity'];
        if (amenity == 'library') type = 'library';
        else if (amenity == 'school') type = 'school';
        else if (amenity == 'community_centre') type = 'community_center';
        else if (amenity == 'makerspace') type = 'makerspace';

        String? addr = [tags['addr:street'], tags['addr:city']]
            .where((s) => s != null && s.toString().isNotEmpty)
            .join(', ');

        places.add(NearbyPlace(
          id: '${el['type']}_${el['id']}',
          name: name,
          type: type,
          latitude: elLat,
          longitude: elLng,
          distanceKm: double.parse(dist.toStringAsFixed(1)),
          address: addr.isNotEmpty ? addr : null,
        ));
      }

      places.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      return places;
    } catch (e) {
      return [];
    }
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return R * 2 * math.asin(math.sqrt(a));
  }

  double _deg2rad(double deg) => deg * math.pi / 180;
}

final overpassServiceProvider = Provider<OverpassService>((ref) {
  return OverpassService();
});
