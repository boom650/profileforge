/// Discovery content models — parsed from the synced JSON asset packs
/// (`assets/content_pack.json`, `assets/facts.json`, `assets/extra_content.json`).
library;

/// Base type for every item shown in the Discover tabs.
sealed class DiscoveryItem {
  const DiscoveryItem();
}

/// A university admissions guide (`content_pack.json → university_guides`).
class UniversityGuide extends DiscoveryItem {
  final String name;
  final String overview;
  final List<String> whatMatters;
  final Map<String, String> timeline;

  const UniversityGuide({
    required this.name,
    required this.overview,
    required this.whatMatters,
    required this.timeline,
  });

  factory UniversityGuide.fromJson(String name, Object? json) {
    final map = json is Map ? json : const <dynamic, dynamic>{};
    final whatMatters = map['what_matters'] is List
        ? (map['what_matters'] as List).map((m) => m.toString()).toList()
        : const <String>[];
    final timelineRaw = map['suggested_timeline'];
    final timeline = <String, String>{};
    if (timelineRaw is Map) {
      for (final e in timelineRaw.entries) {
        timeline[e.key.toString()] = e.value.toString();
      }
    }
    return UniversityGuide(
      name: name,
      overview: map['overview']?.toString() ?? '',
      whatMatters: whatMatters,
      timeline: timeline,
    );
  }
}

/// A study tip (`facts.json → study_tips` — plain strings).
class StudyTip extends DiscoveryItem {
  final String text;
  const StudyTip({required this.text});

  factory StudyTip.fromJson(Object? json) => StudyTip(text: json.toString());
}

/// A competition / Olympiad (`extra_content.json → olympiads`).
class Olympiad extends DiscoveryItem {
  final String name;
  final String subject;
  final String region;

  const Olympiad({
    required this.name,
    required this.subject,
    required this.region,
  });

  factory Olympiad.fromJson(Object? json) {
    final map = json is Map ? json : const <dynamic, dynamic>{};
    return Olympiad(
      name: map['name']?.toString() ?? '',
      subject: map['subject']?.toString() ?? '',
      region: map['region']?.toString() ?? '',
    );
  }
}

/// A scholarship (`extra_content.json → scholarships`).
class Scholarship extends DiscoveryItem {
  final String name;
  final String region;
  final String note;

  const Scholarship({
    required this.name,
    required this.region,
    required this.note,
  });

  factory Scholarship.fromJson(Object? json) {
    final map = json is Map ? json : const <dynamic, dynamic>{};
    return Scholarship(
      name: map['name']?.toString() ?? '',
      region: map['region']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
    );
  }
}