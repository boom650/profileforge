import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Profile data model stored in Hive. Continuous-improvement cycle extends this.
class Profile {
  final String name;
  final String goal;
  final List<String> achievements;
  final int xp;

  Profile({
    this.name = '',
    this.goal = '',
    this.achievements = const [],
    this.xp = 0,
  });

  Profile copyWith({
    String? name,
    String? goal,
    List<String>? achievements,
    int? xp,
  }) {
    return Profile(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      achievements: achievements ?? this.achievements,
      xp: xp ?? this.xp,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'goal': goal,
        'achievements': achievements,
        'xp': xp,
      };

  factory Profile.fromMap(Map<dynamic, dynamic> map) => Profile(
        name: map['name']?.toString() ?? '',
        goal: map['goal']?.toString() ?? '',
        achievements: List<String>.from(map['achievements'] ?? []),
        xp: map['xp']?.toInt() ?? 0,
      );
}

final profileBoxProvider = Provider<Box>((ref) => Hive.box('profileBox'));

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile>((ref) {
  final box = ref.watch(profileBoxProvider);
  return ProfileNotifier(box);
});

class ProfileNotifier extends StateNotifier<Profile> {
  final Box _box;
  ProfileNotifier(this._box)
      : super(Profile.fromMap(Map<String, dynamic>.from(_box.get('profile', defaultValue: {}))));

  void update(Profile next) {
    state = next;
    _box.put('profile', next.toMap());
  }

  void addAchievement(String a) {
    if (a.trim().isEmpty || state.achievements.contains(a)) return;
    update(state.copyWith(achievements: [...state.achievements, a], xp: state.xp + 10));
  }

  void setName(String v) => update(state.copyWith(name: v));
  void setGoal(String v) => update(state.copyWith(goal: v));
}
