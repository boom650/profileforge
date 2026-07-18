import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/features/profile/presentation/badges_page.dart';
import 'package:profileforge/features/profile/presentation/profile_page.dart';
import 'package:profileforge/features/streak/presentation/streak_card.dart';
import 'package:profileforge/features/home/home_page.dart';

/// Central router. Offline-first; all routes resolve to local features.
final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(activeProfileIdProvider);
  final id = session.valueOrNull ?? 'local-profile';
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => HomePage(profileId: id)),
      GoRoute(
        path: '/profile',
        builder: (c, s) => ProfilePage(profileId: id),
      ),
      GoRoute(
        path: '/badges',
        builder: (c, s) => BadgesPage(profileId: id),
      ),
    ],
  );
});
