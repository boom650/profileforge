import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/widgets/galaxy_chart.dart';

void main() {
  testWidgets('GalaxyChart renders with default data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Provide a default profile ID; the galaxy chart needs it
        ],
        child: MaterialApp(
          home: Scaffold(
            body: GalaxyChart(profileId: 'test-profile'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The chart should render the starfield and labels
    expect(find.text('Your galaxy'), findsNothing); // SectionTitle is outside
    expect(find.byType(GalaxyChart), findsOneWidget);
  });
}
