import 'package:flutter/material.dart';
import '../ai/psychological_profile.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Profile Scoring Algorithm — Weighted scoring based on research.
///
/// Research sources:
/// - 01-student-profile-scoring-analytics.md (scoring algorithm)
/// - 01-gpa-grade-analysis-system.md (GPA analysis)
/// - 01-test-score-optimization.md (test scores)
/// - 01-essay-writing-framework.md (essay scoring)
///
/// Weights:
/// - GPA: 35%
/// - Test Scores: 20%
/// - Activities: 20%
/// - Essays: 10%
/// - Psychology: 5%
/// - Growth Mindset: 5%
/// - AI Insights: 5%
/// ────────────────────────────────────────────────────────────────────────────
class ProfileScoring {
  /// Calculate overall profile score (0-100)
  static ProfileScore calculate({
    required StudentData student,
    required PsychologicalProfile? psychology,
    AIInsights? aiInsights,
  }) {
    // GPA Score (0-100)
    final gpaScore = _calculateGPAScore(student);

    // Test Score (0-100)
    final testScore = _calculateTestScore(student);

    // Activities Score (0-100)
    final activitiesScore = _calculateActivitiesScore(student);

    // Essay Score (0-100)
    final essayScore = _calculateEssayScore(student);

    // Psychology Score (0-100)
    final psychologyScore = _calculatePsychologyScore(psychology);

    // Growth Mindset Score (0-100)
    final growthScore = _calculateGrowthScore(psychology);

    // AI Insights Score (0-100)
    final aiScore = _calculateAIScore(aiInsights);

    // Weighted total
    final total = (gpaScore * 0.35) +
        (testScore * 0.20) +
        (activitiesScore * 0.20) +
        (essayScore * 0.10) +
        (psychologyScore * 0.05) +
        (growthScore * 0.05) +
        (aiScore * 0.05);

    return ProfileScore(
      total: total.round(),
      gpaScore: gpaScore.round(),
      testScore: testScore.round(),
      activitiesScore: activitiesScore.round(),
      essayScore: essayScore.round(),
      psychologyScore: psychologyScore.round(),
      growthScore: growthScore.round(),
      aiScore: aiScore.round(),
      tier: _getTier(total),
      strengths: _identifyStrengths(
        gpaScore: gpaScore,
        testScore: testScore,
        activitiesScore: activitiesScore,
        essayScore: essayScore,
      ),
      improvements: _identifyImprovements(
        gpaScore: gpaScore,
        testScore: testScore,
        activitiesScore: activitiesScore,
        essayScore: essayScore,
      ),
    );
  }

  /// ── GPA Scoring ──────────────────────────────────────────────────────────
  static double _calculateGPAScore(StudentData student) {
    if (student.gpa == null) return 50.0; // Default if no data

    final gpa = student.gpa!;
    final maxGpa = student.isWeighted ? 5.0 : 4.0;

    // Normalize to 0-100
    double score = (gpa / maxGpa) * 100;

    // Bonus for upward trend
    if (student.gpaTrend == GPATrend.upward) {
      score = (score + 5).clamp(0, 100);
    } else if (student.gpaTrend == GPATrend.downward) {
      score = (score - 5).clamp(0, 100);
    }

    return score;
  }

  /// ── Test Score Scoring ───────────────────────────────────────────────────
  static double _calculateTestScore(StudentData student) {
    if (student.satScore == null && student.actScore == null) return 50.0;

    double score = 50.0;

    if (student.satScore != null) {
      // SAT: 400-1600 range, 1000 is average
      score = ((student.satScore! - 400) / 1200) * 100;
    }

    if (student.actScore != null) {
      // ACT: 1-36 range, 21 is average
      final actScore = ((student.actScore! - 1) / 35) * 100;
      if (student.satScore == null) {
        score = actScore;
      } else {
        score = (score + actScore) / 2;
      }
    }

    return score.clamp(0, 100);
  }

  /// ── Activities Score ─────────────────────────────────────────────────────
  static double _calculateActivitiesScore(StudentData student) {
    if (student.activities.isEmpty) return 20.0;

    double score = 0;

    // Quantity (max 30 points)
    final quantityScore = (student.activities.length * 6).clamp(0, 30);
    score += quantityScore;

    // Quality indicators (max 40 points)
    for (final activity in student.activities) {
      if (activity.isLeadership) score += 5;
      if (activity.isLongTerm) score += 5; // 2+ years
      if (activity.hasImpact) score += 5;
      if (activity.isNationallyRecognized) score += 10;
    }
    score = score.clamp(0, 70);

    // Diversity (max 20 points)
    final categories = student.activities
        .map((a) => a.category)
        .toSet()
        .length;
    final diversityScore = (categories * 5).clamp(0, 20);
    score += diversityScore;

    // Depth over breadth bonus (max 10 points)
    final deepActivities = student.activities
        .where((a) => a.yearsInvolved >= 2)
        .length;
    if (deepActivities >= 2) score += 10;

    return score.clamp(0, 100);
  }

  /// ── Essay Score ──────────────────────────────────────────────────────────
  static double _calculateEssayScore(StudentData student) {
    if (student.essays.isEmpty) return 30.0;

    double totalScore = 0;

    for (final essay in student.essays) {
      double essayScore = 50.0; // Base

      // Word count check
      if (essay.wordCount >= 250 && essay.wordCount <= 650) {
        essayScore += 10;
      }

      // Has personal voice
      if (essay.hasPersonalVoice) essayScore += 15;

      // Shows growth/reflection
      if (essay.showsGrowth) essayScore += 15;

      // Unique angle
      if (essay.hasUniqueAngle) essayScore += 10;

      totalScore += essayScore.clamp(0, 100);
    }

    return totalScore / student.essays.length;
  }

  /// ── Psychology Score ─────────────────────────────────────────────────────
  static double _calculatePsychologyScore(PsychologicalProfile? profile) {
    if (profile == null) return 50.0;

    double score = 50.0;

    // Self-efficacy contributes to performance
    score += (profile.selfEfficacy - 0.5) * 20;

    // Competence contributes to academic performance
    score += (profile.competence - 0.5) * 15;

    // Emotional stability helps under pressure
    score += ((1 - profile.neuroticism) - 0.5) * 15;

    return score.clamp(0, 100);
  }

  /// ── Growth Score ─────────────────────────────────────────────────────────
  static double _calculateGrowthScore(PsychologicalProfile? profile) {
    if (profile == null) return 50.0;

    double score = 50.0;

    // Growth mindset is directly scored
    score += (profile.growthMindset - 0.5) * 40;

    // Conscientiousness supports growth
    score += (profile.conscientiousness - 0.5) * 10;

    return score.clamp(0, 100);
  }

  /// ── AI Insights Score ────────────────────────────────────────────────────
  static double _calculateAIScore(AIInsights? insights) {
    if (insights == null) return 50.0;

    double score = 50.0;

    // Engagement level
    score += (insights.engagementLevel - 0.5) * 20;

    // Improvement rate
    score += (insights.improvementRate - 0.5) * 20;

    return score.clamp(0, 100);
  }

  /// ── Tier Classification ──────────────────────────────────────────────────
  static ScoreTier _getTier(double score) {
    if (score >= 90) return ScoreTier.platinum;
    if (score >= 75) return ScoreTier.gold;
    if (score >= 60) return ScoreTier.silver;
    if (score >= 40) return ScoreTier.bronze;
    return ScoreTier.developing;
  }

  /// ── Strengths Identification ─────────────────────────────────────────────
  static List<String> _identifyStrengths({
    required double gpaScore,
    required double testScore,
    required double activitiesScore,
    required double essayScore,
  }) {
    final strengths = <String>[];

    if (gpaScore >= 80) strengths.add('Strong GPA');
    if (testScore >= 80) strengths.add('Excellent Test Scores');
    if (activitiesScore >= 70) strengths.add('Impressive Activities');
    if (essayScore >= 70) strengths.add('Compelling Essays');

    return strengths;
  }

  /// ── Improvements Identification ──────────────────────────────────────────
  static List<String> _identifyImprovements({
    required double gpaScore,
    required double testScore,
    required double activitiesScore,
    required double essayScore,
  }) {
    final improvements = <String>[];

    if (gpaScore < 60) improvements.add('GPA needs improvement');
    if (testScore < 60) improvements.add('Consider retaking tests');
    if (activitiesScore < 50) improvements.add('Add more meaningful activities');
    if (essayScore < 50) improvements.add('Work on essay quality');

    return improvements;
  }
}

/// ── Profile Score Result ───────────────────────────────────────────────────
class ProfileScore {
  const ProfileScore({
    required this.total,
    required this.gpaScore,
    required this.testScore,
    required this.activitiesScore,
    required this.essayScore,
    required this.psychologyScore,
    required this.growthScore,
    required this.aiScore,
    required this.tier,
    required this.strengths,
    required this.improvements,
  });

  final int total;
  final int gpaScore;
  final int testScore;
  final int activitiesScore;
  final int essayScore;
  final int psychologyScore;
  final int growthScore;
  final int aiScore;
  final ScoreTier tier;
  final List<String> strengths;
  final List<String> improvements;

  Color get tierColor {
    switch (tier) {
      case ScoreTier.platinum:
        return const Color(0xFFE5E7EB); // Platinum
      case ScoreTier.gold:
        return const Color(0xFFF59E0B); // Gold
      case ScoreTier.silver:
        return const Color(0xFF7A6A5F); // Silver
      case ScoreTier.bronze:
        return const Color(0xFFCD7F32); // Bronze
      case ScoreTier.developing:
        return const Color(0xFF7A6A5F); // Slate
    }
  }

  String get tierName {
    switch (tier) {
      case ScoreTier.platinum:
        return 'Platinum';
      case ScoreTier.gold:
        return 'Gold';
      case ScoreTier.silver:
        return 'Silver';
      case ScoreTier.bronze:
        return 'Bronze';
      case ScoreTier.developing:
        return 'Developing';
    }
  }
}

enum ScoreTier {
  platinum,
  gold,
  silver,
  bronze,
  developing,
}

enum GPATrend {
  upward,
  stable,
  downward,
}

/// ── Student Data Model ─────────────────────────────────────────────────────
class StudentData {
  const StudentData({
    this.gpa,
    this.isWeighted = false,
    this.gpaTrend = GPATrend.stable,
    this.satScore,
    this.actScore,
    this.activities = const [],
    this.essays = const [],
  });

  final double? gpa;
  final bool isWeighted;
  final GPATrend gpaTrend;
  final int? satScore;
  final int? actScore;
  final List<Activity> activities;
  final List<Essay> essays;
}

/// ── Activity Model ─────────────────────────────────────────────────────────
class Activity {
  const Activity({
    required this.name,
    required this.category,
    this.yearsInvolved = 1,
    this.isLeadership = false,
    this.hasImpact = false,
    this.isNationallyRecognized = false,
  });

  final String name;
  final String category;
  final int yearsInvolved;
  final bool isLeadership;
  final bool hasImpact;
  final bool isNationallyRecognized;

  bool get isLongTerm => yearsInvolved >= 2;
}

/// ── Essay Model ────────────────────────────────────────────────────────────
class Essay {
  const Essay({
    required this.title,
    this.wordCount = 0,
    this.hasPersonalVoice = false,
    this.showsGrowth = false,
    this.hasUniqueAngle = false,
  });

  final String title;
  final int wordCount;
  final bool hasPersonalVoice;
  final bool showsGrowth;
  final bool hasUniqueAngle;
}

/// ── AI Insights Model ──────────────────────────────────────────────────────
class AIInsights {
  const AIInsights({
    this.engagementLevel = 0.5,
    this.improvementRate = 0.5,
  });

  final double engagementLevel;
  final double improvementRate;
}
