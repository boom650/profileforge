import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/features/home/home_page.dart';
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final profileId = ref.watch(activeProfileIdProvider);
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (c, s) => HomePage(profileId: profileId),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (c, s) => OnboardingScreen(profileId: profileId),
      ),
    ],
  );
});
