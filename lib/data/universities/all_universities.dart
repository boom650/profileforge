import 'university_model.dart';
import 'uk_universities.dart';
import 'canada_universities.dart';
import 'australia_universities.dart';
import 'eu_universities.dart';

/// Combined list of all non-US universities in the database.
final List<University> allNonUSUniversities = [
  ...ukUniversities,
  ...canadaUniversities,
  ...australiaUniversities,
  ...euUniversities,
];

/// Known US universities referenced in the existing onboarding screen.
const List<String> usUniversityNames = [
  'MIT',
  'Stanford',
  'Harvard',
  'Caltech',
  'Princeton',
  'Yale',
  'Columbia',
  'UCLA',
  'UCSD',
  'Purdue',
  'UIUC',
];

/// All university names (US + international) for quick lookup.
List<String> get allUniversityNames => [
  ...usUniversityNames,
  ...allNonUSUniversities.map((u) => u.name),
];

/// Filter universities by country code (e.g., 'UK', 'Canada', 'Australia', 'Switzerland').
List<University> filterByCountry(String country) {
  final query = country.toLowerCase();
  return allNonUSUniversities.where((u) => u.country.toLowerCase() == query).toList();
}

/// Filter universities by country group.
List<University> filterByCountryGroup(String group) {
  switch (group.toLowerCase()) {
    case 'uk':
      return ukUniversities;
    case 'canada':
      return canadaUniversities;
    case 'australia':
      return australiaUniversities;
    case 'eu':
    case 'europe':
      return euUniversities;
    default:
      return allNonUSUniversities;
  }
}

/// Search universities by name (case-insensitive, partial match).
List<University> searchUniversities(String query) {
  if (query.isEmpty) return allNonUSUniversities;
  final lowerQuery = query.toLowerCase();
  return allNonUSUniversities
      .where((u) =>
          u.name.toLowerCase().contains(lowerQuery) ||
          u.country.toLowerCase().contains(lowerQuery) ||
          u.city.toLowerCase().contains(lowerQuery) ||
          u.notablePrograms.any((p) => p.toLowerCase().contains(lowerQuery)))
      .toList();
}

/// Filter by minimum world ranking.
List<University> filterByRanking(int maxRanking) {
  return allNonUSUniversities.where((u) => u.worldRanking <= maxRanking).toList();
}

/// Filter by program keyword.
List<University> filterByProgram(String programKeyword) {
  final lower = programKeyword.toLowerCase();
  return allNonUSUniversities
      .where((u) => u.notablePrograms.any((p) => p.toLowerCase().contains(lower)))
      .toList();
}

/// Countries available in the database.
const List<String> availableCountries = [
  'UK',
  'Canada',
  'Australia',
  'Switzerland',
  'Netherlands',
  'Italy',
  'France',
  'Germany',
];

/// Country group labels for UI dropdown.
const List<String> countryGroupLabels = [
  'UK',
  'Canada',
  'Australia',
  'Europe (EU)',
  'All Non-US',
];
