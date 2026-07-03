import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceResult {
  final String placeId;
  final String name;
  final String address;
  final double rating;
  const PlaceResult({required this.placeId, required this.name, required this.address, this.rating = 0});
}

class GooglePlacesService {
  Future<List<PlaceResult>> searchPlaces(String query, {double? lat, double? lng}) async => [];
  Future<PlaceResult?> getPlaceDetails(String placeId) async => null;
}

final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref) => GooglePlacesService());
