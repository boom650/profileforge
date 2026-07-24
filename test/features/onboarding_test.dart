import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';
import 'package:profileforge/features/onboarding/presentation/widgets/step_name_schedule.dart';
import 'package:profileforge/features/onboarding/presentation/widgets/step_energy_style.dart';
import 'package:profileforge/features/onboarding/presentation/widgets/step_goals.dart';
import 'package:profileforge/features/onboarding/presentation/widgets/step_notifications.dart';

void main() {
  group('Onboarding Screen', () {
    testWidgets('renders onboarding without crash', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );
      
      // Should show the first step
      expect(find.byType(Stepper), findsOneWidget);
      
      // Navigate to step 2
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
    });

    testWidgets('step widgets render', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepNameSchedule()),
        ),
      );
      expect(find.text('What should we call you?'), findsOneWidget);
      
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepEnergyStyle()),
        ),
      );
      expect(find.text('When do you study best?'), findsOneWidget);
      
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepGoals()),
        ),
      );
      expect(find.text('What are your goals?'), findsOneWidget);
      
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: StepNotifications()),
        ),
      );
      expect(find.text('Almost done!'), findsOneWidget);
    });
  });
}