import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpportunityResult {
  final String id;
  final String title;
  final String description;
  const OpportunityResult({required this.id, required this.title, required this.description});
}

class OpportunityDiscoveryEngine {
  Future<List<OpportunityResult>> discover({double? latitude, double? longitude, double? radiusKm}) async => [];
}

final opportunityDiscoveryEngineProvider = Provider((ref) => OpportunityDiscoveryEngine());
