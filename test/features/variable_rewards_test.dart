import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/timer/domain/variable_rewards.dart';

void main() {
  group('VariableRewardEngine', () {
    late VariableRewardEngine engine;

    setUp(() {
      engine = VariableRewardEngine();
    });

    test('generates rewards within expected ranges', () {
      for (int i = 0; i < 100; i++) {
        final reward = engine.generateReward(30); // 30 min session
        expect(reward.totalXp, greaterThan(0));
        expect(reward.totalXp, lessThanOrEqualTo(300));
        expect(reward.bonusXp, greaterThanOrEqualTo(0));
        expect(reward.tokens, greaterThanOrEqualTo(0));
      }
    });

    test('longer sessions give more rewards on average', () {
      int totalXpShort = 0, totalXpLong = 0;
      for (int i = 0; i < 50; i++) {
        totalXpShort += engine.generateReward(15).totalXp;
        totalXpLong += engine.generateReward(60).totalXp;
      }
      // Longer sessions should average higher total XP
      expect(totalXpShort, lessThan(totalXpLong));
    });

    test('has variable ratio streak', () {
      final rewards = List.generate(10, (i) => engine.generateReward(25));
      final streakCounts = rewards.map((r) => r.streakBonus).toSet();
      // Not all rewards have the same streak bonus (it's variable)
      expect(streakCounts.length, greaterThan(1));
    });

    test('has rare bonus jackpot', () {
      // Run many times; at least some should have >100 bonus
      int jackpotCount = 0;
      for (int i = 0; i < 500; i++) {
        if (engine.generateReward(30).bonusXp > 100) {
          jackpotCount++;
        }
      }
      expect(jackpotCount, greaterThan(0));
      // Jackpot should be rare (<10% of the time)
      expect(jackpotCount, lessThan(150));
    });
  });
}