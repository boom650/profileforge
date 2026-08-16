import 'package:flutter/material.dart';

/// A target school with its real admissions profile.
class School {
  final String name;
  final IconData logo;
  final int acceptanceRate;
  final double avgGPA;
  final int avgSAT;
  final int avgACT;
  final Color color;
  final List<String> strengths;

  const School({
    required this.name,
    required this.logo,
    required this.acceptanceRate,
    required this.avgGPA,
    required this.avgSAT,
    required this.avgACT,
    required this.color,
    required this.strengths,
  });

  @override
  bool operator ==(Object other) => other is School && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

/// A school paired with the user's real GPA-based match percentage.
class SchoolMatch {
  final School school;
  final int matchPercent;

  const SchoolMatch({required this.school, required this.matchPercent});
}

/// The result of comparing the user's profile against the school catalog.
///
/// SAT/ACT are not collected by the app, so the match is honestly GPA-only
/// (never fabricated scores).
class ComparisonResult {
  final double? userGpa;
  final List<SchoolMatch> matches;

  const ComparisonResult({required this.userGpa, required this.matches});

  List<School> get schools => [for (final m in matches) m.school];

  /// Match % from REAL data only. Null GPA → no match.
  static int matchPercent(double? userGpa, double avgGpa) {
    if (userGpa == null) return 0;
    return (userGpa / avgGpa * 100).clamp(0, 100).round();
  }

  int? matchFor(School school) {
    for (final m in matches) {
      if (m.school == school) return m.matchPercent;
    }
    return null;
  }
}