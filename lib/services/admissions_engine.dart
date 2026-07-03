import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/gamification/admissions_pillar.dart';

enum UniversityTier { topIvy, top20, top50, top100, comprehensive }
enum DifficultyRating { easy, medium, hard, veryHard }

class AdmissionsProbability {
  final String universityName;
  final String country;
  final double currentProbability;
  final double targetProbability;
  final Map<String, double> pillarScores;
  const AdmissionsProbability({
    required this.universityName,
    required this.country,
    required this.currentProbability,
    required this.targetProbability,
    this.pillarScores = const {},
  });
}

class AdmissionsEngine {
  Future<AdmissionsProbability> calculateProbability(String profileId, String universityId) async {
    return const AdmissionsProbability(
      universityName: 'Unknown',
      country: 'Unknown',
      currentProbability: 0,
      targetProbability: 0,
    );
  }
}

final admissionsEngineProvider = Provider<AdmissionsEngine>((ref) => AdmissionsEngine());
