import 'package:flutter_test/flutter_test.dart';

/// We test the quest pool logic by replicating the pool definition.
/// The actual repository depends on Drift, but the template pool is pure Dart.
void main() {
  group('Daily Quest pool', () {
    // Mirrors the pool from quest_repository.dart
    final pool = [
      ('Review class notes', 'Spend 15 minutes reviewing your notes', 25),
      ('Practice a problem', 'Solve one practice question', 30),
      ('Read an article', 'Read one educational article', 20),
      ('Quiz yourself', 'Test yourself on recent material', 35),
      ('Teach someone', 'Explain a concept to a friend', 40),
      ('Watch an educational video', 'Watch a tutorial or lecture', 20),
      ('Organize your notes', 'Clean up and organize your study notes', 25),
      ('Set tomorrow\'s goal', 'Plan what to study tomorrow', 15),
      ('Flashcard review', 'Review 10 flashcards', 25),
      ('Study competition material', 'Practice competition-specific content', 35),
      ('Write a summary', 'Summarize what you learned today', 30),
      ('Take a timed quiz', 'Time yourself on practice questions', 40),
      ('Research a topic', 'Spend 15 min researching something new', 25),
      ('Mind map', 'Create a mind map of a subject', 30),
      ('Peer review', 'Review a classmate\'s work', 35),
    ];

    test('pool has 15 templates', () {
      expect(pool.length, 15);
    });

    test('all templates have non-empty titles and descriptions', () {
      for (final (title, desc, xp) in pool) {
        expect(title.isNotEmpty, true);
        expect(desc.isNotEmpty, true);
        expect(xp, greaterThan(0));
      }
    });

    test('XP rewards range from 15 to 40', () {
      final xps = pool.map((t) => t.$3).toList();
      expect(xps.reduce((a, b) => a < b ? a : b), 15);
      expect(xps.reduce((a, b) => a > b ? a : b), 40);
    });

    test('taking 3 from shuffled pool yields 3 unique titles', () {
      final shuffled = List.of(pool)..shuffle();
      final selected = shuffled.take(3).toList();
      final titles = selected.map((t) => t.$1).toSet();
      expect(titles.length, 3);
    });

    test('taking 3 from pool never exceeds pool size', () {
      final selected = pool.take(3).toList();
      expect(selected.length, 3);
      expect(selected.length, lessThanOrEqualTo(pool.length));
    });
  });
}
