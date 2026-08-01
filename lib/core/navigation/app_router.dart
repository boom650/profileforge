import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/features/home/home_page.dart';
import 'package:profileforge/features/missions/presentation/missions_screen.dart';
import 'package:profileforge/features/leagues/presentation/leagues_screen.dart';
import 'package:profileforge/features/buddy/presentation/buddies_screen.dart';
import 'package:profileforge/features/skins/presentation/skins_screen.dart';
import 'package:profileforge/features/teams/presentation/teams_screen.dart';
import 'package:profileforge/features/discovery/presentation/discover_screen.dart';
import 'package:profileforge/features/rewards/presentation/rewards_screen.dart';
import 'package:profileforge/features/profile/presentation/profile_screen.dart';
import 'package:profileforge/features/profile/presentation/profile_page.dart';
import 'package:profileforge/features/profile/presentation/badges_page.dart';
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';
import 'package:profileforge/features/timer/presentation/timer_screen.dart';
import 'package:profileforge/features/analytics/presentation/analytics_screen.dart';
import 'package:profileforge/features/achievements/presentation/achievements_screen.dart';
import 'package:profileforge/features/quests/presentation/quests_screen.dart';
import 'package:profileforge/features/goals/presentation/goal_screen.dart';
import 'package:profileforge/features/challenges/presentation/challenges_screen.dart';
import 'package:profileforge/features/summary/presentation/weekly_summary_screen.dart';
import 'package:profileforge/features/share/presentation/share_screen.dart';
import 'package:profileforge/features/calendar/presentation/calendar_screen.dart';
import 'package:profileforge/features/geo/presentation/geo_screen.dart';
// New v2 screens.
import 'package:profileforge/features/splash/presentation/splash_screen.dart';
import 'package:profileforge/features/auth/presentation/welcome_screen.dart';
import 'package:profileforge/features/auth/presentation/magic_link_screen.dart';
import 'package:profileforge/features/auth/presentation/auth_prompt_screen.dart';
import 'package:profileforge/features/ai_chat/presentation/ai_chat_screen.dart';
import 'package:profileforge/features/ai_chat/presentation/artifact_analyzer_screen.dart';
import 'package:profileforge/features/ai_chat/presentation/ai_settings_screen.dart';
import 'package:profileforge/features/ai_chat/presentation/readiness_check_screen.dart';

/// A slide-from-right page transition for GoRouter routes.
Page<Object> _slidePage(Widget child) {
  return CustomTransitionPage<Object>(
    child: child,
    transitionsBuilder: (c, a, s, ch) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
      child: ch,
    ),
  );
}

/// Fade transition for auth/splash screens.
Page<Object> _fadePage(Widget child) {
  return CustomTransitionPage<Object>(
    child: child,
    transitionsBuilder: (c, a, s, ch) => FadeTransition(
      opacity: a,
      child: ch,
    ),
  );
}

/// Shorthand: create a GoRoute with a slide transition.
GoRoute _route(String path, Widget Function(BuildContext, GoRouterState) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (c, s) => _slidePage(builder(c, s)),
  );
}

/// Scale transition for achievements/celebration screens.
GoRoute _scaleRoute(String path, Widget Function(BuildContext, GoRouterState) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (c, s) => CustomTransitionPage<Object>(
      child: builder(c, s),
      transitionsBuilder: (c, a, s, ch) => ScaleTransition(
        scale: CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
        child: FadeTransition(opacity: a, child: ch),
      ),
    ),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final profileId = ref.watch(activeProfileIdProvider);
  final pid = profileId.value ?? 'local-profile';
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth & splash (fade transitions).
      GoRoute(
        path: '/splash',
        pageBuilder: (c, s) => _fadePage(const SplashScreen()),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (c, s) => _fadePage(const WelcomeScreen()),
      ),
      GoRoute(
        path: '/magic-link',
        pageBuilder: (c, s) => _fadePage(const MagicLinkScreen()),
      ),
      GoRoute(
        path: '/auth-prompt',
        pageBuilder: (c, s) => _fadePage(const AuthPromptScreen()),
      ),

      // Main app routes (slide transitions).
      _route('/home', (c, s) => HomePage(profileId: pid)),
      _route('/missions', (c, s) => MissionsScreen(profileId: pid)),
      _route('/leagues', (c, s) => LeaguesScreen(profileId: pid)),
      _route('/buddies', (c, s) => BuddiesScreen(profileId: pid)),
      _route('/skins', (c, s) => SkinsScreen(profileId: pid)),
      _route('/teams', (c, s) => TeamsScreen(profileId: pid)),
      _route('/discover', (c, s) => DiscoverScreen(profileId: pid)),
      _route('/rewards', (c, s) => RewardsScreen(profileId: pid)),
      _route('/profile', (c, s) => ProfileScreen(profileId: pid)),
      _route('/profile/edit', (c, s) => ProfilePage(profileId: pid)),
      _route('/badges', (c, s) => BadgesPage(profileId: pid)),
      _route('/onboarding', (c, s) => OnboardingScreen(profileId: pid)),
      _route('/timer', (c, s) => TimerScreen(profileId: pid)),
      _route('/analytics', (c, s) => AnalyticsScreen(profileId: pid)),
      _scaleRoute('/achievements', (c, s) => AchievementsScreen(profileId: pid)),
      _route('/quests', (c, s) => QuestsScreen(profileId: pid)),
      _route('/goal', (c, s) => GoalScreen(profileId: pid)),
      _route('/challenges', (c, s) => ChallengesScreen(profileId: pid)),
      _scaleRoute('/summary', (c, s) => WeeklySummaryScreen(profileId: pid)),
      _route('/share', (c, s) => ShareProgressScreen(profileId: pid)),
      _route('/calendar', (c, s) => const CalendarScreen()),
      _route('/geo', (c, s) => const GeoScreen(location: 'Singapore')),
      // AI features
      _route('/ai-chat', (c, s) => const AiChatScreen()),
      _route('/ai-analyzer', (c, s) => const ArtifactAnalyzerScreen()),
      _route('/ai-settings', (c, s) => const AiSettingsScreen()),
      _route('/ai-readiness', (c, s) => const ReadinessCheckScreen()),
    ],
  );
});
