import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/profile/domain/profile.dart';

void main() {
  test('Profile.addAchievement appends and dedupes', () {
    var p = const Profile(id: 'a');
    p = p.addAchievement('Won science fair');
    expect(p.achievements.length, 1);
    // duplicate is ignored
    p = p.addAchievement('Won science fair');
    expect(p.achievements.length, 1);
    // empty/whitespace ignored
    p = p.addAchievement('   ');
    expect(p.achievements.length, 1);
  });

  test('Profile copyWith preserves identity fields', () {
    const p = Profile(id: 'bob', name: 'Bob', goal: 'MIT');
    final next = p.copyWith(name: 'Bobby');
    expect(next.id, 'bob');
    expect(next.name, 'Bobby');
    expect(next.goal, 'MIT');
  });
}
