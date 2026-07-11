import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/ui/screens/targets/weekly_targets_screen.dart';
import 'package:profileforge/ui/screens/targets/weekly_targets_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('WeeklyTargetsScreen', () {
    testWidgets('renders app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WeeklyTargetsScreen(),
          ),
        ),
      );
      expect(find.text('Weekly Targets'), findsOneWidget);
    });

    testWidgets('shows add target FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WeeklyTargetsScreen(),
          ),
        ),
      );
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}