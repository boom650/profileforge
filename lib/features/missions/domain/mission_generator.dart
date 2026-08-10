import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// Turns a captured [OnboardingProfile] into *personalized* missions —
/// not blind templates. This is what makes the app feel like it knows you.
class MissionGenerator {
  const MissionGenerator();

  /// Daily mission set derived from the user's real context.
  ///
  /// [psych] (when available) adapts XP sizing, framing, and mission mix to
  /// the student's self-efficacy, autonomy, conscientiousness, and motivation
  /// frame — the rule tier's answer to the AI tier's `psychHint`. Psychology
  /// must shape the loop, not just the chat tone.
  List<GenMission> generateDaily(
    OnboardingProfile p,
    String profileId, [
    PsychologicalProfile? psych,
  ]) {
    final out = <GenMission>[];
    var i = 0;
    String id(String tag) => 'd-$profileId-$tag-${DateTime.now().day}-${i++}';

    // Psych-calibrated XP scaler: low self-efficacy / low conscientiousness →
    // smaller, more achievable wins (self-determination: competence first);
    // high self-efficacy → stretch targets.
    final xpScale = _xpScale(psych);

    // 1) Weakest subject (lowest grade %) → study mission.
    if (p.grades.isNotEmpty) {
      final weakest = p.grades.entries
          .reduce((a, b) => _pct(a.value) <= _pct(b.value) ? a : b);
      out.add(GenMission(
        id: id('weak'),
        title: _lowEfficacyPrefix(psych) +
            'Spend ${_studyMinutes(psych)} strengthening ${weakest.key} (you\'re at ${weakest.value})',
        pillar: 'academics',
        xp: _scaled(15, xpScale),
      ));
    }

    // 2) Strongest subject → teach / make a resource (leadership + academics).
    if (p.grades.isNotEmpty) {
      final strongest = p.grades.entries
          .reduce((a, b) => _pct(a.value) >= _pct(b.value) ? a : b);
      out.add(GenMission(
        id: id('teach'),
        title: 'Make a 1-page study guide for ${strongest.key} to help a peer',
        pillar: 'leadership',
        xp: _scaled(20, xpScale),
      ));
    }

    // 3) A target university → research its admission essay prompt.
    if (p.targetUniversities.isNotEmpty) {
      final u = p.targetUniversities.first;
      out.add(GenMission(
        id: id('uni'),
        title: 'Draft an outline for $u\'s admission essay prompt',
        pillar: 'academics',
        xp: _scaled(25, xpScale),
      ));
    }

    // 4) Competitions: if few/none, prompt to find one; else go deeper.
    if (p.competitions.isEmpty) {
      out.add(GenMission(
        id: id('comp'),
        title: 'Find 1 Olympiad / competition in ${p.subjects.firstOrEmpty} and note its deadline',
        pillar: 'research',
        xp: _scaled(20, xpScale),
      ));
    } else {
      out.add(GenMission(
        id: id('comp2'),
        title: 'Prep 1 hour for ${p.competitions.first.name} (you placed ${p.competitions.first.result})',
        pillar: 'research',
        xp: _scaled(25, xpScale),
      ));
    }

    // 5) Activities: if none, start one; else document & reflect.
    if (p.activities.isEmpty) {
      out.add(GenMission(
        id: id('act'),
        title: 'Join or start 1 club / society this week',
        pillar: 'community',
        xp: _scaled(20, xpScale),
      ));
    } else {
      out.add(GenMission(
        id: id('act2'),
        title: 'Write a 200-word reflection on: ${p.activities.first}',
        pillar: 'creativity',
        xp: _scaled(15, xpScale),
      ));
    }

    // 6) Career interest → informational interview / read.
    if (p.careerInterests.isNotEmpty) {
      out.add(GenMission(
        id: id('career'),
        title: 'Read 1 article or watch a talk about ${p.careerInterests.first}',
        pillar: 'research',
        xp: _scaled(15, xpScale),
      ));
    }

    // 7) Always: a small wellbeing / consistency task.
    out.add(GenMission(
      id: id('well'),
      title: _structureAwareTitle(psych),
      pillar: 'personal',
      xp: _scaled(10, xpScale),
    ));

    // 8) Autonomy support (SDT): self-directed students get an open choice
    // mission — the loop hands the wheel back instead of dictating.
    final autonomy = psych?.autonomy ?? 0.5;
    if (autonomy >= 0.6) {
      out.add(GenMission(
        id: id('free'),
        title: 'Choose ONE thing that moves your application forward today — your call',
        pillar: 'creativity',
        xp: _scaled(15, xpScale),
      ));
    }

    // 9) Relatedness / community (SDT): socially-driven students get a
    // collaboration mission when the profile asks for it.
    final relatedness = psych?.relatedness ?? 0.5;
    if (relatedness >= 0.6) {
      out.add(GenMission(
        id: id('peer'),
        title: 'Study with a friend or join a shared focus session for 30 min',
        pillar: 'community',
        xp: _scaled(15, xpScale),
      ));
    }

    return out;
  }

  /// XP multiplier by self-efficacy: low efficacy → gentler curve (competence
  /// via achievable wins), high efficacy → stretch rewards.
  double _xpScale(PsychologicalProfile? psych) {
    if (psych == null) return 1.0;
    final se = psych.selfEfficacy;
    if (se < 0.4) return 0.6;
    if (se >= 0.8) return 1.3;
    return 1.0;
  }

  int _scaled(int xp, double scale) => (xp * scale).round().clamp(5, 40);

  /// Low self-efficacy → smaller first step ("Start with 15 min…") so the
  /// loop feeds a win, per self-efficacy research (03-as).
  String _lowEfficacyPrefix(PsychologicalProfile? psych) {
    if (psych == null || psych.selfEfficacy >= 0.4) return '';
    return 'Start with 15 min: ';
  }

  /// Low conscientiousness → concrete planning step; else open reflection.
  String _structureAwareTitle(PsychologicalProfile? psych) {
    final c = psych?.conscientiousness ?? 0.5;
    if (c < 0.4) {
      return 'Plan tomorrow\'s ONE most important task now (30 sec)';
    }
    return 'Plan your week in 5 minutes and block study time';
  }

  int _studyMinutes(PsychologicalProfile? psych) {
    final se = psych?.selfEfficacy ?? 0.5;
    if (se < 0.4) return 15;
    if (se >= 0.8) return 60;
    return 30;
  }

  int _pct(String v) {
    final m = RegExp(r'(\d+)').firstMatch(v.replaceAll('%', ''));
    return m == null ? 100 : int.tryParse(m.group(1)!) ?? 100;
  }
}

class GenMission {
  const GenMission({
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

extension _FirstOrEmpty<T> on List<T> {
  T get firstOrEmpty => isEmpty ? ('' as T) : first;
}
