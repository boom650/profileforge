import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../../models/student_profile.dart';
import '../../../models/gamification/missions.dart';
import '../../../models/gamification/skins.dart';
import '../../../services/opportunity_feed.dart';
import '../../widgets/streak_ring.dart';
import '../../widgets/probability_radar.dart';
import '../../widgets/mission_card.dart';
import '../../widgets/micro_interactions.dart';
import '../../widgets/skin_showcase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/api_config.dart';
import '../settings/settings_screen.dart';
import '../targets/weekly_targets_screen.dart';
import '../competitions/competition_calendar.dart';
import '../research/research_milestones.dart';
import '../university/university_browser.dart';
import '../university/university_matcher.dart';
import '../essay/essay_coach_screen.dart';
import 'widgets/shared_widgets.dart';

/// Dashboard tab - the main home screen content.
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
    final greeting = greetingForHour(DateTime.now().hour);
    final greetingText = userName.isNotEmpty ? '$greeting, $userName 👋' : '$greeting 👋';

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
              semanticLabel: 'Open notifications',
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              tooltip: 'Settings',
              semanticLabel: 'Open settings',
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
                        final result = await ref.read(markDailyActiveProvider)();
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
                                  content: const Text('Already checked in today! ✅'),
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
                              content: const Text('Check-in failed. Try again.'),
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
                  child: XPProgressCard(xp: xp, currentSkin: currentSkin.name),
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
                DashboardStatCard(
                  icon: Icons.task_alt_rounded,
                  label: 'Missions',
                  value: '${missions.where((m) => m.isCompleted).length}/${missions.length}',
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 12),
                DashboardStatCard(
                  icon: Icons.explore_rounded,
                  label: 'Opportunities',
                  value: '${feed.ngos.length + feed.competitions.length}',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                DashboardStatCard(
                  icon: Icons.star_rounded,
                  label: 'XP Earned',
                  value: '$xp',
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                DashboardStatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Streak',
                  value: '${streak.currentStreak}d',
                  color: AppTheme.accentOrange,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ),

        // Quick Action Buttons - Row 1
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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
                  child: QuickActionButton(
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

        // Profile Completion Strength
        SliverToBoxAdapter(
          child: const ProfileStrengthCard(),
        ),

        // Daily Tip of the Day
        SliverToBoxAdapter(
          child: const DailyTipCard(),
        ),

        // Location Permission Prompt
        SliverToBoxAdapter(
          child: const LocationPermissionPrompt(),
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
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                  const EmptyMissionsCard(),
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
                          onTabChange(1); // Switch to Missions tab
                        },
                        child: Text('Details',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                        child: SpikeCard(spike: spike),
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
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
class LocationPermissionPrompt extends ConsumerStatefulWidget {
  const LocationPermissionPrompt({super.key});

  @override
  ConsumerState<LocationPermissionPrompt> createState() =>
      _LocationPermissionPromptState();
}

class _LocationPermissionPromptState
    extends ConsumerState<LocationPermissionPrompt> {
  bool _hasAsked = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _hasAsked = prefs.getBool('location_permission_asked') ?? false;
    if (mounted) setState(() {});
  }

  Future<void> _requestLocationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_asked', true);
    setState(() => _hasAsked = true);
    // Trigger the actual permission request via the provider
    await ref.read(locationPermissionProvider.future);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location access enabled! Discovering opportunities...'),
          backgroundColor: AppTheme.successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasAsked) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentTeal.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: AppTheme.accentTeal, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Enable Nearby Opportunities',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Allow location to discover NGOs, competitions, and events near you. You can also enter your city manually.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _requestLocationPermission,
              icon: const Icon(Icons.gps_fixed_rounded, size: 18),
              label: Text('Enable Location', style: GoogleFonts.inter()),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accentTeal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
    );
  }
}

/// Shows a location permission prompt if not yet asked.
/// Once enabled, opportunities auto-discover nearby NGOs & competitions.
/// Supports both GPS and manual city entry.
// ─── Daily Tip Card ──────────────────────────────────────────────────────────────
// ─── Profile Strength Card ──────────────────────────────────────────────────────
class ProfileStrengthCard extends StatefulWidget {
  const ProfileStrengthCard({super.key});

  @override
  State<ProfileStrengthCard> createState() => _ProfileStrengthCardState();
}

class _ProfileStrengthCardState extends State<ProfileStrengthCard> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';
      if (userId.isEmpty) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final url = Uri.parse('$kApiBaseUrl/api/users/$userId/profile-strength');
      final resp = await http.get(url).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200 && mounted) {
        setState(() {
          _data = jsonDecode(resp.body);
          _loading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _data == null) return const SizedBox.shrink();

    final pct = _data!['percentage'] ?? 0;
    final level = _data!['level'] ?? '';
    final emoji = _data!['emoji'] ?? '🚀';
    final missing = (_data!['tips'] as List?) ?? [];

    // Color based on completion
    Color barColor;
    if (pct >= 80) {
      barColor = AppTheme.successGreen;
    } else if (pct >= 50) {
      barColor = AppTheme.warningAmber;
    } else {
      barColor = AppTheme.errorRed;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: barColor.withValues(alpha: 0.3),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Strength: $level',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$pct% complete',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: pct / 100.0,
                minHeight: 8,
                backgroundColor: barColor.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
            if (missing.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                missing.first,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.warningAmber,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(delay: 330.ms),
    );
  }
}

class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard> {
  Map<String, dynamic>? _tip;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTip();
  }

  Future<void> _fetchTip() async {
    try {
      final url = Uri.parse('$kApiBaseUrl/api/daily-tips');
      final resp = await http.get(url).timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200 && mounted) {
        setState(() {
          _tip = jsonDecode(resp.body);
          _loading = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _tip == null) return const SizedBox.shrink();

    final tipText = _tip!['tip'] ?? _tip!['text'] ?? '';
    final category = _tip!['category'] ?? '💡 Tip';
    final emoji = _tip!['emoji'] ?? '💡';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: context.isDarkMode
              ? LinearGradient(
                  colors: [
                    AppTheme.accentPurple.withValues(alpha: 0.15),
                    AppTheme.accentTeal.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.1),
                    Colors.orange.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.isDarkMode
                          ? AppTheme.accentPurple
                          : Colors.orange[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tipText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: context.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 360.ms),
    );
  }
}