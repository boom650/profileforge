import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/quests/domain/quest_models.dart';

void main() {
  group('Daily Quest pool', () {
    // The single source of truth: QuestTemplate.questPool in the domain layer.
    final pool = QuestTemplate.questPool;

    test('pool has 15 templates', () {
      expect(pool.length, 15);
    });

    test('all templates have non-empty titles and descriptions', () {
      for (final t in pool) {
        expect(t.title.isNotEmpty, true);
        expect(t.description.isNotEmpty, true);
        expect(t.xp, greaterThan(0));
      }
    });

    test('XP rewards range from 15 to 40', () {
      final xps = pool.map((t) => t.xp).toList();
      expect(xps.reduce((a, b) => a < b ? a : b), 15);
      expect(xps.reduce((a, b) => a > b ? a : b), 40);
    });

    test('taking 3 from shuffled pool yields 3 unique titles', () {
      final shuffled = List.of(pool)..shuffle();
      final selected = shuffled.take(3).toList();
      final titles = selected.map((t) => t.title).toSet();
      expect(titles.length, 3);
    });

    test('taking 3 from pool never exceeds pool size', () {
      final selected = pool.take(3).toList();
      expect(selected.length, 3);
      expect(selected.length, lessThanOrEqualTo(pool.length));
    });
  });
}