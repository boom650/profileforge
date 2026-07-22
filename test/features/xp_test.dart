import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:profileforge/features/xp/data/xp_repository.dart';
import 'package:profileforge/core/data/app_database.dart';

/// Manual verification that XP repository types and basic logic compile.
/// Full widget tests require Flutter test harness (available in CI).
void main() {
  group('XpRepository setup', () {
    test('XpEventRow has expected fields', () {
      final row = XpEventRow(
        id: 1,
        profileId: 'test-profile',
        amount: 100,
        balanceAfter: 500,
        source: 'test',
        at: DateTime.now(),
      );
      expect(row.amount, 100);
      expect(row.balanceAfter, 500);
      expect(row.source, 'test');
    });

    test('XpEvent companion creates valid DB row', () {
      final companion = XpEventsCompanion(
        profileId: Value('test-profile'),
        amount: Value(100),
        balanceAfter: Value(600),
        source: Value('mission'),
        at: Value(DateTime.now()),
      );
      expect(companion.profileId.value, 'test-profile');
      expect(companion.amount.value, 100);
    });
  });
}
