import 'package:flutter_test/flutter_test.dart';

import 'package:profileforge/main.dart';

void main() {
  testWidgets('ProfileForge smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileForgeApp());
    await tester.pump();

    expect(find.text('ProfileForge'), findsOneWidget);
    expect(find.text('Gamified College Admissions Profile Builder'), findsOneWidget);
  });
}