import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';
import 'package:profileforge/core/extensions/list_extensions.dart';

/// Turns a captured [OnboardingProfile] into *personalized* missions —
/// not blind templates. This is what makes the app feel like it knows you.
class MissionGenerator {
  const MissionGenerator();

  /// Daily mission set derived from the user's real context.
  List<_GenMission> generateDaily(OnboardingProfile p, String profileId) {
    final out = <_GenMission>[];
    var i = 0;
    String id(String tag) => 'd-$profileId-$tag-${DateTime.now().day}-${i++}';

    // 1) Weakest subject (lowest grade %) → study mission.
    if (p.grades.isNotEmpty) {
      final weakest = p.grades.entries
          .reduce((a, b) => _pct(a.value) <= _pct(b.value) ? a : b);
      out.add(_GenMission(
        id: id('weak'),
        title: 'Spend 30 min strengthening ${weakest.key} (you\'re at ${weakest.value})',
        pillar: 'academics',
        xp: 15,
      ));
    }

    // 2) Strongest subject → teach / make a resource (leadership + academics).
    if (p.grades.isNotEmpty) {
      final strongest = p.grades.entries
          .reduce((a, b) => _pct(a.value) >= _pct(b.value) ? a : b);
      out.add(_GenMission(
        id: id('teach'),
        title: 'Make a 1-page study guide for ${strongest.key} to help a peer',
        pillar: 'leadership',
        xp: 20,
      ));
    }

    // 3) A target university → research its admission essay prompt.
    if (p.targetUniversities.isNotEmpty) {
      final u = p.targetUniversities.first;
      out.add(_GenMission(
        id: id('uni'),
        title: 'Draft an outline for $u\'s admission essay prompt',
        pillar: 'academics',
        xp: 25,
      ));
    }

    // 4) Competitions: if few/none, prompt to find one; else go deeper.
    if (p.competitions.isEmpty) {
      out.add(_GenMission(
        id: id('comp'),
        title: 'Find 1 Olympiad / competition in ${p.subjects.firstOrEmpty} and note its deadline',
        pillar: 'research',
        xp: 20,
      ));
    } else {
      out.add(_GenMission(
        id: id('comp2'),
        title: 'Prep 1 hour for ${p.competitions.first.name} (you placed ${p.competitions.first.result})',
        pillar: 'research',
        xp: 25,
      ));
    }

    // 5) Activities: if none, start one; else document & reflect.
    if (p.activities.isEmpty) {
      out.add(_GenMission(
        id: id('act'),
        title: 'Join or start 1 club / society this week',
        pillar: 'community',
        xp: 20,
      ));
    } else {
      out.add(_GenMission(
        id: id('act2'),
        title: 'Write a 200-word reflection on: ${p.activities.first}',
        pillar: 'creativity',
        xp: 15,
      ));
    }

    // 6) Career interest → informational interview / read.
    if (p.careerInterests.isNotEmpty) {
      out.add(_GenMission(
        id: id('career'),
        title: 'Read 1 article or watch a talk about ${p.careerInterests.first}',
        pillar: 'research',
        xp: 15,
      ));
    }

    // 7) Always: a small wellbeing / consistency task.
    out.add(_GenMission(
      id: id('well'),
      title: 'Plan your week in 5 minutes and block study time',
      pillar: 'personal',
      xp: 10,
    ));

    return out;
  }

  int _pct(String v) {
    final m = RegExp(r'(\d+)').firstMatch(v.replaceAll('%', ''));
    return m == null ? 100 : int.tryParse(m.group(1)!) ?? 100;
  }
}

class _GenMission {
  const _GenMission({
    required this.id,
    required this.title,
    required this.pillar,
    required this.xp,
  });
  final String id;
  final String title;
  final String pillar;
  final int xp;
}
