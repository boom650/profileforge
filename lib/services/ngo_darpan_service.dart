import 'package:flutter_riverpod/flutter_riverpod.dart';

class NGO {
  final String id;
  final String name;
  final String city;
  final String state;
  final String focus;
  const NGO({required this.id, required this.name, required this.city, required this.state, required this.focus});
}

class NGODarpanService {
  Future<List<NGO>> searchNGOs(String city) async => [];
  Future<void> saveNGO(String profileId, NGO ngo) async {}
}

final ngoDarpanServiceProvider = Provider<NGODarpanService>((ref) => NGODarpanService());
