/// Free reverse geocoding using OpenStreetMap Nominatim.
/// No API key needed. Rate limit: 1 request/second (respect this).
/// Usage policy: https://operations.osmfoundation.org/policies/nominatim/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NominatimResult {
  final String? city;
  final String? state;
  final String? country;
  final String? displayName;

  const NominatimResult({this.city, this.state, this.country, this.displayName});
}

class NominatimService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org';
  static const _userAgent = 'ProfileForge/1.0 (student-profile-app)';

  /// Reverse geocode: lat/lng → city, state, country.
  Future<NominatimResult?> reverse(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/reverse?lat=$lat&lon=$lng&format=json&addressdetails=1',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': _userAgent,
        'Accept': 'application/json',
      });

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final address = data['address'] as Map<String, dynamic>? ?? {};

      // Extract city (try multiple keys — OSM uses different ones)
      String? city = address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'] ??
          address['county'];

      String? state = address['state'];
      String? country = address['country'];
      String? displayName = data['display_name'];

      return NominatimResult(
        city: city,
        state: state,
        country: country,
        displayName: displayName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Forward geocode: city name → lat/lng (for searching NGOs in a city).
  Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': _userAgent,
        'Accept': 'application/json',
      });

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List;
      return data.map((e) => {
        'lat': double.tryParse(e['lat']?.toString() ?? '') ?? 0,
        'lon': double.tryParse(e['lon']?.toString() ?? '') ?? 0,
        'display_name': e['display_name'] ?? '',
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

final nominatimServiceProvider = Provider<NominatimService>((ref) {
  return NominatimService();
});
