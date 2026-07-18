import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_models.freezed.dart';

enum MissionCadence { daily, weekly, monthly, special, seasonal, university }

enum MissionPillar {
  academics,
  leadership,
  research,
  creativity,
  community,
  service,
  sports,
  personal;

  String get label => name[0].toUpperCase() + name.substring(1);
}

@freezed
class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String profileId,
    required String title,
    required MissionCadence cadence,
    required MissionPillar pillar,
    required int xpReward,
    required DateTime? dueAt,
    required bool completed,
  }) = _Mission;
}

/// Pure mission-generation engine. Maps cadence → pillar → concrete missions.
class MissionEngine {
  static const Map<MissionPillar, List<String>> _templates = {
    MissionPillar.academics: [
      'Complete 1 past exam paper',
      'Review a weak topic for 30 min',
      'Teach a concept to a peer',
    ],
    MissionPillar.leadership: [
      'Lead a club meeting',
      'Organize a study group',
      'Mentor a younger student',
    ],
    MissionPillar.research: [
      'Read 1 paper in your field',
      'Email a professor about research',
      'Draft a hypothesis for a project',
    ],
    MissionPillar.creativity: [
      'Spend 20 min on a creative project',
      'Publish a small portfolio piece',
      'Sketch a product idea',
    ],
    MissionPillar.community: [
      'Attend a school event',
      'Start a community channel',
      'Help organize a workshop',
    ],
    MissionPillar.service: [
      'Log 1 hour of volunteering',
      'Plan a service initiative',
      'Support a local NGO',
    ],
    MissionPillar.sports: [
      'Train for 30 min',
      'Join a intramural match',
      'Set a fitness goal',
    ],
    MissionPillar.personal: [
      'Plan your week',
      'Reflect on a win',
      'Sleep 8 hours',
    ],
  };

  static const Map<MissionCadence, int> _rewards = {
    MissionCadence.daily: 10,
    MissionCadence.weekly: 40,
    MissionCadence.monthly: 120,
    MissionCadence.special: 60,
    MissionCadence.seasonal: 200,
    MissionCadence.university: 150,
  };

  /// Generate the daily mission set (one per pillar, 8 missions).
  List<Mission> generateDaily(String profileId) {
    final pillars = MissionPillar.values;
    return [
      for (final p in pillars)
        Mission(
          id: 'd-${profileId}-${p.name}',
          profileId: profileId,
          title: _templates[p]!.first,
          cadence: MissionCadence.daily,
          pillar: p,
          xpReward: _rewards[MissionCadence.daily]!,
          dueAt: DateTime.now().add(const Duration(days: 1)),
          completed: false,
        ),
    ];
  }

  /// University-specific mission for a target school.
  Mission universityMission(String profileId, String university) => Mission(
        id: 'u-${profileId}-$university',
        profileId: profileId,
        title: 'Research $university\'s admission essay prompt',
        cadence: MissionCadence.university,
        pillar: MissionPillar.academics,
        xpReward: _rewards[MissionCadence.university]!,
        dueAt: DateTime.now().add(const Duration(days: 7)),
        completed: false,
      );

  /// The single next-due incomplete mission.
  Mission? nextDue(List<Mission> missions, DateTime now) {
    final open = missions.where((m) => !m.completed).toList()
      ..sort((a, b) => (a.dueAt ?? DateTime(0)).compareTo(b.dueAt ?? DateTime(0)));
    return open.isEmpty ? null : open.first;
  }
}
