import 'dart:math';
import '../../models/student_profile.dart';

/// University tier classification
enum UniversityTier {
  ivyLeague,
  top20,
  top50,
  top100,
  safety,
}

/// Application classification
enum ApplicationClassification {
  safety,
  target,
  reach,
  dream,
}

/// Factor weights for probability calculation
class AdmissionsFactorWeights {
  static const double gpaWeight = 40.0;
  static const double testScoreWeight = 20.0;
  static const double extracurricularWeight = 15.0;
  static const double essayWeight = 10.0;
  static const double recommendationWeight = 5.0;
  static const double interviewWeight = 5.0;
  static const double researchWeight = 5.0;
  
  static const double total = gpaWeight + testScoreWeight + extracurricularWeight +
      essayWeight + recommendationWeight + interviewWeight + researchWeight;
}

/// Monte Carlo simulation result
class MonteCarloResult {
  final double mean;
  final double median;
  final double p25;
  final double p75;
  final double p10;
  final double p90;
  final double standardDeviation;
  final ApplicationClassification classification;
  final int safetyPercentage;
  final int targetPercentage;
  final int reachPercentage;
  final int dreamPercentage;
  
  const MonteCarloResult({
    required this.mean,
    required this.median,
    required this.p25,
    required this.p75,
    required this.p10,
    required this.p90,
    required this.standardDeviation,
    required this.classification,
    required this.safetyPercentage,
    required this.targetPercentage,
    required this.reachPercentage,
    required this.dreamPercentage,
  });
}

/// Detailed factor breakdown
class AdmissionsFactorBreakdown {
  final double gpaScore;
  final double testScore;
  final double extracurricularScore;
  final double essayScore;
  final double recommendationScore;
  final double interviewScore;
  final double researchScore;
  final double totalScore;
  
  const AdmissionsFactorBreakdown({
    required this.gpaScore,
    required this.testScore,
    required this.extracurricularScore,
    required this.essayScore,
    required this.recommendationScore,
    required this.interviewScore,
    required this.researchScore,
    required this.totalScore,
  });
  
  Map<String, double> toMap() => {
    'Academics': gpaScore / AdmissionsFactorWeights.gpaWeight,
    'Test Scores': testScore / AdmissionsFactorWeights.testScoreWeight,
    'Extracurricular': extracurricularScore / AdmissionsFactorWeights.extracurricularWeight,
    'Essays': essayScore / AdmissionsFactorWeights.essayWeight,
    'Recommendations': recommendationScore / AdmissionsFactorWeights.recommendationWeight,
    'Interview': interviewScore / AdmissionsFactorWeights.interviewWeight,
    'Research': researchScore / AdmissionsFactorWeights.researchWeight,
  };
}

/// University info for calculation
class UniversityInfo {
  final String name;
  final String country;
  final UniversityTier tier;
  final double acceptanceRate;
  final double averageGPA;
  final int averageSAT;
  final double selectivityModifier;
  
  const UniversityInfo({
    required this.name,
    required this.country,
    required this.tier,
    required this.acceptanceRate,
    required this.averageGPA,
    required this.averageSAT,
    this.selectivityModifier = 1.0,
  });
  
  /// Minimum score needed for this tier
  double get tierThreshold {
    switch (tier) {
      case UniversityTier.ivyLeague:
        return 85.0;
      case UniversityTier.top20:
        return 70.0;
      case UniversityTier.top50:
        return 55.0;
      case UniversityTier.top100:
        return 40.0;
      case UniversityTier.safety:
        return 0.0;
    }
  }
}

/// Main admissions probability engine
class AdmissionsEngine {
  final Random _random = Random();
  
  /// Calculate GPA score (0-40 points)
  double _calculateGPAScore(StudentProfile profile) {
    // Convert percentage to 4.0 scale and map to 0-40
    double gpa = profile.tenthPercentage / 25.0; // 100% -> 4.0
    gpa = gpa.clamp(0.0, 4.0);
    
    // Convert to 0-40 scale
    return (gpa / 4.0) * AdmissionsFactorWeights.gpaWeight;
  }
  
  /// Calculate test score (0-20 points)
  double _calculateTestScore(StudentProfile profile) {
    double score = 0;
    
    if (profile.satScore != null) {
      // SAT: 400-1600 -> 0-20
      double satNormalized = (profile.satScore! - 400) / 1200.0;
      satNormalized = satNormalized.clamp(0.0, 1.0);
      score = satNormalized * AdmissionsFactorWeights.testScoreWeight;
    } else if (profile.ieltsScore != null) {
      // IELTS: 0-9 -> 0-20
      double ieltsNormalized = profile.ieltsScore! / 9.0;
      ieltsNormalized = ieltsNormalized.clamp(0.0, 1.0);
      score = ieltsNormalized * AdmissionsFactorWeights.testScoreWeight;
    }
    
    return score;
  }
  
  /// Calculate extracurricular score (0-15 points)
  double _calculateExtracurricularScore(StudentProfile profile) {
    if (profile.activities.isEmpty) return 0;
    
    double totalWeightedScore = 0;
    int maxActivities = 10; // Cap at 10 activities
    
    for (int i = 0; i < min(profile.activities.length, maxActivities); i++) {
      final activity = profile.activities[i];
      
      // Base tier weight
      double tierWeight = activity.tier.weight / 100.0;
      
      // Hours per week contribution (diminishing returns)
      double hoursContribution = min(activity.hoursPerWeek / 20.0, 1.0);
      
      // Weeks per year contribution
      double durationContribution = min(activity.weeksPerYear / 40.0, 1.0);
      
      // Combined activity score
      double activityScore = tierWeight * 0.5 + hoursContribution * 0.25 + durationContribution * 0.25;
      
      // Leadership bonus
      if (activity.category == ActivityCategory.leadership) {
        activityScore *= 1.2;
      }
      
      // Research bonus
      if (activity.category == ActivityCategory.research) {
        activityScore *= 1.15;
      }
      
      totalWeightedScore += activityScore;
    }
    
    // Average and scale to 0-15
    double averageScore = totalWeightedScore / min(profile.activities.length, maxActivities);
    return averageScore * AdmissionsFactorWeights.extracurricularWeight;
  }
  
  /// Calculate essay quality score (0-10 points)
  /// This is a proxy based on available data
  double _calculateEssayScore(StudentProfile profile) {
    // Base score based on profile completeness and motivation
    double baseScore = 5.0; // Start at 50%
    
    // Motivation diversity bonus
    if (profile.motivation.drivers.length >= 3) {
      baseScore += 1.5;
    } else if (profile.motivation.drivers.length >= 2) {
      baseScore += 1.0;
    }
    
    // Unique narrative angle bonus
    bool hasUniqueNarrative = profile.activities.any((a) => 
      a.narrativeAngle.isNotEmpty && a.narrativeAngle.length > 20);
    if (hasUniqueNarrative) {
      baseScore += 2.0;
    }
    
    // Research experience for strong essays
    bool hasResearch = profile.activities.any((a) => 
      a.category == ActivityCategory.research);
    if (hasResearch) {
      baseScore += 1.5;
    }
    
    return (baseScore / 10.0) * AdmissionsFactorWeights.essayWeight;
  }
  
  /// Calculate recommendation strength (0-5 points)
  double _calculateRecommendationScore(StudentProfile profile) {
    double score = 2.5; // Base score
    
    // Teacher verification count
    int verifiedCount = profile.activities
        .where((a) => a.teacherVerification != null && a.teacherVerification!.isNotEmpty)
        .length;
    
    if (verifiedCount >= 3) {
      score += 2.0;
    } else if (verifiedCount >= 2) {
      score += 1.5;
    } else if (verifiedCount >= 1) {
      score += 1.0;
    }
    
    // Coaching institute presence (for structured recommendations)
    if (profile.coachingInstitute.isNotEmpty) {
      score += 0.5;
    }
    
    return (score / 5.0) * AdmissionsFactorWeights.recommendationWeight;
  }
  
  /// Calculate interview performance (0-5 points)
  double _calculateInterviewScore(StudentProfile profile) {
    double score = 2.5; // Base score
    
    // Leadership activities indicate interview readiness
    int leadershipCount = profile.activities
        .where((a) => a.category == ActivityCategory.leadership)
        .length;
    
    if (leadershipCount >= 2) {
      score += 1.5;
    } else if (leadershipCount >= 1) {
      score += 1.0;
    }
    
    // Diversity of activities shows communication skills
    Set<ActivityCategory> categories = profile.activities
        .map((a) => a.category)
        .toSet();
    
    if (categories.length >= 4) {
      score += 1.0;
    } else if (categories.length >= 3) {
      score += 0.5;
    }
    
    return (score / 5.0) * AdmissionsFactorWeights.interviewWeight;
  }
  
  /// Calculate research/publications score (0-5 points)
  double _calculateResearchScore(StudentProfile profile) {
    double score = 0;
    
    // Research activities
    List<Activity> researchActivities = profile.activities
        .where((a) => a.category == ActivityCategory.research)
        .toList();
    
    if (researchActivities.isEmpty) return score;
    
    // Count research activities
    score += min(researchActivities.length * 1.5, 3.0);
    
    // Tier bonus for research
    bool hasHighTierResearch = researchActivities
        .any((a) => a.tier == ActivityTier.tier1 || a.tier == ActivityTier.tier2);
    if (hasHighTierResearch) {
      score += 2.0;
    }
    
    return (score / 5.0) * AdmissionsFactorWeights.researchWeight;
  }
  
  /// Calculate comprehensive factor breakdown
  AdmissionsFactorBreakdown calculateFactorBreakdown(StudentProfile profile) {
    final gpa = _calculateGPAScore(profile);
    final test = _calculateTestScore(profile);
    final extra = _calculateExtracurricularScore(profile);
    final essay = _calculateEssayScore(profile);
    final rec = _calculateRecommendationScore(profile);
    final interview = _calculateInterviewScore(profile);
    final research = _calculateResearchScore(profile);
    
    final total = gpa + test + extra + essay + rec + interview + research;
    
    return AdmissionsFactorBreakdown(
      gpaScore: gpa,
      testScore: test,
      extracurricularScore: extra,
      essayScore: essay,
      recommendationScore: rec,
      interviewScore: interview,
      researchScore: research,
      totalScore: total,
    );
  }
  
  /// Convert score to probability based on university tier
  double scoreToProbability(double score, UniversityInfo university) {
    // Base probability from score
    double baseProbability;
    
    if (score >= university.tierThreshold) {
      // Above threshold - probability increases with excess score
      double excess = score - university.tierThreshold;
      baseProbability = 0.5 + (excess / (100.0 - university.tierThreshold)) * 0.4;
    } else {
      // Below threshold - probability decreases
      baseProbability = (score / university.tierThreshold) * 0.5;
    }
    
    // Apply university selectivity modifier
    baseProbability *= university.selectivityModifier;
    
    // Apply acceptance rate influence
    baseProbability = baseProbability * (1 - university.acceptanceRate) + 
                      university.acceptanceRate * 0.1;
    
    return baseProbability.clamp(0.01, 0.99);
  }
  
  /// Run Monte Carlo simulation
  MonteCarloResult runMonteCarloSimulation({
    required StudentProfile profile,
    required UniversityInfo university,
    int iterations = 10000,
    double noiseLevel = 0.15,
  }) {
    final baseBreakdown = calculateFactorBreakdown(profile);
    final List<double> results = [];
    
    for (int i = 0; i < iterations; i++) {
      // Add random noise to each factor
      double noisyGPA = _addNoise(baseBreakdown.gpaScore, noiseLevel * 0.1);
      double noisyTest = _addNoise(baseBreakdown.testScore, noiseLevel * 0.15);
      double noisyExtra = _addNoise(baseBreakdown.extracurricularScore, noiseLevel * 0.2);
      double noisyEssay = _addNoise(baseBreakdown.essayScore, noiseLevel * 0.25);
      double noisyRec = _addNoise(baseBreakdown.recommendationScore, noiseLevel * 0.2);
      double noisyInterview = _addNoise(baseBreakdown.interviewScore, noiseLevel * 0.3);
      double noisyResearch = _addNoise(baseBreakdown.researchScore, noiseLevel * 0.2);
      
      double noisyTotal = noisyGPA + noisyTest + noisyExtra + noisyEssay + 
                          noisyRec + noisyInterview + noisyResearch;
      
      // Convert to probability
      double probability = scoreToProbability(noisyTotal, university);
      results.add(probability);
    }
    
    // Sort for percentiles
    results.sort();
    
    // Calculate statistics
    double mean = results.reduce((a, b) => a + b) / results.length;
    double median = results[results.length ~/ 2];
    double p25 = results[(results.length * 0.25).toInt()];
    double p75 = results[(results.length * 0.75).toInt()];
    double p10 = results[(results.length * 0.10).toInt()];
    double p90 = results[(results.length * 0.90).toInt()];
    
    // Standard deviation
    double variance = results.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) / results.length;
    double stdDev = sqrt(variance);
    
    // Classification based on mean probability
    ApplicationClassification classification;
    if (mean >= 0.7) {
      classification = ApplicationClassification.safety;
    } else if (mean >= 0.4) {
      classification = ApplicationClassification.target;
    } else if (mean >= 0.2) {
      classification = ApplicationClassification.reach;
    } else {
      classification = ApplicationClassification.dream;
    }
    
    // Distribution percentages
    int safetyCount = results.where((p) => p >= 0.7).length;
    int targetCount = results.where((p) => p >= 0.4 && p < 0.7).length;
    int reachCount = results.where((p) => p >= 0.2 && p < 0.4).length;
    int dreamCount = results.where((p) => p < 0.2).length;
    
    return MonteCarloResult(
      mean: mean,
      median: median,
      p25: p25,
      p75: p75,
      p10: p10,
      p90: p90,
      standardDeviation: stdDev,
      classification: classification,
      safetyPercentage: (safetyCount / iterations * 100).round(),
      targetPercentage: (targetCount / iterations * 100).round(),
      reachPercentage: (reachCount / iterations * 100).round(),
      dreamPercentage: (dreamCount / iterations * 100).round(),
    );
  }
  
  /// Add Gaussian noise to a value
  double _addNoise(double value, double noiseLevel) {
    // Box-Muller transform for Gaussian noise
    double u1 = _random.nextDouble();
    double u2 = _random.nextDouble();
    double noise = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    
    double noisyValue = value + (noise * noiseLevel * value);
    return noisyValue.clamp(0.0, double.infinity);
  }
  
  /// Get university tier from acceptance rate
  static UniversityTier getTierFromAcceptanceRate(double rate) {
    if (rate < 0.10) return UniversityTier.ivyLeague;
    if (rate < 0.20) return UniversityTier.top20;
    if (rate < 0.35) return UniversityTier.top50;
    if (rate < 0.50) return UniversityTier.top100;
    return UniversityTier.safety;
  }
  
  /// Get classification label
  static String getClassificationLabel(ApplicationClassification classification) {
    switch (classification) {
      case ApplicationClassification.safety:
        return 'Safety';
      case ApplicationClassification.target:
        return 'Target';
      case ApplicationClassification.reach:
        return 'Reach';
      case ApplicationClassification.dream:
        return 'Dream';
    }
  }
  
  /// Get classification color
  static int getClassificationColor(ApplicationClassification classification) {
    switch (classification) {
      case ApplicationClassification.safety:
        return 0xFF10B981; // Green
      case ApplicationClassification.target:
        return 0xFF3B82F6; // Blue
      case ApplicationClassification.reach:
        return 0xFFF59E0B; // Amber
      case ApplicationClassification.dream:
        return 0xFFEF4444; // Red
    }
  }
}

/// Predefined universities for demo
class UniversityDatabase {
  static final List<UniversityInfo> universities = [
    // Ivy League
    const UniversityInfo(
      name: 'Harvard University',
      country: 'USA',
      tier: UniversityTier.ivyLeague,
      acceptanceRate: 0.03,
      averageGPA: 3.95,
      averageSAT: 1520,
      selectivityModifier: 0.7,
    ),
    const UniversityInfo(
      name: 'Stanford University',
      country: 'USA',
      tier: UniversityTier.ivyLeague,
      acceptanceRate: 0.04,
      averageGPA: 3.96,
      averageSAT: 1510,
      selectivityModifier: 0.75,
    ),
    const UniversityInfo(
      name: 'MIT',
      country: 'USA',
      tier: UniversityTier.ivyLeague,
      acceptanceRate: 0.04,
      averageGPA: 3.95,
      averageSAT: 1530,
      selectivityModifier: 0.72,
    ),
    // Top 20
    const UniversityInfo(
      name: 'UC Berkeley',
      country: 'USA',
      tier: UniversityTier.top20,
      acceptanceRate: 0.15,
      averageGPA: 3.89,
      averageSAT: 1450,
      selectivityModifier: 0.85,
    ),
    const UniversityInfo(
      name: 'UCLA',
      country: 'USA',
      tier: UniversityTier.top20,
      acceptanceRate: 0.12,
      averageGPA: 3.90,
      averageSAT: 1440,
      selectivityModifier: 0.88,
    ),
    // Top 50
    const UniversityInfo(
      name: 'University of Michigan',
      country: 'USA',
      tier: UniversityTier.top50,
      acceptanceRate: 0.23,
      averageGPA: 3.85,
      averageSAT: 1400,
      selectivityModifier: 0.92,
    ),
    const UniversityInfo(
      name: 'NYU',
      country: 'USA',
      tier: UniversityTier.top50,
      acceptanceRate: 0.16,
      averageGPA: 3.80,
      averageSAT: 1380,
      selectivityModifier: 0.90,
    ),
    // Top 100
    const UniversityInfo(
      name: 'Ohio State University',
      country: 'USA',
      tier: UniversityTier.top100,
      acceptanceRate: 0.53,
      averageGPA: 3.70,
      averageSAT: 1300,
      selectivityModifier: 0.95,
    ),
    // Safety
    const UniversityInfo(
      name: 'Arizona State University',
      country: 'USA',
      tier: UniversityTier.safety,
      acceptanceRate: 0.88,
      averageGPA: 3.50,
      averageSAT: 1180,
      selectivityModifier: 1.0,
    ),
  ];
}

// Note: Providers are defined in app_providers.dart to avoid duplication
