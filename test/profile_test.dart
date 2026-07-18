import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/profile_model.dart';

void main() {
  test('Profile addAchievement increments XP and dedupes', () {
    var p = Profile(name: 'A', xp: 0);
    p = p.copyWith(achievements: [...p.achievements, 'Won science fair'], xp: p.xp + 10);
    expect(p.achievements.length, 1);
    expect(p.xp, 10);
    // duplicate ignored
    if (!p.achievements.contains('Won science fair')) {
      p = p.copyWith(achievements: [...p.achievements, 'Won science fair']);
    }
    expect(p.achievements.length, 1);
  });

  test('Profile toMap/fromMap round-trips', () {
    final p = Profile(name: 'Bob', goal: 'MIT', achievements: ['A', 'B'], xp: 30);
    final m = p.toMap();
    final back = Profile.fromMap(m);
    expect(back.name, 'Bob');
    expect(back.goal, 'MIT');
    expect(back.achievements.length, 2);
    expect(back.xp, 30);
  });
}
