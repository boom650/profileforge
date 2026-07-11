import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/profile.dart';

void main() {
  group('Profile Model', () {
    test('creates with required fields', () {
      const profile = Profile(
        id: 'test-1',
        name: 'Test User',
        email: 'test@example.com',
      );
      expect(profile.id, equals('test-1'));
      expect(profile.name, equals('Test User'));
      expect(profile.email, equals('test@example.com'));
    });

    test('copyWith preserves unchanged fields', () {
      const original = Profile(
        id: 'test-1',
        name: 'Test User',
        email: 'test@example.com',
      );
      final copied = original.copyWith(name: 'New Name');
      expect(copied.id, equals('test-1'));
      expect(copied.name, equals('New Name'));
      expect(copied.email, equals('test@example.com'));
    });

    test('copyWith with no args returns same values', () {
      const original = Profile(
        id: 'test-1',
        name: 'Test User',
        email: 'test@example.com',
      );
      final copied = original.copyWith();
      expect(copied, equals(original));
    });

    test('toJson/fromJson roundtrip', () {
      const original = Profile(
        id: 'test-1',
        name: 'Test User',
        email: 'test@example.com',
      );
      final json = original.toJson();
      final restored = Profile.fromJson(json);
      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.email, equals(original.email));
    });
  });
}
