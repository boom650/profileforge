import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

/// Student admission profile. Immutable domain model.
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    @Default('') String name,
    @Default('') String goal,
    @Default([]) List<String> achievements,
  }) = _Profile;

  const Profile._();

  Profile addAchievement(String a) {
    final v = a.trim();
    if (v.isEmpty || achievements.contains(v)) return this;
    return copyWith(achievements: [...achievements, v]);
  }
}
