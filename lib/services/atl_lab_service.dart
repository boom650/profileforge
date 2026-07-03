import 'package:flutter_riverpod/flutter_riverpod.dart';

class ATLLab {
  final String id;
  final String name;
  final String city;
  final double latitude;
  final double longitude;
  const ATLLab({required this.id, required this.name, required this.city, this.latitude = 0, this.longitude = 0});
}

class ATLLabService {
  Future<List<ATLLab>> discoverLabs(double lat, double lng, {double radiusKm = 50}) async => [];
  Future<void> saveLab(String profileId, ATLLab lab) async {}
}

final atlLabServiceProvider = Provider<ATLLabService>((ref) => ATLLabService());
