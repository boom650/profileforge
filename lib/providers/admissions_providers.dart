/// Admissions probability providers: Monte Carlo engine, factor breakdown, university probabilities.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admissions_probability/admissions_engine.dart';
import 'profile_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ADMISSIONS PROBABILITY DATA
// ═══════════════════════════════════════════════════════════════════════════

@immutable
class AdmissionsProbabilityData {
  final String university;
  final String country;
  final String major;
  final double currentProbability;
  final double targetProbability;
  final List<String> keyLevers;
  final Map<String, double> sensitivity;
  final MonteCarloResult? monteCarloResult;
  final AdmissionsFactorBreakdown? factorBreakdown;

  const AdmissionsProbabilityData({
    required this.university,
    required this.country,
    required this.major,
    required this.currentProbability,
    required this.targetProbability,
    required this.keyLevers,
    required this.sensitivity,
    this.monteCarloResult,
    this.factorBreakdown,
  });
}

final admissionsProbabilityProvider = StateNotifierProvider<
    AdmissionsProbabilityNotifier, Map<String, AdmissionsProbabilityData>>((ref) {
  return AdmissionsProbabilityNotifier();
});

class AdmissionsProbabilityNotifier
    extends StateNotifier<Map<String, AdmissionsProbabilityData>> {
  AdmissionsProbabilityNotifier() : super({});

  void updateProbability(
      String universityKey, AdmissionsProbabilityData probability) {
    state = {...state, universityKey: probability};
  }

  void clearAll() {
    state = {};
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ADMISSIONS ENGINE INTEGRATION
// ═══════════════════════════════════════════════════════════════════════════

/// Provider for the admissions engine
final admissionsEngineProvider = Provider<AdmissionsEngine>((ref) {
  return AdmissionsEngine();
});

/// Provider for calculating factor breakdown from student profile
final factorBreakdownProvider = Provider<AdmissionsFactorBreakdown?>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) return null;

  final engine = ref.watch(admissionsEngineProvider);
  return engine.calculateFactorBreakdown(profile);
});

/// Provider for calculating probability for a specific university
final universityProbabilityProvider =
    FutureProvider.family<MonteCarloResult, UniversityInfo>((ref, university) async {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) {
    return const MonteCarloResult(
      mean: 0,
      median: 0,
      p25: 0,
      p75: 0,
      p10: 0,
      p90: 0,
      standardDeviation: 0,
      classification: ApplicationClassification.dream,
      safetyPercentage: 0,
      targetPercentage: 0,
      reachPercentage: 0,
      dreamPercentage: 100,
    );
  }

  final engine = ref.watch(admissionsEngineProvider);
  return engine.runMonteCarloSimulation(
    profile: profile,
    university: university,
  );
});

/// Provider for all university probabilities
final allUniversityProbabilitiesProvider =
    Provider<Map<String, ({MonteCarloResult result, UniversityInfo university})>>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) return {};

  final engine = ref.watch(admissionsEngineProvider);
  final Map<String, ({MonteCarloResult result, UniversityInfo university})>
      results = {};

  for (final university in UniversityDatabase.universities) {
    final result = engine.runMonteCarloSimulation(
      profile: profile,
      university: university,
    );
    results[university.name] = (result: result, university: university);
  }

  return results;
});

/// Provider for getting university by name
final universityByNameProvider =
    Provider.family<UniversityInfo?, String>((ref, name) {
  try {
    return UniversityDatabase.universities.firstWhere((u) => u.name == name);
  } catch (_) {
    return null;
  }
});