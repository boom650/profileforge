import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/features/home/home_page.dart';
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';
final routerProvider = Provider<GoRouter>((ref) {
  final profileId = ref.watch(activeProfileIdProvider);
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (c, s) => HomePage(profileId: profileId.value ?? 'local-profile'),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (c, s) =>
            OnboardingScreen(profileId: profileId.value ?? 'local-profile'),
      ),
    ],
  );
});
