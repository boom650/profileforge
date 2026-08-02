/// City-based recommendations for study spots, cafes, and libraries.
class CityData {
  static const Map<String, CityRecommendation> cities = {
    'singapore': CityRecommendation(
      name: 'Singapore',
      emoji: '🇸🇬',
      studySpots: [
        'National Library Board (Bugis) — 8 floors of quiet zones',
        'NUS Central Library — 24/7 during exam season',
        'The Study Room (Bukit Timah) — Premium co-working',
        'Ya Kun Kaya (CBD) — Classic study cafe',
        'Toast Box (Tiong Bahru) — Quiet mornings',
      ],
      tips: 'Use EZ-Link for free transport to any library. NUS libraries are free for public on weekdays.',
    ),
    'new york': CityRecommendation(
      name: 'New York',
      emoji: '🇺🇸',
      studySpots: [
        'NYU Bobst Library — 4 floors of silent study',
        'Brooklyn Public Library (Grand Army Plaza) — Stunning architecture',
        'Think Coffee (Mercer St) — Student-friendly wifi',
        'The New York Public Library (Rose Reading Room) — Iconic',
        'Stump Coffee (Williamsburg) — Quiet corner tables',
      ],
      tips: 'Get a free NYPL card. Most Columbia libraries open to public after 7pm.',
    ),
    'london': CityRecommendation(
      name: 'London',
      emoji: '🇬🇧',
      studySpots: [
        'British Library — 1,200 seats, silent zones',
        'Senate House Library (UCL) — Grand reading rooms',
        'Foyles (Charing Cross) — 5th floor cafe',
        'Watch House (Bermondsey) — Premium quiet cafe',
        'Waterstones Piccadilly — 5 floors of books + cafe',
      ],
      tips: 'Get a free Westminster library card. Many uni libraries open to public during holidays.',
    ),
    'mumbai': CityRecommendation(
      name: 'Mumbai',
      emoji: '🇮🇳',
      studySpots: [
        'David Sassoon Library — Heritage reading room',
        'Asiatic Society Library — 1 million+ books',
        'British Council Library (Nariman Point) — Premium membership',
        'Cafe Coffee Day (BKC) — Good wifi, late hours',
        'Tata Institute library — If you know someone with access',
      ],
      tips: 'Morning hours (6-9am) are best for library visits. Avoid rush hour.',
    ),
    'sydney': CityRecommendation(
      name: 'Sydney',
      emoji: '🇦🇺',
      studySpots: [
        'State Library of NSW — Free, stunning Macquarie Room',
        'University of Sydney Fisher Library — World-class',
        'The Grounds of Alexandria — Beautiful outdoor study',
        'Paramount Coffee Project — Quiet mornings',
        'Better Bread Co (Surry Hills) — Student-friendly',
      ],
      tips: 'Get a free State Library card. Many uni libraries open to public.',
    ),
    'tokyo': CityRecommendation(
      name: 'Tokyo',
      emoji: '🇯🇵',
      studySpots: [
        'National Diet Library — Largest in Asia',
        'University of Tokyo Komaba Library — Quiet, academic',
        'Starbucks Reserve Roastery — Inspiring environment',
        'Tullys Coffee (Shibuya) — Late night study spots',
        'Honjin Hiranoya (Asakusa) — Traditional atmosphere',
      ],
      tips: 'Many convenience stores (7-Eleven, FamilyMart) have quiet seating. Manga cafes offer 24/7 study pods.',
    ),
    'toronto': CityRecommendation(
      name: 'Toronto',
      emoji: '🇨🇦',
      studySpots: [
        'Toronto Reference Library — 7 floors, free wifi',
        'University of Toronto Robarts Library — Iconic study space',
        'Balzac\'s Coffee (Distillery District) — Premium atmosphere',
        'Boxcar Social (Summerhill) — Quiet, great coffee',
        'Hot Docs Cinema Cafe — Unique study environment',
      ],
      tips: 'Get a free TPL card. U of T libraries open to public during exams.',
    ),
    'berlin': CityRecommendation(
      name: 'Berlin',
      emoji: '🇩🇪',
      studySpots: [
        'Staatsbibliothek (Humboldtplatz) — Europe\'s best library',
        'Free University Library — 24/7 during exam season',
        'Bonanza Coffee (Kreuzberg) — Specialty coffee, quiet',
        'House of Small Measures (Neukölln) — Cozy study cafe',
        'The Barn (Mitte) — Premium workspace',
      ],
      tips: 'Many libraries are free for EU residents. Berlin has the best co-working scene in Europe.',
    ),
    'dubai': CityRecommendation(
      name: 'Dubai',
      emoji: '🇦🇪',
      studySpots: [
        'Dubai Public Library (Jumeirah) — Modern, free wifi',
        'Mohammed Bin Rashid Library — Stunning architecture',
        'Costa Coffee (DIFC) — Business district quiet',
        '% Arabica (Downtown) — Premium, quiet mornings',
        'Starbucks Reserve (Dubai Mall) — Late hours',
      ],
      tips: 'Many hotel lobbies have excellent study areas. Dubai Internet City has free co-working spaces.',
    ),
    'san francisco': CityRecommendation(
      name: 'San Francisco',
      emoji: '🇺🇸',
      studySpots: [
        'San Francisco Public Library — 6 floors, free',
        'UCSF Library (Parnassus) — Medical-grade quiet zones',
        'Sightglass Coffee (SoMa) — Industrial chic, spacious',
        'Ritual Coffee (Valencia) — Student-friendly, great wifi',
        'The Mill (Divisadero) — Toast + coffee, quiet mornings',
      ],
      tips: 'Get a free SFPL card. Many startup offices have public study areas.',
    ),
  };

  static CityRecommendation? getCity(String name) {
    final key = name.toLowerCase().trim();
    return cities[key];
  }

  static List<String> get cityNames => cities.keys.toList();
}

class CityRecommendation {
  final String name;
  final String emoji;
  final List<String> studySpots;
  final String tips;

  const CityRecommendation({
    required this.name,
    required this.emoji,
    required this.studySpots,
    required this.tips,
  });
}
