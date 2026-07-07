import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../settings/privacy_screen.dart';
import '../essay/essay_coach_screen.dart';
import '../settings/settings_screen.dart';
import '../targets/weekly_targets_screen.dart';
import '../../../providers/app_providers.dart';
import '../../../models/student_profile.dart';
import '../../../models/gamification/skins.dart';
import '../../widgets/streak_ring.dart';
import '../../widgets/probability_radar.dart';
import '../../widgets/mission_card.dart' hide SkinShowcaseCompact;
import '../../widgets/skin_showcase.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/micro_interactions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/gamification/missions.dart';
import '../../../services/spike_framework.dart';
import '../../../services/opportunity_feed.dart';
import '../../../services/ngo_darpan_service.dart';
import '../../../services/location_service.dart';
import '../../../services/overpass_service.dart';
import '../../../services/competition_calendar_service.dart';
import '../../widgets/empty_state.dart' as empty_state;
import '../courses/courses_screen.dart';
import '../chat/chat_screen.dart';
import '../university/university_browser.dart';
import '../university/university_matcher.dart';
import '../competitions/competition_calendar.dart';
import '../research/research_milestones.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late final List<Widget> _pages;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardTab(onTabChange: _switchTab),
      const MissionsTab(),
      const OpportunitiesTab(),
      const CoursesScreen(),
      const SkinsTab(),
      ProfileTab(onTabChange: _switchTab),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _ChatFAB(onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ChatScreen(),
          ),
        );
      }),
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            HapticFeedback.lightImpact();
            setState(() => _currentIndex = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          animationDuration: const Duration(milliseconds: 400),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded),
              label: 'Missions',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school_rounded),
              label: 'Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events_rounded),
              label: 'Skins',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to compute time-of-day greeting.
String _greetingForHour(int hour) {
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

class DashboardTab extends ConsumerWidget {
  final ValueChanged<int> onTabChange;

  const DashboardTab({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakStateProvider);
    final xp = ref.watch(totalXPProvider);
    final currentSkin = ref.watch(currentSkinProvider);
    final missions = ref.watch(missionsProvider);
    final factorBreakdown = ref.watch(factorBreakdownProvider);
    final admissionsProbability = ref.watch(admissionsProbabilityProvider);
    final topSpikes = ref.watch(topSpikesProvider(3));
    final onboardingData = ref.watch(onboardingDataProvider);
    final profile = ref.watch(studentProfileProvider);
    final feed = ref.watch(opportunityFeedProvider);

    // Compute dynamic greeting from user's name
    final userName = onboardingData.name.isNotEmpty
        ? onboardingData.name
        : (profile?.name ?? '');
    final greeting = _greetingForHour(DateTime.now().hour);
    final greetingText =
        userName.isNotEmpty ? '$greeting, $userName 👋' : '$greeting 👋';

    // Compute day/week from streak
    final dayText = streak.currentStreak > 0
        ? 'Week ${((streak.currentStreak - 1) ~/ 7) + 1} • Day ${((streak.currentStreak - 1) % 7) + 1}'
        : 'Start your journey!';

    // Build opportunity cards from real feed data
    final opportunityCards = <Widget>[];
    for (final ngo in feed.ngos.take(2)) {
      opportunityCards.add(OpportunityCardHorizontal(
        title: ngo.name,
        type: 'NGO Volunteering',
        tier: 2,
        distance: ngo.city,
        matchScore: 0.85,
      ));
    }
    for (final comp in feed.competitions.take(1)) {
      opportunityCards.add(OpportunityCardHorizontal(
        title: comp.name,
        type: 'Competition',
        tier: 1,
        distance: 'Online',
        matchScore: 0.80,
      ));
    }
    final displayCards = opportunityCards.take(3).toList();

    return CustomScrollView(
      slivers: [
        // App bar with greeting
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          backgroundColor: context.surfaceBg,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary,
                ),
              ),
              Text(
                dayText,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Notifications',
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              tooltip: 'Settings',
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),

        // Streak & XP Ring
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: StreakRing(
                    currentStreak: streak.currentStreak,
                    longestStreak: streak.longestStreak,
                    freezeTokens: streak.freezeTokens,
                    onCheckIn: () async {
                      HapticFeedback.heavyImpact();
                      try {
                        final result =
                            await ref.read(markDailyActiveProvider)();
                        if (context.mounted) {
                          result.when(
                            success: (streak, _, __, ___, ____, _____) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Streak updated! ${streak.currentStreak} days 🔥'),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            graceDayUsed: (streak, _, __) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Grace day used. ${streak.currentStreak} day streak 🔥'),
                                  backgroundColor: AppTheme.accentOrange,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            freezeTokenUsed: (streak, _, __) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Freeze token used. ${streak.currentStreak} day streak ❄️'),
                                  backgroundColor: AppTheme.accentTeal,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            streakBroken: (_, __, ___, ____) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Streak broken! Let\'s start fresh today 💪'),
                                  backgroundColor: AppTheme.accentOrange,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            alreadyMarked: (_, __) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Already checked in today! ✅'),
                                  backgroundColor: AppTheme.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Check-in failed. Try again.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _XPProgressCard(xp: xp, currentSkin: currentSkin.name),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ),

        // Dashboard Stats
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              children: [
                _DashboardStatCard(
                  icon: Icons.task_alt_rounded,
                  label: 'Missions',
                  value:
                      '${missions.where((m) => m.isCompleted).length}/${missions.length}',
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 12),
                _DashboardStatCard(
                  icon: Icons.explore_rounded,
                  label: 'Opportunities',
                  value: '${feed.ngos.length + feed.competitions.length}',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                _DashboardStatCard(
                  icon: Icons.star_rounded,
                  label: 'XP Earned',
                  value: '$xp',
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                _DashboardStatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Streak',
                  value: '${streak.currentStreak}d',
                  color: AppTheme.accentOrange,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ),

        // Quick Action Buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.add_task_rounded,
                    label: 'Add Activity',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTabChange(1);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.explore_rounded,
                    label: 'Find Nearby',
                    color: AppTheme.accentTeal,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTabChange(2);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.school_rounded,
                    label: 'Courses',
                    color: AppTheme.accentOrange,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTabChange(3);
                    },
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
        ),

        // Quick Action Row 2 — Targets, Competitions, Research
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.flag_rounded,
                    label: 'Targets',
                    color: AppTheme.accentPurple,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const WeeklyTargetsScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.calendar_month_rounded,
                    label: 'Competitions',
                    color: AppTheme.successGreen,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CompetitionCalendarScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.science_rounded,
                    label: 'Research',
                    color: AppTheme.accentTeal,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ResearchMilestonesScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.1),
        ),

        // Quick Action Row 3 — Universities
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
            child: Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.account_balance_rounded,
                    label: 'Universities',
                    color: AppTheme.accentPurple,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UniversityBrowserScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.compare_arrows_rounded,
                    label: 'Uni Matcher',
                    color: AppTheme.accentOrange,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UniversityMatcherScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.edit_note_rounded,
                    label: 'Essay Coach',
                    color: AppTheme.warningAmber,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EssayCoachScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
        ),

        // Location Permission Prompt
        SliverToBoxAdapter(
          child: _LocationPermissionPrompt(),
        ),

        // Admissions Probability Radar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (factorBreakdown != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Admissions Probability',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onTabChange(1); // Switch to Missions tab
                        },
                        child: Text('View All',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ProbabilityRadarChart(
                    factorBreakdown: factorBreakdown,
                    monteCarloResult: admissionsProbability.isNotEmpty
                        ? admissionsProbability.values.first.monteCarloResult
                        : null,
                    universityName: admissionsProbability.isNotEmpty
                        ? admissionsProbability.values.first.university
                        : '',
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
        ),

        // Today's Missions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Missions',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onTabChange(1); // Switch to Missions tab
                      },
                      child: Text('View All',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...missions
                    .where((m) => m.type == MissionType.daily && !m.isCompleted)
                    .take(3)
                    .map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MissionCard(mission: m),
                        )),
                if (missions
                    .where((m) => m.type == MissionType.daily && !m.isCompleted)
                    .isEmpty)
                  _EmptyMissionsCard(),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
        ),

        // Your Top Spikes
        if (topSpikes.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Top Spikes',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onTabChange(
                              1); // Switch to Missions tab (spikes are activity details)
                        },
                        child: Text('Details',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These achievements make your profile stand out',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...topSpikes.map((spike) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SpikeCard(spike: spike),
                      )),
                ],
              ),
            ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),
          ),

        // Current Skin Showcase
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Identity',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onTabChange(3); // Switch to Skins tab
                      },
                      child: Text('Gallery',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SkinShowcaseCompact(currentSkin: currentSkin),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
        ),

        // Top Opportunities
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Opportunities Near You',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onTabChange(2); // Switch to Opportunities tab
                      },
                      child: Text('Explore',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (displayCards.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: displayCards.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => displayCards[index],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTabChange(2); // Switch to Opportunities tab
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: context.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.explore_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Discover opportunities →',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
        ),
      ],
    );
  }
}

/// Shows a location permission prompt if not yet asked.
/// Once enabled, opportunities auto-discover nearby NGOs & competitions.
/// Supports both GPS and manual city entry.
class _LocationPermissionPrompt extends ConsumerStatefulWidget {
  const _LocationPermissionPrompt();

  @override
  ConsumerState<_LocationPermissionPrompt> createState() =>
      _LocationPermissionPromptState();
}

class _LocationPermissionPromptState
    extends ConsumerState<_LocationPermissionPrompt> {
  bool _asked = false;
  bool _loading = false;
  bool _dismissed = false;
  bool _showCityInput = false;
  bool _gpsEnabled = false;
  String? _currentCity;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAsked();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _checkIfAsked() async {
    final prefs = await SharedPreferences.getInstance();
    final asked = prefs.getBool('location_permission_asked') ?? false;
    final city = prefs.getString('user_city');
    final gps = prefs.getBool('gps_enabled') ?? false;
    if (mounted) {
      setState(() {
        _asked = asked;
        _currentCity = city;
        _gpsEnabled = gps;
      });
    }
  }

  /// Request GPS permission and get actual coordinates
  Future<void> _requestGPS() async {
    setState(() => _loading = true);
    try {
      final locationService = ref.read(locationServiceProvider);

      // Request permission
      final granted = await locationService.requestPermission();

      if (granted) {
        // Actually get the coordinates
        final location = await locationService.getCurrentLocation();

        if (location != null) {
          // Save to preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('location_permission_asked', true);
          await prefs.setBool('gps_enabled', true);
          await prefs.setDouble('latitude', location.latitude);
          await prefs.setDouble('longitude', location.longitude);

          // Reverse geocode to get city name
          // For now, we'll use a placeholder
          await prefs.setString('user_city', 'Your City');

          if (mounted) {
            setState(() {
              _gpsEnabled = true;
              _currentCity = 'Your City';
            });
          }

          // Trigger opportunity discovery with real location
          ref.read(opportunityFeedProvider.notifier).discover();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Location enabled! Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}'),
                backgroundColor: AppTheme.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        } else {
          // Permission granted but couldn't get location
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Permission granted but location unavailable. Try entering your city manually.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } else {
        // Permission denied - show manual entry option
        if (mounted) setState(() => _showCityInput = true);
      }

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _showCityInput = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Location error: $e. You can enter your city manually.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Save manual city entry
  Future<void> _saveCity() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('location_permission_asked', true);
      await prefs.setString('user_city', city);

      if (mounted) {
        setState(() {
          _currentCity = city;
          _showCityInput = false;
        });
      }

      // Trigger opportunity discovery with city
      ref.read(opportunityFeedProvider.notifier).searchCity(city);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('City set to $city! Finding opportunities...'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_asked', true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_asked || _dismissed) return const SizedBox.shrink();

    // Show city input mode
    if (_showCityInput) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.location_city,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter Your City',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Mumbai, Delhi, Pune',
                        hintStyle: GoogleFonts.inter(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      style: GoogleFonts.inter(fontSize: 14),
                      onSubmitted: (_) => _saveCity(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_loading)
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  else
                    FilledButton(
                      onPressed: _saveCity,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        minimumSize: const Size(0, 48),
                      ),
                      child: Text('Save',
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _showCityInput = false),
                child: Text('← Back to GPS option',
                    style: GoogleFonts.inter(fontSize: 12)),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
      );
    }

    // Main location prompt
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.location_on_rounded,
                      color: Theme.of(context).colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _gpsEnabled ? 'Location Enabled ✓' : 'Enable Location',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _gpsEnabled
                              ? AppTheme.successGreen
                              : context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _gpsEnabled
                            ? (_currentCity != null && _currentCity!.isNotEmpty
                                ? '$_currentCity • Tap to change'
                                : 'Tap to set your city')
                            : 'Find NGOs, competitions & opportunities near you',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  // GPS Enable Button
                  FilledButton.icon(
                    onPressed: _requestGPS,
                    icon: Icon(_gpsEnabled ? Icons.refresh : Icons.gps_fixed,
                        size: 16),
                    label: Text(
                      _gpsEnabled ? 'Update GPS' : 'Enable GPS',
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Manual City Entry Button
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _showCityInput = true),
                    icon: const Icon(Icons.edit_location_alt, size: 16),
                    label: Text(
                      'Enter City',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dismiss Button
                  TextButton(
                    onPressed: _dismiss,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child:
                        Text('Not now', style: GoogleFonts.inter(fontSize: 12)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
    );
  }
}

class _XPProgressCard extends StatelessWidget {
  final int xp;
  final String currentSkin;

  const _XPProgressCard({required this.xp, required this.currentSkin});

  @override
  Widget build(BuildContext context) {
    final nextThreshold = _getNextThreshold(xp);
    final progress = xp / nextThreshold;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.isDarkMode
            ? AppTheme.gradientPrimaryDark
            : AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.stars_rounded,
                    color: Theme.of(context).colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Total XP',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary,
                ),
              ),
              const Spacer(),
              CountingAnimation(
                targetValue: xp,
                builder: (context, currentValue) {
                  return Text(
                    '$currentValue / $nextThreshold',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                currentSkin.replaceAll('_', ' ').toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}% to next skin',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: context.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getNextThreshold(int xp) {
    final thresholds = [500, 1500, 2500, 5000, 5000, 5000, 5000, 15000];
    for (final t in thresholds) {
      if (xp < t) return t;
    }
    return 15000;
  }
}

class _EmptyMissionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 48, color: AppTheme.successGreen),
          const SizedBox(height: 12),
          Text(
            'All caught up! 🎉',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No daily missions pending. Check back tomorrow!',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpikeCard extends StatelessWidget {
  final Spike spike;

  const _SpikeCard({required this.spike});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.categoryColors[spike.category.colorKey] ??
        Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: categoryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                spike.category.icon,
                style: GoogleFonts.inter(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Description and meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spike.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      spike.starsDisplay,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      spike.category.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Impact score circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                '${spike.impactScore}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MissionsTab extends ConsumerStatefulWidget {
  const MissionsTab({super.key});

  @override
  ConsumerState<MissionsTab> createState() => _MissionsTabState();
}

class _MissionsTabState extends ConsumerState<MissionsTab> {
  @override
  Widget build(BuildContext context) {
    final missions = ref.watch(missionsProvider);
    final dailyMissions =
        missions.where((m) => m.type == MissionType.daily).toList();
    final weeklyMissions =
        missions.where((m) => m.type == MissionType.weekly).toList();
    final milestoneMissions =
        missions.where((m) => m.type == MissionType.milestone).toList();
    final completedCount = missions.where((m) => m.isCompleted).length;
    final totalXP = missions.fold<int>(0, (sum, m) => sum + m.xpReward);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Missions',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 16, color: AppTheme.successGreen),
                  const SizedBox(width: 4),
                  Text(
                    '$completedCount/${missions.length}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    '${totalXP} XP',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Milestones'),
            ],
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        body: TabBarView(
          children: [
            _MissionList(missions: dailyMissions),
            _MissionList(missions: weeklyMissions),
            _MissionList(missions: milestoneMissions),
          ],
        ),
      ),
    );
  }
}

class _MissionList extends ConsumerWidget {
  final List<Mission> missions;

  const _MissionList({required this.missions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (missions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt_rounded,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No missions here yet!',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Check in daily to unlock new missions and earn XP.\nStart on the Dashboard tab to keep your streak going!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: context.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              Icon(Icons.local_fire_department_rounded,
                  size: 32,
                  color: AppTheme.accentOrange.withValues(alpha: 0.6)),
            ],
          ),
        ),
      );
    }

    final pending = missions.where((m) => !m.isCompleted).toList();
    final completed = missions.where((m) => m.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary bar
        if (missions.isNotEmpty) ...[
          _MissionProgressBar(
            completed: completed.length,
            total: missions.length,
          ),
          const SizedBox(height: 16),
        ],
        // Pending missions
        ...pending.map((m) => _MissionListTile(mission: m)),
        // Completed missions
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'COMPLETED',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...completed.map((m) => _MissionListTile(mission: m)),
        ],
      ],
    );
  }
}

/// Progress bar for mission completion overview.
class _MissionProgressBar extends StatelessWidget {
  final int completed;
  final int total;

  const _MissionProgressBar({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Progress',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              Text(
                '$completed of $total',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? AppTheme.successGreen
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced mission list tile with progress bar and XP reward.
class _MissionListTile extends ConsumerWidget {
  final Mission mission;

  const _MissionListTile({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = mission.progressTarget > 0
        ? (mission.progressCurrent / mission.progressTarget).clamp(0.0, 1.0)
        : 0.0;
    final isComplete = mission.isCompleted;
    final isClaimed = mission.isClaimed;
    final diffColor = _difficultyColor(mission.difficulty, context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isComplete
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : context.borderColor,
        ),
        boxShadow: isComplete
            ? []
            : [
                BoxShadow(
                  color: diffColor.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Difficulty badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mission.difficulty.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: diffColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mission.category.name[0].toUpperCase() +
                        mission.category.name.substring(1),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                // XP reward
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stars_rounded,
                          size: 12,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 3),
                      Text(
                        '${mission.xpReward}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              mission.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isComplete ? context.textMuted : context.textPrimary,
                decoration: isComplete ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mission.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: context.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            // Progress bar
            if (mission.progressTarget > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${mission.progressCurrent}/${mission.progressTarget} ${mission.progressUnit}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isComplete
                          ? AppTheme.successGreen
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete
                        ? AppTheme.successGreen
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            // Action button row
            Row(
              children: [
                if (!isComplete && mission.progressTarget > 0)
                  FilledButton(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      await ref.read(updateMissionProgressProvider)(
                          mission.id, 1);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: const Size(0, 30),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      'Update Progress',
                      style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  )
                else if (isComplete && !isClaimed)
                  FilledButton(
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      await ref.read(claimMissionRewardProvider)(mission.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Claimed ${mission.xpReward} XP! 🎉'),
                            backgroundColor: AppTheme.successGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      minimumSize: const Size(0, 30),
                      backgroundColor: AppTheme.successGreen,
                    ),
                    child: Text(
                      'Claim XP',
                      style: GoogleFonts.inter(
                          fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  )
                else if (isClaimed)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 14, color: AppTheme.successGreen),
                        const SizedBox(width: 4),
                        Text(
                          'Claimed',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (mission.tags.isNotEmpty)
                  Text(
                    mission.tags.take(2).join(', '),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: context.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _difficultyColor(MissionDifficulty diff, BuildContext context) {
    switch (diff) {
      case MissionDifficulty.easy:
        return AppTheme.successGreen;
      case MissionDifficulty.medium:
        return Theme.of(context).colorScheme.primary;
      case MissionDifficulty.hard:
        return AppTheme.accentOrange;
      case MissionDifficulty.expert:
        return Theme.of(context).colorScheme.error;
    }
  }
}

/// Opportunities tab — real discovery using free APIs.
/// Finds NGOs, nearby places, and competitions via Overpass, NGO Darpan, etc.
class OpportunitiesTab extends ConsumerStatefulWidget {
  const OpportunitiesTab({super.key});

  @override
  ConsumerState<OpportunitiesTab> createState() => _OpportunitiesTabState();
}

class _OpportunitiesTabState extends ConsumerState<OpportunitiesTab> {
  final _cityController = TextEditingController();
  int _selectedTab = 0; // 0=All, 1=NGOs, 2=Nearby, 3=Competitions

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(opportunityFeedProvider.notifier).discover();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(opportunityFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Opportunities',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          if (feed.cityName != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 2),
                    Text(feed.cityName!,
                        style: GoogleFonts.inter(fontSize: 12)),
                  ],
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            tooltip: 'Use my location',
          ),
        ],
      ),
      body: feed.isLoading
          ? const Center(child: CircularProgressIndicator())
          : feed.error != null
              ? (feed.error!.toLowerCase().contains('location')
                  ? Column(
                      children: [
                        _buildSearchBar(),
                        Expanded(child: _buildError(feed.error!)),
                      ],
                    )
                  : _buildError(feed.error!))
              : Column(
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    // Tab bar
                    _buildTabBar(),
                    // Content
                    Expanded(child: _buildContent(feed)),
                  ],
                ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Search by city...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                isDense: true,
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref
                      .read(opportunityFeedProvider.notifier)
                      .searchCity(val.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      'All',
      'NGOs',
      'Nearby',
      'Competitions',
      'ATL Lab',
      'Scholarship'
    ];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (ctx, i) {
          final isSelected = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tabs[i]),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedTab = i),
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: GoogleFonts.inter(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              avatar: i == 0
                  ? const Icon(Icons.all_inclusive, size: 16)
                  : i == 1
                      ? const Icon(Icons.account_balance, size: 16)
                      : i == 2
                          ? const Icon(Icons.near_me, size: 16)
                          : i == 3
                              ? const Icon(Icons.emoji_events, size: 16)
                              : i == 4
                                  ? const Icon(Icons.science, size: 16)
                                  : const Icon(Icons.school, size: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(feed) {
    switch (_selectedTab) {
      case 0:
        return _buildAllTab(feed);
      case 1:
        return _buildNGOList(feed.ngos);
      case 2:
        return _buildNearbyList(feed.nearbyPlaces);
      case 3:
        return _buildCompetitionList(feed.competitions, feed.openNow);
      case 4:
        return _buildATLLabList();
      case 5:
        return _buildScholarshipList();
      default:
        return const SizedBox();
    }
  }

  Widget _buildATLLabList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_rounded,
              size: 56,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('ATL Labs',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary)),
          const SizedBox(height: 8),
          Text(
              'Atal Tinkering Labs near you\nCheck back soon for ATL opportunities',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: context.textSecondary)),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _scholarshipCard(
          name: 'National Merit Scholarship',
          provider: 'Government of India',
          amount: '₹50,000/year',
          deadline: 'Rolling',
          category: 'Need-based',
          icon: Icons.account_balance_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        _scholarshipCard(
          name: 'INSPIRE Scholarship',
          provider: 'DST, Government of India',
          amount: '₹80,000/year',
          deadline: 'Check portal',
          category: 'Merit-based',
          icon: Icons.lightbulb_rounded,
          color: AppTheme.accentOrange,
        ),
        _scholarshipCard(
          name: 'NTSE Scholarship',
          provider: 'NCERT',
          amount: '₹2,000/month',
          deadline: 'Oct-Nov annually',
          category: 'Talent Search',
          icon: Icons.psychology_rounded,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        _scholarshipCard(
          name: 'KVPY Fellowship',
          provider: 'DST, Government of India',
          amount: '₹84,000/year',
          deadline: 'Sept annually',
          category: 'Research',
          icon: Icons.science_rounded,
          color: AppTheme.accentTeal,
        ),
      ],
    );
  }

  Widget _scholarshipCard({
    required String name,
    required String provider,
    required String amount,
    required String deadline,
    required String category,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(provider,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: context.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _miniTag(amount, AppTheme.successGreen),
                const SizedBox(width: 8),
                _miniTag(category, Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                _miniTag('⏰ $deadline', AppTheme.accentOrange),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Saved to bookmarks'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening application...'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Apply',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildAllTab(feed) {
    final hasData = feed.ngos.isNotEmpty ||
        feed.nearbyPlaces.isNotEmpty ||
        feed.competitions.isNotEmpty;
    if (!hasData) return _buildEmptyState();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (feed.openNow.isNotEmpty) ...[
          _sectionHeader(
              '🟢 Registration Open', '${feed.openNow.length} competitions'),
          ...feed.openNow.take(3).map((c) => _compTile(c)),
          const SizedBox(height: 20),
        ],
        if (feed.ngos.isNotEmpty) ...[
          _sectionHeader('🏢 NGOs in ${feed.cityName ?? "your area"}',
              '${feed.ngos.length} found'),
          ...feed.ngos.take(3).map((n) => _ngoTile(n)),
          const SizedBox(height: 20),
        ],
        if (feed.nearbyPlaces.isNotEmpty) ...[
          _sectionHeader(
              '📍 Nearby Places', '${feed.nearbyPlaces.length} found'),
          ...feed.nearbyPlaces.take(3).map((p) => _placeTile(p)),
          const SizedBox(height: 20),
        ],
        if (feed.competitions.isNotEmpty) ...[
          _sectionHeader(
              '🏆 All Competitions', '${feed.competitions.length} available'),
          ...feed.competitions.take(5).map((c) => _compTile(c)),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(count,
              style: GoogleFonts.inter(
                  fontSize: 11, color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }

  Widget _ngoTile(NGO ngo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.account_balance, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ngo.name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('${ngo.city}, ${ngo.state} • ${ngo.focus}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _miniTag(ngo.focus, Theme.of(context).colorScheme.primary),
                const Spacer(),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Saved to bookmarks'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 32,
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Contact info saved'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Contact',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeTile(NearbyPlace place) {
    final icon = place.type == 'library'
        ? Icons.library_books
        : place.type == 'school'
            ? Icons.school
            : place.type == 'makerspace'
                ? Icons.build
                : Icons.location_city;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(place.name,
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${place.distanceKm} km • ${place.type}',
            style: GoogleFonts.inter(
                fontSize: 12, color: Theme.of(context).colorScheme.outline)),
        trailing: Text('${place.distanceKm}km',
            style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget _compTile(Competition comp) {
    final isOpen = comp.isRegistrationOpen;
    final daysLeft = comp.daysUntilDeadline;
    final statusColor = isOpen
        ? (daysLeft < 7
            ? Theme.of(context).colorScheme.error
            : AppTheme.success)
        : Theme.of(context).colorScheme.outline;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(comp.category.toUpperCase(),
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor)),
                ),
                if (isOpen) ...[
                  const SizedBox(width: 8),
                  Text('$daysLeft days left',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w500)),
                ],
                const Spacer(),
                Text(
                    '${comp.examDate.day}/${comp.examDate.month}/${comp.examDate.year}',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.outline)),
              ],
            ),
            const SizedBox(height: 8),
            Text(comp.name,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 4),
            Text(comp.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Competition saved'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text('Save', style: GoogleFonts.inter(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening registration...'),
                            behavior: SnackBarBehavior.floating),
                      );
                    },
                    child: Text(isOpen ? 'Register' : 'View Details',
                        style: GoogleFonts.inter(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNGOList(List ngos) {
    if (ngos.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ngos.length,
      itemBuilder: (ctx, i) => _ngoTile(ngos[i]),
    );
  }

  Widget _buildNearbyList(List places) {
    if (places.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (ctx, i) => _placeTile(places[i]),
    );
  }

  Widget _buildCompetitionList(List all, List open) {
    final list = open.isNotEmpty ? open : all;
    if (list.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (ctx, i) => _compTile(list[i]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined,
              size: 56,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Enter your city to find nearby opportunities',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 8),
          Text(
              'Use the search bar above to discover NGOs, competitions, and more',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () =>
                ref.read(opportunityFeedProvider.notifier).discover(),
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text('Try My Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    if (error.toLowerCase().contains('location')) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off_rounded,
                  size: 56,
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Location not available',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: 8),
              Text(
                  'Enter your city in the search bar above to find opportunities near you',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(opportunityFeedProvider.notifier).discover(),
                icon: const Icon(Icons.my_location, size: 16),
                label: const Text('Try My Location'),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(error,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  ref.read(opportunityFeedProvider.notifier).discover(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunityData {
  final String title;
  final String type;
  final int tier;
  final String distance;
  final double matchScore;

  const _OpportunityData(
      this.title, this.type, this.tier, this.distance, this.matchScore);
}

class SkinsTab extends ConsumerWidget {
  const SkinsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skins = SkinCatalog.getOrderedTiers();
    final totalXP = ref.watch(totalXPProvider);
    final currentSkin = ref.watch(currentSkinProvider);
    final unlockedSkins = ref.watch(unlockedSkinsProvider);
    final unlockedTiers = unlockedSkins.map((s) => s.tier).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Skins Gallery',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars_rounded,
                    size: 16, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  '$totalXP XP',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: skins.isEmpty
          ? empty_state.EmptyStateWidget(
              icon: Icons.emoji_events_outlined,
              title: 'No skins available',
              description: 'Complete missions and earn XP to unlock new skins.',
              iconColor: Theme.of(context).colorScheme.secondary,
            )
          : Column(
              children: [
                // Current skin banner
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: context.isDarkMode
                        ? AppTheme.gradientPrimaryDark
                        : AppTheme.gradientPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getIconForSkinTier(currentSkin.tier),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Identity',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentSkin.displayName,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${unlockedSkins.length}/9',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Grid of skins
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: skins.length,
                    itemBuilder: (context, index) {
                      final tier = skins[index];
                      final config = SkinCatalog.getConfig(tier);
                      final isUnlocked = unlockedTiers.contains(tier);
                      final isEquipped = currentSkin.tier == tier;
                      return _SkinGridCard(
                        config: config,
                        isUnlocked: isUnlocked,
                        isEquipped: isEquipped,
                        currentXP: totalXP,
                        onEquip: isUnlocked && !isEquipped
                            ? () async {
                                HapticFeedback.mediumImpact();
                                await ref.read(equipSkinProvider)(tier);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${config.displayName} equipped! 🎨'),
                                      backgroundColor: AppTheme.successGreen,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                }
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getIconForSkinTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer:
        return Icons.explore_rounded;
      case SkinTier.scholar:
        return Icons.school_rounded;
      case SkinTier.evidenceKeeper:
        return Icons.verified_rounded;
      case SkinTier.marathonRunner:
        return Icons.directions_run_rounded;
      case SkinTier.researcher:
        return Icons.science_rounded;
      case SkinTier.leader:
        return Icons.people_rounded;
      case SkinTier.creator:
        return Icons.palette_rounded;
      case SkinTier.changemaker:
        return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer:
        return Icons.star_rounded;
    }
  }
}

/// Grid card for a single skin in the gallery.
class _SkinGridCard extends StatelessWidget {
  final SkinConfig config;
  final bool isUnlocked;
  final bool isEquipped;
  final int currentXP;
  final VoidCallback? onEquip;

  const _SkinGridCard({
    required this.config,
    required this.isUnlocked,
    required this.isEquipped,
    required this.currentXP,
    this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = config.visualProperties['primaryColor'] != null
        ? Color(config.visualProperties['primaryColor'] as int)
        : Theme.of(context).colorScheme.primary;
    final progress = config.xpRequired > 0
        ? (currentXP / config.xpRequired).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEquipped
              ? primaryColor
              : isUnlocked
                  ? primaryColor.withValues(alpha: 0.3)
                  : context.borderColor,
          width: isEquipped ? 2 : 1,
        ),
        boxShadow: isEquipped
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skin icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? primaryColor.withValues(alpha: 0.12)
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForTier(config.tier),
                    color: isUnlocked ? primaryColor : context.textMuted,
                    size: 28,
                  ),
                ),
                if (isEquipped)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.surfaceElevated, width: 2),
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 12),
                    ),
                  ),
                if (!isUnlocked)
                  Positioned(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: context.textMuted.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.lock, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Name
            Text(
              config.displayName,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? context.textPrimary : context.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRarityColor(config.rarity, context)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                config.rarity.toString().split('.').last.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: _getRarityColor(config.rarity, context),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Progress toward unlock
            if (!isUnlocked) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$currentXP / ${config.xpRequired} XP',
                style: GoogleFonts.inter(fontSize: 9, color: context.textMuted),
              ),
            ],
            // Equip button
            if (isUnlocked && !isEquipped && onEquip != null) ...[
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: FilledButton(
                  onPressed: onEquip,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Equip',
                    style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
            if (isEquipped) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Equipped ✓',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer:
        return Icons.explore_rounded;
      case SkinTier.scholar:
        return Icons.school_rounded;
      case SkinTier.evidenceKeeper:
        return Icons.verified_rounded;
      case SkinTier.marathonRunner:
        return Icons.directions_run_rounded;
      case SkinTier.researcher:
        return Icons.science_rounded;
      case SkinTier.leader:
        return Icons.people_rounded;
      case SkinTier.creator:
        return Icons.palette_rounded;
      case SkinTier.changemaker:
        return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer:
        return Icons.star_rounded;
    }
  }

  Color _getRarityColor(SkinRarity rarity, BuildContext context) {
    switch (rarity) {
      case SkinRarity.common:
        return context.textMuted;
      case SkinRarity.uncommon:
        return Theme.of(context).colorScheme.primary;
      case SkinRarity.rare:
        return const Color(0xFF8B5CF6);
      case SkinRarity.legendary:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}

class ProfileTab extends ConsumerWidget {
  final ValueChanged<int> onTabChange;

  const ProfileTab({super.key, required this.onTabChange});

  /// Maps an ActivityCategory enum value to the lowercase color key used by AppColors.categoryColors.
  static String _categoryColorKey(ActivityCategory cat) {
    switch (cat) {
      case ActivityCategory.work:
        return 'work';
      default:
        return cat
            .name; // clubs, sports, arts, competitions, research, volunteering, leadership, courses, unique
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final onboardingData = ref.watch(onboardingDataProvider);
    final totalXP = ref.watch(totalXPProvider);
    final streak = ref.watch(streakStateProvider);
    final unlockedSkins = ref.watch(unlockedSkinsProvider);
    final admissionsProbability = ref.watch(admissionsProbabilityProvider);
    final currentSkin = ref.watch(currentSkinProvider);

    // Resolve display name
    final displayName = onboardingData.name.isNotEmpty
        ? onboardingData.name
        : (profile?.name ?? '');

    // Compute activity summary from profile
    final activities = profile?.activities ?? [];
    final categoryCounts = <ActivityCategory, int>{};
    final categoryXP = <ActivityCategory, int>{};
    for (final activity in activities) {
      categoryCounts[activity.category] =
          (categoryCounts[activity.category] ?? 0) + 1;
      categoryXP[activity.category] =
          (categoryXP[activity.category] ?? 0) + activity.admissionsValue;
    }

    // Build target university rows from profile
    final targetUniRows = <Widget>[];
    final major = profile?.targetMajor ?? '';
    final country = profile?.targetCountries.isNotEmpty == true
        ? profile!.targetCountries.first
        : '';
    // Reach universities
    for (final uniName in profile?.reachUniversities ?? []) {
      double prob = 0.15;
      for (final entry in admissionsProbability.entries) {
        if (entry.value.university.toLowerCase() == uniName.toLowerCase()) {
          prob = entry.value.currentProbability;
          break;
        }
      }
      targetUniRows.add(_TargetUniRow(
          name: uniName,
          major: major,
          country: country,
          probability: prob,
          isReach: true));
    }
    // Match universities
    for (final uniName in profile?.matchUniversities ?? []) {
      double prob = 0.45;
      for (final entry in admissionsProbability.entries) {
        if (entry.value.university.toLowerCase() == uniName.toLowerCase()) {
          prob = entry.value.currentProbability;
          break;
        }
      }
      targetUniRows.add(_TargetUniRow(
          name: uniName,
          major: major,
          country: country,
          probability: prob,
          isReach: false));
    }
    // Safety universities
    for (final uniName in profile?.safetyUniversities ?? []) {
      double prob = 0.75;
      for (final entry in admissionsProbability.entries) {
        if (entry.value.university.toLowerCase() == uniName.toLowerCase()) {
          prob = entry.value.currentProbability;
          break;
        }
      }
      targetUniRows.add(_TargetUniRow(
          name: uniName,
          major: major,
          country: country,
          probability: prob,
          isReach: false));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile editing coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: context.isDarkMode
                    ? AppTheme.gradientPrimaryDark
                    : AppTheme.gradientPrimary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Icon(
                          _getIconForSkinTier(currentSkin.tier),
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            currentSkin.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName.isNotEmpty ? displayName : 'Student',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Grade ${profile?.grade ?? 11} • ${profile?.board ?? 'CBSE'} • ${profile?.stream ?? 'Science'}',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'Total XP', value: '$totalXP'),
                      _StatItem(
                          label: 'Streak',
                          value: '${streak.currentStreak} days'),
                      _StatItem(
                          label: 'Skins', value: '${unlockedSkins.length}/9'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Quick Stats Row
            Row(
              children: [
                _ProfileQuickStat(
                  icon: Icons.local_fire_department_rounded,
                  value: '${streak.longestStreak}',
                  label: 'Best Streak',
                  color: AppTheme.accentOrange,
                ),
                const SizedBox(width: 12),
                _ProfileQuickStat(
                  icon: Icons.star_rounded,
                  value: '${totalXP}',
                  label: 'Total XP',
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                _ProfileQuickStat(
                  icon: Icons.task_alt_rounded,
                  value: '${activities.length}',
                  label: 'Activities',
                  color: AppTheme.successGreen,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Target universities
            _SectionCard(
              title: 'Target Universities',
              icon: Icons.school_rounded,
              children: targetUniRows.isNotEmpty
                  ? targetUniRows
                  : [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(
                          'Complete onboarding to set target universities',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: context.textMuted),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 16),
            // Activity summary
            _SectionCard(
              title: 'Activity Summary',
              icon: Icons.analytics_rounded,
              children: categoryCounts.isNotEmpty
                  ? categoryCounts.entries.map((entry) {
                      final cat = entry.key;
                      final count = entry.value;
                      final xpVal = categoryXP[cat] ?? 0;
                      final colorKey = _categoryColorKey(cat);
                      final displayCat =
                          cat.name[0].toUpperCase() + cat.name.substring(1);
                      return _ActivitySummaryRow(
                          category: displayCat, count: count, xp: xpVal);
                    }).toList()
                  : [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(
                          'Add activities in onboarding to see your summary',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: context.textMuted),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 16),
            // Settings
            _SectionCard(
              title: 'Settings',
              icon: Icons.settings_rounded,
              children: [
                _SettingsRow(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  subtitle: 'Mission reminders, weekly briefings',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.location_on_rounded,
                  title: 'Location Privacy',
                  subtitle: 'Precise location stays on device',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.backup_rounded,
                  title: 'Backup & Sync',
                  subtitle: 'Encrypted backup to cloud',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.dark_mode_rounded,
                  title: 'Appearance',
                  subtitle: 'Dark mode, themes, skin effects',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English, Hindi, and regional languages',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.shield_rounded,
                  title: 'Privacy & Data',
                  subtitle: 'What we collect, where it stays',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  ),
                ),
                _SettingsRow(
                  icon: Icons.help_rounded,
                  title: 'Help & Support',
                  subtitle: 'FAQ, contact, feedback',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help center coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _SettingsRow(
                  icon: Icons.info_outline_rounded,
                  title: 'About ProfileForge',
                  subtitle: 'Version 1.0.0 • Made with ❤️ in India',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ProfileForge',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 ProfileForge',
                      children: [
                        Text(
                          'ProfileForge helps Indian 11th graders build compelling college applications by tracking activities, opportunities, and admissions probability.',
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSkinTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer:
        return Icons.explore_rounded;
      case SkinTier.scholar:
        return Icons.school_rounded;
      case SkinTier.evidenceKeeper:
        return Icons.verified_rounded;
      case SkinTier.marathonRunner:
        return Icons.directions_run_rounded;
      case SkinTier.researcher:
        return Icons.science_rounded;
      case SkinTier.leader:
        return Icons.people_rounded;
      case SkinTier.creator:
        return Icons.palette_rounded;
      case SkinTier.changemaker:
        return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer:
        return Icons.star_rounded;
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;

  const _SectionCard({required this.title, this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon!,
                      size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Quick stat widget for the profile page.
class _ProfileQuickStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ProfileQuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetUniRow extends StatelessWidget {
  final String name;
  final String major;
  final String country;
  final double probability;
  final bool isReach;

  const _TargetUniRow({
    required this.name,
    required this.major,
    required this.country,
    required this.probability,
    required this.isReach,
  });

  @override
  Widget build(BuildContext context) {
    final color = isReach
        ? Theme.of(context).colorScheme.tertiary
        : (probability > 0.5
            ? AppTheme.successGreen
            : Theme.of(context).colorScheme.primary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary)),
                if (major.isNotEmpty || country.isNotEmpty)
                  Text(
                      '$major${major.isNotEmpty && country.isNotEmpty ? ' • ' : ''}$country',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: context.textMuted)),
              ],
            ),
          ),
          Text(
            '${(probability * 100).toInt()}%',
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _ActivitySummaryRow extends StatelessWidget {
  final String category;
  final int count;
  final int xp;

  const _ActivitySummaryRow(
      {required this.category, required this.count, required this.xp});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColors[category.toLowerCase()] ??
        Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(_getIcon(category), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary)),
                Text('$count activities • $xp XP',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: context.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              '+$xp',
              style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'research':
        return Icons.science_rounded;
      case 'leadership':
        return Icons.people_rounded;
      case 'volunteering':
        return Icons.volunteer_activism_rounded;
      case 'competitions':
        return Icons.emoji_events_rounded;
      case 'clubs':
        return Icons.school_rounded;
      case 'sports':
        return Icons.sports_soccer_rounded;
      case 'arts':
        return Icons.palette_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'courses':
        return Icons.menu_book_rounded;
      case 'unique':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsRow(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.textPrimary)),
      subtitle: Text(subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: context.textMuted)),
      trailing: Icon(Icons.chevron_right_rounded, color: context.textMuted),
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : () {},
    );
  }
}

/// Compact stat card for the dashboard overview row.
class _DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DashboardStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick action pill button for the dashboard.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating action button for quick access to the AI Chat screen.
class _ChatFAB extends StatelessWidget {
  final VoidCallback onTap;

  const _ChatFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
