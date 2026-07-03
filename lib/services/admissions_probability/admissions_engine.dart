import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdmissionsEngine {
  Future<Map<String, double>> calculateProbability(String profileId) async => {};
}

final admissionsEngineProvider = Provider((ref) => AdmissionsEngine());
