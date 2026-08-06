import 'dart:convert';

/// ────────────────────────────────────────────────────────────────────────────
/// AI JSON — Strict parsing of model output.
///
/// AI = drafts, we validate. Never blindly trust model output.
/// Handles: code fences, markdown noise, leading prose, trailing prose.
/// ────────────────────────────────────────────────────────────────────────────
class AiJson {
  /// Extract the first JSON array from raw model output.
  static List<Map<String, dynamic>> extractJsonArray(String raw) {
    if (raw.isEmpty) return const [];

    // 1. Strip code fences (```json ... ``` or ``` ... ```).
    var text = raw
        .replaceAll(RegExp(r'```(?:json)?\s*', caseSensitive: false), '')
        .replaceAll('```', '');

    // 2. Find first '[' ... last ']'.
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start == -1 || end == -1 || end <= start) return const [];

    final jsonText = text.substring(start, end + 1);
    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! List) return const [];
      return decoded.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return const [];
    }
  }

  /// Safe int extraction (handles "15", 15, "15 XP", 15.7).
  static int toInt(dynamic v, {int fallback = 10, int min = 0, int max = 9999}) {
    if (v is int) return v.clamp(min, max);
    if (v is num) return v.round().clamp(min, max);
    if (v is String) {
      final m = RegExp(r'-?\d+').firstMatch(v);
      if (m != null) {
        final n = int.tryParse(m.group(0)!) ?? fallback;
        return n.clamp(min, max);
      }
    }
    return fallback;
  }

  /// Safe string extraction.
  static String toString_(dynamic v, {String fallback = ''}) {
    if (v is String) return v.trim();
    if (v is num || v is bool) return v.toString();
    return fallback;
  }

  /// Clean + trim a mission title/description.
  static String clean(String s) => s.trim().replaceAll(RegExp(r'\s+'), ' ');
}
