import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/xp/application/variable_rewards.dart';

void main() {
  group('VariableRewardEngine', () {
    late VariableRewardEngine engine;

    setUp(() {
      engine = VariableRewardEngine();
    });

    test('applyXpBonus returns multiplier results', () {
      for (int i = 0; i < 100; i++) {
        final bonus = engine.applyXpBonus(100);
        expect(bonus, greaterThanOrEqualTo(100));
        expect(bonus, lessThanOrEqualTo(300));
      }
    });

    test('bonusGems returns 0-3 gems', () {
      for (int i = 0; i < 200; i++) {
        final gems = engine.bonusGems();
        expect(gems, greaterThanOrEqualTo(0));
        expect(gems, lessThanOrEqualTo(3));
      }
    });

    test('luckyFragmentDrop is sometimes true', () {
      int trueCount = 0;
      for (int i = 0; i < 500; i++) {
        if (engine.luckyFragmentDrop) trueCount++;
      }
      // Should fire at least once in 500 tries (8% chance)
      expect(trueCount, greaterThan(0));
      // Should not be too common
      expect(trueCount, lessThan(150));
    });

    test('streakRecoveryLuck is sometimes true', () {
      int trueCount = 0;
      for (int i = 0; i < 500; i++) {
        if (engine.streakRecoveryLuck) trueCount++;
      }
      expect(trueCount, greaterThan(0));
    });

    test('rewardDelay is reasonable', () {
      for (int i = 0; i < 100; i++) {
        final delay = engine.rewardDelay;
        expect(delay.inMilliseconds, greaterThanOrEqualTo(300));
        expect(delay.inMilliseconds, lessThan(1000));
      }
    });
  });
}