/// Data model for university information used in admission probability calculations.

class University {
  final String name;
  final String country;
  final String city;
  final int worldRanking;
  final double acceptanceRate; // percentage (e.g., 7.5 means 7.5%)
  final double averageGPA; // out of 4.0
  final int? averageSAT; // SAT equivalent (null if not applicable)
  final double tuitionPerYearUSD;
  final List<String> notablePrograms;
  final String applicationDeadline;
  final List<String> requiredTests; // e.g., IELTS 7.0, TOEFL 100
  final String applicationPlatform; // UCAS, Common App, direct, etc.

  const University({
    required this.name,
    required this.country,
    required this.city,
    required this.worldRanking,
    required this.acceptanceRate,
    required this.averageGPA,
    this.averageSAT,
    required this.tuitionPerYearUSD,
    required this.notablePrograms,
    required this.applicationDeadline,
    required this.requiredTests,
    required this.applicationPlatform,
  });

  /// Display name with country code for search results
  String get displayName => '$name ($country)';

  /// Short label for chips/tags
  String get shortLabel => name;
}
