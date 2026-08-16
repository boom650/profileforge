import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:profileforge/features/discovery/domain/discovery_models.dart';

/// Loads and parses the synced discovery content packs.
///
/// Returns `null` when the asset (or its key) is missing so callers can
/// distinguish "could not load" from "loaded but empty".
class DiscoveryRepository {
  const DiscoveryRepository();

  Future<Map<String, dynamic>?> _loadJson(String path) async {
    try {
      final raw = await rootBundle.loadString(path);
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<List<UniversityGuide>?> loadUniversityGuides() async {
    final data = await _loadJson('assets/content_pack.json');
    final guides = data?['university_guides'];
    if (guides is! Map) return null;
    return [
      for (final e in guides.entries)
        UniversityGuide.fromJson(e.key.toString(), e.value),
    ];
  }

  Future<List<StudyTip>?> loadStudyTips() async {
    final data = await _loadJson('assets/facts.json');
    final tips = data?['study_tips'];
    if (tips is! List) return null;
    return [for (final t in tips) StudyTip.fromJson(t)];
  }

  Future<List<Olympiad>?> loadOlympiads() async {
    final data = await _loadJson('assets/extra_content.json');
    final list = data?['olympiads'];
    if (list is! List) return null;
    return [for (final o in list) Olympiad.fromJson(o)];
  }

  Future<List<Scholarship>?> loadScholarships() async {
    final data = await _loadJson('assets/extra_content.json');
    final list = data?['scholarships'];
    if (list is! List) return null;
    return [for (final s in list) Scholarship.fromJson(s)];
  }
}