import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';

void main() {
  testWidgets('onboarding screen renders without crash', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: OnboardingScreen(profileId: 'test-profile')),
      ),
    );
    
    // Should render — at minimum there's a Scaffold
    expect(find.byType(Scaffold), findsOneWidget);
  });
}