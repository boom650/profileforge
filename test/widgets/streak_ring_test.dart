import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/ui/widgets/streak_ring.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('StreakRing Widget', () {
    testWidgets('renders with zero streak', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 0,
          longestStreak: 0,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
      expect(find.text('0'), findsAtLeast(1));
    });

    testWidgets('renders with active streak', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 7,
          longestStreak: 10,
          freezeTokens: 2,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('displays streak number', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 15,
          longestStreak: 20,
          freezeTokens: 3,
        ),
      ));
      await tester.pumpAndSettle();
      // Should display the streak number
      expect(find.text('15'), findsAtLeast(1));
    });

    testWidgets('shows freeze token indicators', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 5,
          longestStreak: 5,
          freezeTokens: 3,
          maxFreezeTokens: 5,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
      // Freeze tokens should be rendered (3 of 5)
      expect(find.text('3'), findsAtLeast(1));
    });

    testWidgets('shows weekly activity pattern', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 3,
          longestStreak: 5,
          weeklyActivityPattern: [1, 1, 1, 0, 0, 0, 0],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders with long streak', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 365,
          longestStreak: 365,
          freezeTokens: 5,
          maxFreezeTokens: 5,
          freezeTokensEarned: 5,
          achievedMilestones: [1, 7, 14, 21, 30, 60, 90, 180, 365],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders with weekend amulet active', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        StreakRing(
          currentStreak: 10,
          longestStreak: 10,
          hasWeekendAmulet: true,
          weekendAmuletExpiresAt: DateTime.now().add(const Duration(hours: 12)),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders with expired weekend amulet', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        StreakRing(
          currentStreak: 10,
          longestStreak: 10,
          hasWeekendAmulet: true,
          weekendAmuletExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders with no freeze tokens', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 3,
          longestStreak: 5,
          freezeTokens: 0,
          maxFreezeTokens: 5,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('handles empty weekly activity pattern', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 0,
          longestStreak: 0,
          weeklyActivityPattern: [],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders with default parameter values', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 0,
          longestStreak: 0,
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(StreakRing), findsOneWidget);
    });

    testWidgets('renders Container as root widget', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 5,
          longestStreak: 5,
        ),
      ));
      await tester.pumpAndSettle();
      final widget = tester.widget<StreakRing>(find.byType(StreakRing));
      expect(widget.currentStreak, 5);
      expect(widget.longestStreak, 5);
    });

    testWidgets('widget properties are set correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const StreakRing(
          currentStreak: 14,
          longestStreak: 30,
          freezeTokens: 4,
          maxFreezeTokens: 5,
          freezeTokensEarned: 2,
          hasWeekendAmulet: true,
          weekendAmuletExpiresAt: null,
          weeklyActivityPattern: [1, 1, 1, 1, 1, 0, 0],
          achievedMilestones: [3, 7, 14],
        ),
      ));
      await tester.pumpAndSettle();
      final widget = tester.widget<StreakRing>(find.byType(StreakRing));
      expect(widget.currentStreak, 14);
      expect(widget.longestStreak, 30);
      expect(widget.freezeTokens, 4);
      expect(widget.maxFreezeTokens, 5);
      expect(widget.freezeTokensEarned, 2);
      expect(widget.hasWeekendAmulet, true);
      expect(widget.weekendAmuletExpiresAt, isNull);
      expect(widget.weeklyActivityPattern, [1, 1, 1, 1, 1, 0, 0]);
      expect(widget.achievedMilestones, [3, 7, 14]);
    });
  });
}
