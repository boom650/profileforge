import 'package:profileforge/core/ai/ai_json.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AiMission — Builds the AI prompt and parses AI-authored missions.
///
/// AI = drafts, we validate. This turns the OnboardingProfile into a rich,
/// personalized daily plan — jumping to concrete targets instead of templates.
/// ────────────────────────────────────────────────────────────────────────────
class AiMission {
  /// System prompt for the mission architect.
  static const systemPrompt = '''
You are ProfileForge's Mission Architect — an elite college-admissions strategist.
You write DAILY missions for a high-school student that are:
- Highly specific and doable in <=60 minutes
- College-admissions aware (reference their target universities and what those schools value)
- Actionable, never vague ("review 30 min of weak topic X", not "study hard")
- Balanced across academics, leadership, research, creativity, community, service

You write like a sharp college counselor: encouraging, honest, concrete.
''';

  /// Build the user prompt for a given student profile.
  static String buildUserPrompt(
    OnboardingProfile p, {
    String? personaHint,
    EssayContext? essay,
    String? psychHint,
  }) {
    final buf = StringBuffer();

    buf.writeln('Here is the student\'s current profile:');
    if (p.grades.isNotEmpty) {
      buf.writeln(
          'Grades: ${p.grades.entries.map((e) => '${e.key} ${e.value}').join(", ")}');
    }
    if (p.subjects.isNotEmpty) {
      buf.writeln('Strong subjects: ${p.subjects.join(", ")}');
    }
    if (p.targetUniversities.isNotEmpty) {
      buf.writeln('Target universities: ${p.targetUniversities.join(", ")}');
    }
    if (p.activities.isNotEmpty) {
      buf.writeln('Current activities: ${p.activities.join(", ")}');
    }
    if (p.competitions.isNotEmpty) {
      buf.writeln(
          'Competitions: ${p.competitions.map((c) => c.label).join("; ")}');
    }
    if (p.careerInterests.isNotEmpty) {
      buf.writeln('Career interests: ${p.careerInterests.join(", ")}');
    }
    if (p.availabilityHoursPerWeek > 0) {
      buf.writeln('Availability: ${p.availabilityHoursPerWeek} hrs/week');
    }
    if (essay != null) {
      if (essay.story.isNotEmpty) {
        buf.writeln(
            'Defining story seed (for the personal statement): ${essay.story}');
      }
      if (essay.values.isNotEmpty) {
        buf.writeln('Core values: ${essay.values.join(", ")}');
      }
      if (essay.curiosity.isNotEmpty) {
        buf.writeln(
            'Intellectual curiosity — "what keeps them up at night": ${essay.curiosity}');
      }
    }
    if (personaHint != null && personaHint.isNotEmpty) {
      buf.writeln('Student style: $personaHint');
    }
    if (psychHint != null && psychHint.isNotEmpty) {
      buf.writeln(
          'Communication/motivation profile (adapt your tone and framing to this): $psychHint');
    }

    buf.writeln('''
Write exactly 5 daily missions. Rules:
- Tackle the weakest grade (turn a red flag into momentum).
- Deepen the strongest subject or drive a target-university alignment.
- 1 mission may be leadership/community/service to build a profile spike.
- 1 mission may be a small wellbeing/consistency task.
- Each must be completable in <=60 minutes.
- Assign a pillar from: academics, leadership, research, creativity, community, service, sports, personal.
- Assign a priority from: critical, high, medium, low.

Return ONLY valid JSON. No prose. No markdown fences. Example:
[
  {"title": "...", "description": "...", "pillar": "academics", "xp": 15, "priority": "high", "reason": "..."}
]
''');

    return buf.toString();
  }

  static const _validPillars = {
    'academics': MissionPillar.academics,
    'leadership': MissionPillar.leadership,
    'research': MissionPillar.research,
    'creativity': MissionPillar.creativity,
    'community': MissionPillar.community,
    'service': MissionPillar.service,
    'sports': MissionPillar.sports,
    'personal': MissionPillar.personal,
  };

  static const _validPriorities = {'critical', 'high', 'medium', 'low'};

  /// Parse raw AI output into valid [Mission]s. Invalid rows are DROPPED
  /// (we never fail the whole batch because of one bad item).
  static List<Mission> parseMissions(
    String raw, {
    required String profileId,
    required MissionCadence cadence,
    required String source,
  }) {
    if (source != 'ai')
      throw ArgumentError('source must be "ai" for AI missions');

    final maps = AiJson.extractJsonArray(raw);
    final out = <Mission>[];
    final now = DateTime.now();

    for (var i = 0; i < maps.length; i++) {
      final m = maps[i];
      final title = AiJson.clean(AiJson.toString_(m['title']));
      final description = AiJson.clean(AiJson.toString_(m['description']));
      if (title.isEmpty || description.isEmpty) continue;

      final pillar = _validPillars[AiJson.toString_(m['pillar']).toLowerCase()];
      if (pillar == null) continue;

      final xp = AiJson.toInt(m['xp'], fallback: 12, min: 5, max: 200);
      final priority = _validPriorities
              .contains(AiJson.toString_(m['priority']).toLowerCase())
          ? AiJson.toString_(m['priority']).toLowerCase()
          : 'medium';
      final reason = AiJson.clean(AiJson.toString_(m['reason']));

      out.add(Mission(
        id: '$source-${profileId.substring(0, profileId.length > 6 ? 6 : profileId.length)}-${cadence.name}-$now-$i',
        profileId: profileId,
        title: title,
        description: description,
        cadence: cadence,
        pillar: pillar,
        xpReward: xp,
        gemReward: (xp / 5).ceil().clamp(2, 10),
        dueAt: _dueFor(cadence, now),
        completed: false,
        target: 1,
      ).copyWith(source: source, priority: priority, rationale: reason));
    }

    return out;
  }

  static MissionPillar? _pillarFrom(String s) => _validPillars[s.toLowerCase()];

  static DateTime? _dueFor(MissionCadence cadence, DateTime now) {
    switch (cadence) {
      case MissionCadence.daily:
        return now.add(const Duration(days: 1));
      case MissionCadence.weekly:
        return now.add(const Duration(days: 7));
      case MissionCadence.monthly:
        return DateTime(now.year, now.month + 1, 0);
      case MissionCadence.special:
      case MissionCadence.seasonal:
      case MissionCadence.university:
        return now.add(const Duration(days: 7));
    }
  }
}
