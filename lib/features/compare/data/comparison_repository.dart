import 'package:flutter/material.dart';
import 'package:profileforge/features/compare/domain/comparison_models.dart';

/// Produces a [ComparisonResult] for the user against the school catalog,
/// using the user's real GPA (SAT/ACT are not collected → never fabricated).
class ComparisonRepository {
  const ComparisonRepository();

  static const List<School> schools = [
    School(
      name: 'MIT',
      logo: Icons.school,
      acceptanceRate: 4,
      avgGPA: 4.17,
      avgSAT: 1545,
      avgACT: 35,
      color: Color(0xFFA31F34),
      strengths: ['STEM', 'Research', 'Innovation'],
    ),
    School(
      name: 'Stanford',
      logo: Icons.school,
      acceptanceRate: 4,
      avgGPA: 4.18,
      avgSAT: 1550,
      avgACT: 35,
      color: Color(0xFF8C1515),
      strengths: ['Entrepreneurship', 'Liberal Arts', 'Tech'],
    ),
    School(
      name: 'Harvard',
      logo: Icons.school,
      acceptanceRate: 3,
      avgGPA: 4.2,
      avgSAT: 1555,
      avgACT: 35,
      color: Color(0xFFA51C30),
      strengths: ['Research', 'Networking', 'Prestige'],
    ),
    School(
      name: 'Caltech',
      logo: Icons.school,
      acceptanceRate: 3,
      avgGPA: 4.19,
      avgSAT: 1560,
      avgACT: 36,
      color: Color(0xFFFF6C0C),
      strengths: ['STEM', 'Research', 'Small Classes'],
    ),
    School(
      name: 'UC Berkeley',
      logo: Icons.school,
      acceptanceRate: 12,
      avgGPA: 4.15,
      avgSAT: 1480,
      avgACT: 33,
      color: Color(0xFF003262),
      strengths: ['Value', 'Research', 'Diversity'],
    ),
    School(
      name: 'Columbia',
      logo: Icons.school,
      acceptanceRate: 4,
      avgGPA: 4.16,
      avgSAT: 1545,
      avgACT: 35,
      color: Color(0xFFB9D9EB),
      strengths: ['Core Curriculum', 'NYC', 'Writing'],
    ),
  ];

  ComparisonResult computeResult({required double? userGpa}) {
    return ComparisonResult(
      userGpa: userGpa,
      matches: [
        for (final school in schools)
          SchoolMatch(
            school: school,
            matchPercent: ComparisonResult.matchPercent(userGpa, school.avgGPA),
          ),
      ],
    );
  }
}