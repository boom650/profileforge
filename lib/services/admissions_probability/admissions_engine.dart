import 'dart:math';
import 'dart:async';

import '../models/student_profile.dart';
import '../models/gamification/skins.dart';
import '../models/opportunity/ngo_opportunity.dart';
import '../models/opportunity/competition.dart';
import '../models/opportunity/place_opportunity.dart';

/// Admissions Probability Engine with Monte Carlo Simulation
/// Implements university-specific models for US, UK, Canada, Australia, Europe
class AdmissionsProbabilityEngine {
  static const int MONTE_CARLO_RUNS = 10000;
  
  final Random _random = Random();
  
  /// Calculate admission probability for a student targeting specific universities
  Future<AdmissionsProbabilityResult> calculateProbability({
    required StudentProfile student,
    required List<TargetUniversity> universities,
    required List<Activity> activities,
  }) async {
    final results = <UniversityProbability>[];
    
    for (final university in universities) {
      final probability = await _calculateUniversityProbability(
        student: student,
        university: university,
        activities: activities,
      );
      results.add(probability);
    }
    
    return AdmissionsProbabilityResult(
      universityProbabilities: results,
      overallProfileStrength: _calculateOverallStrength(student, activities),
      keyLevers: _identifyKeyLevers(student, activities),
      trajectoryProjection: _projectTrajectory(student, activities),
      generatedAt: DateTime.now(),
    );
  }
  
  /// Monte Carlo simulation for a single university
  Future<UniversityProbability> _calculateUniversityProbability({
    required StudentProfile student,
    required TargetUniversity university,
    required List<Activity> activities,
  }) async {
    final config = _getUniversityConfig(university);
    int accepted = 0;
    
    for (int i = 0; i < MONTE_CARLO_RUNS; i++) {
      final score = _simulateApplicantScore(student, activities, config);
      if (score >= config.cutoffScore) {
        accepted++;
      }
    }
    
    final probability = accepted / MONTE_CARLO_RUNS;
    final sensitivity = _calculateSensitivity(student, activities, config);
    final levers = _identifyUniversityLevers(student, activities, config);
    
    return UniversityProbability(
      university: university,
      probability: probability,
      confidenceInterval: _calculateConfidenceInterval(probability),
      sensitivity: sensitivity,
      keyLevers: levers,
      componentScores: _getComponentScores(student, activities, config),
    );
  }
  
  double _simulateApplicantScore(
    StudentProfile student,
    List<Activity> activities,
    UniversityConfig config,
  ) {
    double score = 0;
    
    // Academic component (0-40 points)
    score += _simulateAcademicScore(student, config) * config.academicWeight;
    
    // Activities component (0-30 points)
    score += _simulateActivityScore(activities, config) * config.activityWeight;
    
    // Essays/Personal component (0-20 points)
    score += _simulateEssayScore(student, config) * config.essayWeight;
    
    // Recommendations component (0-10 points)
    score += _simulateRecommendationScore(student, config) * config.recommendationWeight;
    
    // Add noise for Monte Carlo variation
    score += _random.nextGaussian() * config.noiseFactor;
    
    return score.clamp(0, 100);
  }
  
  double _simulateAcademicScore(StudentProfile student, UniversityConfig config) {
    double score = 0;
    
    // 10th grade percentage (normalized)
    score += (student.tenthPercentage / 100) * 15;
    
    // 11th grade subjects average
    if (student.subjects.isNotEmpty) {
      final avg = student.subjects.values.reduce((a, b) => a + b) / student.subjects.length;
      score += (avg / 100) * 15;
    }
    
    // Standardized tests
    if (student.satScore != null) {
      score += (student.satScore! / 1600) * 10;
    }
    if (student.ieltsScore != null) {
      score += (student.ieltsScore! / 9) * 10;
    }
    
    // Board difficulty adjustment
    score *= _getBoardMultiplier(student.board);
    
    return score.clamp(0, 40);
  }
  
  double _simulateActivityScore(List<Activity> activities, UniversityConfig config) {
    double score = 0;
    
    for (final activity in activities) {
      final tierWeight = _getTierWeight(activity.tier);
      final hoursFactor = min(activity.hoursPerWeek * activity.weeksPerYear / 100, 1.0);
      final categoryWeight = _getCategoryWeight(activity.category, config);
      
      score += tierWeight * hoursFactor * categoryWeight * 5;
    }
    
    return score.clamp(0, 30);
  }
  
  double _simulateEssayScore(StudentProfile student, UniversityConfig config) {
    // Simulate based on profile coherence and narrative strength
    double base = 10;
    
    // Stronger profile = better essays (more material)
    final activityCount = activities.length;
    if (activityCount >= 5) base += 5;
    if (activityCount >= 8) base += 3;
    
    // Tier 1 activities provide compelling narratives
    final tier1Count = activities.where((a) => a.tier == ActivityTier.tier1).length;
    base += tier1Count * 2;
    
    return (base + _random.nextDouble() * 5).clamp(0, 20);
  }
  
  double _simulateRecommendationScore(StudentProfile student, UniversityConfig config) {
    // Based on teacher relationships and leadership
    double score = 5;
    
    final leadershipActivities = activities.where((a) => a.category == ActivityCategory.leadership).length;
    score += leadershipActivities * 1.5;
    
    final teacherVerified = activities.where((a) => a.teacherVerification != null).length;
    score += teacherVerified * 1;
    
    return (score + _random.nextDouble() * 2).clamp(0, 10);
  }
  
  Map<String, double> _calculateSensitivity(
    StudentProfile student,
    List<Activity> activities,
    UniversityConfig config,
  ) {
    final sensitivities = <String, double>{};
    
    // Test impact of improving each component
    final baseScore = _simulateApplicantScore(student, activities, config);
    
    // Academic sensitivity
    final academicBoost = student.copyWith(
      subjects: Map.from(student.subjects)..updateAll((k, v) => min(v + 5, 100)),
    );
    sensitivities['academic_improvement'] = 
      (_simulateApplicantScore(academicBoost, activities, config) - baseScore) / 5;
    
    // Activity sensitivity
    final extraActivity = activities + [
      Activity(
        id: 'extra',
        title: 'New Leadership Role',
        category: ActivityCategory.leadership,
        tier: ActivityTier.tier2,
        description: '',
        hoursPerWeek: 3,
        weeksPerYear: 30,
        startDate: DateTime.now(),
        endDate: null,
        evidence: null,
        teacherVerification: null,
        skills: [],
        narrativeAngle: '',
        admissionsValue: 750,
        isInSchool: true,
        location: 'School',
      ),
    ];
    sensitivities['new_tier2_activity'] = 
      _simulateApplicantScore(student, extraActivity, config) - baseScore;
    
    // Test score sensitivity
    if (student.satScore != null && student.satScore! < 1550) {
      final satBoost = student.copyWith(satScore: student.satScore! + 50);
      sensitivities['sat_50_points'] = 
        (_simulateApplicantScore(satBoost, activities, config) - baseScore) / 50 * 100;
    }
    
    return sensitivities;
  }
  
  List<String> _identifyUniversityLevers(
    StudentProfile student,
    List<Activity> activities,
    UniversityConfig config,
  ) {
    final levers = <String>[];
    
    // Check academic gaps
    if (student.tenthPercentage < 90) {
      levers.add('Improve 10th grade equivalent scores');
    }
    if (student.subjects.values.any((v) => v < 85)) {
      levers.add('Strengthen weak academic subjects');
    }
    if (student.satScore == null || student.satScore! < 1450) {
      levers.add('Take/retake SAT to reach 1450+');
    }
    if (student.ieltsScore == null || student.ieltsScore! < 7.0) {
      levers.add('Achieve IELTS 7.0+');
    }
    
    // Check activity gaps
    final tier1Count = activities.where((a) => a.tier == ActivityTier.tier1).length;
    if (tier1Count == 0) {
      levers.add('Pursue Tier 1 activity (national/international recognition)');
    }
    if (tier1Count < 2) {
      levers.add('Develop second Tier 1 spike');
    }
    
    final leadershipCount = activities.where((a) => a.category == ActivityCategory.leadership).length;
    if (leadershipCount == 0) {
      levers.add('Assume leadership role in school/club');
    }
    
    final researchCount = activities.where((a) => a.category == ActivityCategory.research).length;
    if (researchCount == 0 && config.valuesResearch) {
      levers.add('Complete mentored research project');
    }
    
    // Check evidence gaps
    final unverifiedCount = activities.where((a) => a.teacherVerification == null).length;
    if (unverifiedCount > 0) {
      levers.add('Get teacher verification for $unverifiedCount activities');
    }
    
    return levers;
  }
  
  List<String> _identifyKeyLevers(StudentProfile student, List<Activity> activities) {
    final allLevers = <String>[];
    for (final uni in student.reachUniversities + student.matchUniversities + student.safetyUniversities) {
      final config = _getUniversityConfig(TargetUniversity(
        name: uni,
        country: student.targetCountries.first,
        major: student.targetMajor,
        tier: student.reachUniversities.contains(uni) ? 'reach' : 'match',
      ));
      allLevers.addAll(_identifyUniversityLevers(student, activities, config));
    }
    // Deduplicate and return top 5
    return allLevers.toSet().take(5).toList();
  }
  
  double _calculateOverallStrength(StudentProfile student, List<Activity> activities) {
    double strength = 0;
    strength += (student.tenthPercentage / 100) * 25;
    if (student.subjects.isNotEmpty) {
      final avg = student.subjects.values.reduce((a, b) => a + b) / student.subjects.length;
      strength += (avg / 100) * 25;
    }
    strength += min(activities.length / 10 * 20, 20);
    strength += activities.where((a) => a.tier == ActivityTier.tier1).length * 5;
    strength += activities.where((a) => a.tier == ActivityTier.tier2).length * 3;
    return strength.clamp(0, 100);
  }
  
  Map<String, double> _projectTrajectory(StudentProfile student, List<Activity> activities) {
    // Project 6-month trajectory based on current velocity
    return {
      'current': _calculateOverallStrength(student, activities),
      '3_months': _calculateOverallStrength(student, activities) + 8,
      '6_months': _calculateOverallStrength(student, activities) + 15,
      '12_months': _calculateOverallStrength(student, activities) + 25,
    };
  }
  
  UniversityConfig _getUniversityConfig(TargetUniversity university) {
    final countryConfigs = {
      'US': UniversityConfig(
        academicWeight: 0.4,
        activityWeight: 0.3,
        essayWeight: 0.2,
        recommendationWeight: 0.1,
        cutoffScore: university.tier == 'reach' ? 85 : university.tier == 'match' ? 70 : 55,
        noiseFactor: 8,
        valuesResearch: true,
        categoryWeights: {
          ActivityCategory.research: 1.5,
          ActivityCategory.leadership: 1.3,
          ActivityCategory.competitions: 1.2,
          ActivityCategory.volunteering: 1.1,
        },
      ),
      'UK': UniversityConfig(
        academicWeight: 0.6,
        activityWeight: 0.2,
        essayWeight: 0.15,
        recommendationWeight: 0.05,
        cutoffScore: university.tier == 'reach' ? 80 : university.tier == 'match' ? 65 : 50,
        noiseFactor: 6,
        valuesResearch: false,
        categoryWeights: {
          ActivityCategory.competitions: 1.3,
          ActivityCategory.research: 1.2,
        },
      ),
      'Canada': UniversityConfig(
        academicWeight: 0.5,
        activityWeight: 0.25,
        essayWeight: 0.15,
        recommendationWeight: 0.1,
        cutoffScore: university.tier == 'reach' ? 75 : university.tier == 'match' ? 60 : 45,
        noiseFactor: 7,
        valuesResearch: true,
      ),
      'Australia': UniversityConfig(
        academicWeight: 0.55,
        activityWeight: 0.2,
        essayWeight: 0.15,
        recommendationWeight: 0.1,
        cutoffScore: university.tier == 'reach' ? 70 : university.tier == 'match' ? 55 : 40,
        noiseFactor: 7,
      ),
      'Europe': UniversityConfig(
        academicWeight: 0.5,
        activityWeight: 0.25,
        essayWeight: 0.15,
        recommendationWeight: 0.1,
        cutoffScore: university.tier == 'reach' ? 78 : university.tier == 'match' ? 62 : 48,
        noiseFactor: 7,
        valuesResearch: true,
      ),
    };
    
    return countryConfigs[university.country] ?? countryConfigs['US']!;
  }
  
  double _getBoardMultiplier(String board) {
    switch (board.toUpperCase()) {
      case 'CBSE': return 1.0;
      case 'ICSE': return 1.05;
      case 'IB': return 1.1;
      case 'IGCSE': return 1.08;
      default: return 0.95;
    }
  }
  
  double _getTierWeight(ActivityTier tier) {
    switch (tier) {
      case ActivityTier.tier1: return 1.0;
      case ActivityTier.tier2: return 0.7;
      case ActivityTier.tier3: return 0.4;
      case ActivityTier.tier4: return 0.15;
    }
  }
  
  double _getCategoryWeight(ActivityCategory category, UniversityConfig config) {
    return config.categoryWeights[category] ?? 1.0;
  }
  
  Map<String, double> _getComponentScores(
    StudentProfile student,
    List<Activity> activities,
    UniversityConfig config,
  ) {
    return {
      'academic': _simulateAcademicScore(student, config),
      'activities': _simulateActivityScore(activities, config),
      'essays': _simulateEssayScore(student, config),
      'recommendations': _simulateRecommendationScore(student, config),
    };
  }
  
  Map<String, double> _calculateConfidenceInterval(double probability) {
    final se = sqrt(probability * (1 - probability) / MONTE_CARLO_RUNS);
    final margin = 1.96 * se;
    return {
      'lower': (probability - margin).clamp(0, 1),
      'upper': (probability + margin).clamp(0, 1),
    };
  }
}

extension RandomExtension on Random {
  double nextGaussian() {
    // Box-Muller transform
    final u1 = nextDouble();
    final u2 = nextDouble();
    return sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  }
}

@immutable
class UniversityConfig {
  final double academicWeight;
  final double activityWeight;
  final double essayWeight;
  final double recommendationWeight;
  final double cutoffScore;
  final double noiseFactor;
  final bool valuesResearch;
  final Map<ActivityCategory, double> categoryWeights;
  
  const UniversityConfig({
    required this.academicWeight,
    required this.activityWeight,
    required this.essayWeight,
    required this.recommendationWeight,
    required this.cutoffScore,
    required this.noiseFactor,
    required this.valuesResearch,
    required this.categoryWeights,
  });
}

@immutable
class TargetUniversity {
  final String name;
  final String country;
  final String major;
  final String tier; // 'reach', 'match', 'safety'
  
  const TargetUniversity({
    required this.name,
    required this.country,
    required this.major,
    required this.tier,
  });
}

@immutable
class UniversityProbability {
  final TargetUniversity university;
  final double probability;
  final Map<String, double> confidenceInterval;
  final Map<String, double> sensitivity;
  final List<String> keyLevers;
  final Map<String, double> componentScores;
  
  const UniversityProbability({
    required this.university,
    required this.probability,
    required this.confidenceInterval,
    required this.sensitivity,
    required this.keyLevers,
    required this.componentScores,
  });
}

@immutable
class AdmissionsProbabilityResult {
  final List<UniversityProbability> universityProbabilities;
  final double overallProfileStrength;
  final List<String> keyLevers;
  final Map<String, double> trajectoryProjection;
  final DateTime generatedAt;
  
  const AdmissionsProbabilityResult({
    required this.universityProbabilities,
    required this.overallProfileStrength,
    required this.keyLevers,
    required this.trajectoryProjection,
    required this.generatedAt,
  });
}