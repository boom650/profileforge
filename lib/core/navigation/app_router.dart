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
import 'package:profileforge/features/onboarding/presentation/onboarding_screen.dart';
import 'package:profileforge/features/timer/presentation/timer_screen.dart';
import 'package:profileforge/features/analytics/presentation/analytics_screen.dart';
import 'package:profileforge/features/achievements/presentation/achievements_screen.dart';
import 'package:profileforge/features/quests/presentation/quests_screen.dart';
import 'package:profileforge/features/goals/presentation/goal_screen.dart';
import 'package:profileforge/features/challenges/presentation/challenges_screen.dart';
import 'package:profileforge/features/summary/presentation/weekly_summary_screen.dart';
import 'package:profileforge/features/share/presentation/share_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final profileId = ref.watch(activeProfileIdProvider);
  final pid = profileId.value ?? 'local-profile';
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (c, s) => HomePage(profileId: pid)),
      GoRoute(path: '/missions', builder: (c, s) => MissionsScreen(profileId: pid)),
      GoRoute(path: '/leagues', builder: (c, s) => LeaguesScreen(profileId: pid)),
      GoRoute(path: '/buddies', builder: (c, s) => BuddiesScreen(profileId: pid)),
      GoRoute(path: '/skins', builder: (c, s) => SkinsScreen(profileId: pid)),
      GoRoute(path: '/teams', builder: (c, s) => TeamsScreen(profileId: pid)),
      GoRoute(path: '/discover', builder: (c, s) => DiscoverScreen(profileId: pid)),
      GoRoute(path: '/rewards', builder: (c, s) => RewardsScreen(profileId: pid)),
      GoRoute(path: '/profile', builder: (c, s) => ProfileScreen(profileId: pid)),
      GoRoute(path: '/onboarding', builder: (c, s) => OnboardingScreen(profileId: pid)),
      // New feature routes
      GoRoute(path: '/timer', builder: (c, s) => TimerScreen(profileId: pid)),
      GoRoute(path: '/analytics', builder: (c, s) => AnalyticsScreen(profileId: pid)),
      GoRoute(path: '/achievements', builder: (c, s) => AchievementsScreen(profileId: pid)),
      GoRoute(path: '/quests', builder: (c, s) => QuestsScreen(profileId: pid)),
      GoRoute(path: '/goal', builder: (c, s) => GoalScreen(profileId: pid)),
      GoRoute(path: '/challenges', builder: (c, s) => ChallengesScreen(profileId: pid)),
      GoRoute(path: '/summary', builder: (c, s) => WeeklySummaryScreen(profileId: pid)),
      GoRoute(path: '/share', builder: (c, s) => ShareProgressScreen(profileId: pid)),
    ],
  );
});
