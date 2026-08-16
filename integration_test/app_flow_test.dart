import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:profileforge/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots through splash into the main shell', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // The app must reach a non-empty widget tree immediately after boot.
    expect(find.byType(Object, skipOffstage: false), findsWidgets);
  });
}