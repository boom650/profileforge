import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../settings/privacy_screen.dart';
import '../../../providers/app_providers.dart';
import '../../../models/gamification/skins.dart';
import '../../widgets/streak_ring.dart';
import '../../widgets/probability_radar.dart';
import '../../widgets/mission_card.dart' hide SkinShowcaseCompact;
import '../../widgets/skin_showcase.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/micro_interactions.dart';
import '../../../models/gamification/missions.dart';
import '../../../services/spike_framework.dart';
import '../../widgets/empty_state.dart' as empty_state;
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DashboardTab(),
    const MissionsTab(),
    const OpportunitiesTab(),
    const SkinsTab(),
    const ProfileTab(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            selectedIcon: Icon(Icons.dashboard_rounded, fill: 1),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_rounded),
            selectedIcon: Icon(Icons.assignment_rounded, fill: 1),
            label: 'Missions',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_rounded),
            selectedIcon: Icon(Icons.explore_rounded, fill: 1),
            label: 'Opportunities',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_rounded),
            selectedIcon: Icon(Icons.emoji_events_rounded, fill: 1),
            label: 'Skins',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            selectedIcon: Icon(Icons.person_rounded, fill: 1),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakStateProvider);
    final xp = ref.watch(totalXPProvider);
    final currentSkin = ref.watch(currentSkinProvider);
    final missions = ref.watch(missionsProvider);
    final factorBreakdown = ref.watch(factorBreakdownProvider);
    final admissionsProbability = ref.watch(admissionsProbabilityProvider);
    final topSpikes = ref.watch(topSpikesProvider(3));

    return CustomScrollView(
      slivers: [
        // App bar with greeting
        SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          backgroundColor: AppTheme.surfaceWhite,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Shridhar 👋',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                'Week 3 • Day 4',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () { HapticFeedback.lightImpact(); },
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () { HapticFeedback.lightImpact(); Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyScreen()),
              ); },
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

        // Admissions Probability Radar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Admissions Probability',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () { HapticFeedback.lightImpact(); },
                      child: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (factorBreakdown != null)
                  ProbabilityRadarChart(
                    factorBreakdown: factorBreakdown,
                    monteCarloResult: admissionsProbability.isNotEmpty
                        ? admissionsProbability.values.first.monteCarloResult
                        : null,
                    universityName: admissionsProbability.isNotEmpty
                        ? admissionsProbability.values.first.university
                        : '',
                  )
                else
                  const SizedBox.shrink(),
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
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () { HapticFeedback.lightImpact(); },
                      child: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...missions.where((m) => m.type == MissionType.daily && !m.isCompleted)
                    .take(3)
                    .map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MissionCard(mission: m),
                        )),
                if (missions.where((m) => m.type == MissionType.daily && !m.isCompleted).isEmpty)
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
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () { HapticFeedback.lightImpact(); },
                        child: Text('Details', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'These achievements make your profile stand out',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...topSpikes.map((spike) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () { HapticFeedback.lightImpact(); },
                      child: Text('Gallery', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () { HapticFeedback.lightImpact(); },
                      child: Text('Explore', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => OpportunityCardHorizontal(
                      title: ['Goonj Teaching', 'ATL Lab Robotics', 'IRIS Science Fair'][index],
                      type: ['NGO Volunteering', 'In-School Club', 'Competition'][index],
                      tier: [2, 2, 1][index],
                      distance: ['3.2 km', 'In School', '12 km'][index],
                      matchScore: [0.94, 0.88, 0.76][index],
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
        gradient: AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.stars_rounded, color: AppTheme.accentGold, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Total XP',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
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
                      color: AppTheme.textPrimary,
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
                  color: AppTheme.accentGold.withValues(alpha: 0.1),
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
                  color: AppTheme.primaryBlue,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}% to next skin',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textMuted,
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
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 48, color: AppTheme.successGreen),
          const SizedBox(height: 12),
          Text(
            'All caught up! 🎉',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No daily missions pending. Check back tomorrow!',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
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
    final categoryColor =
        AppTheme.categoryColors[spike.category.colorKey] ?? AppTheme.primaryBlue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
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
                style: const TextStyle(fontSize: 22),
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
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      spike.starsDisplay,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.accentGold,
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

class MissionsTab extends ConsumerWidget {
  const MissionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionsProvider);
    final dailyMissions = missions.where((m) => m.type == MissionType.daily).toList();
    final weeklyMissions = missions.where((m) => m.type == MissionType.weekly).toList();
    final milestoneMissions = missions.where((m) => m.type == MissionType.milestone).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Missions', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
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

class _MissionList extends StatelessWidget {
  final List<Mission> missions;

  const _MissionList({required this.missions});

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            Text(
              'No missions yet',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete onboarding to unlock missions',
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: missions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => MissionCard(mission: missions[index]),
    );
  }
}

class OpportunitiesTab extends ConsumerWidget {
  const OpportunitiesTab({super.key});

  static final _sampleOpportunities = [
    _OpportunityData('Goonj Weekend Teaching', 'NGO Volunteering', 2, '3.2 km', 0.94),
    _OpportunityData('ATL Lab Robotics Club', 'In-School Club', 2, 'In School', 0.88),
    _OpportunityData('IRIS National Science Fair', 'Competition', 1, '12 km', 0.76),
    _OpportunityData('Google Code-in', 'Competition', 1, 'Online', 0.82),
    _OpportunityData('NGO Dhara Sansthan', 'NGO Volunteering', 3, '5.1 km', 0.71),
    _OpportunityData('School MUN Conference', 'In-School Club', 2, 'In School', 0.85),
    _OpportunityData('KVPY Fellowship', 'Competition', 1, 'Online', 0.68),
    _OpportunityData('Local Library Volunteer', 'Volunteering', 3, '2.8 km', 0.65),
    _OpportunityData('District Chess Tournament', 'Competition', 3, '8 km', 0.60),
    _OpportunityData('Ashoka University YSP', 'Summer Program', 2, 'Online', 0.78),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunities = _sampleOpportunities;

    return Scaffold(
      appBar: AppBar(
        title: Text('Opportunities', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () { HapticFeedback.lightImpact(); },
          ),
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () { HapticFeedback.lightImpact(); },
          ),
        ],
      ),
      body: opportunities.isEmpty
          ? empty_state.EmptyStateWidget(
              icon: Icons.explore_outlined,
              title: 'No opportunities found',
              description: 'We couldn\'t find any opportunities matching your profile. Try adjusting your filters or location.',
              actionLabel: 'Refresh',
              onAction: () {},
              iconColor: AppTheme.primaryBlue,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: opportunities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final opp = opportunities[index];
                return OpportunityCardVertical(
                  title: opp.title,
                  type: opp.type,
                  tier: opp.tier,
                  distance: opp.distance,
                  matchScore: opp.matchScore,
                );
              },
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

  const _OpportunityData(this.title, this.type, this.tier, this.distance, this.matchScore);
}

class SkinsTab extends ConsumerWidget {
  const SkinsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skins = SkinCatalog.getOrderedTiers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Skins Gallery', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
      body: skins.isEmpty
          ? empty_state.EmptyStateWidget(
              icon: Icons.emoji_events_outlined,
              title: 'No skins available',
              description: 'Complete missions and earn XP to unlock new skins.',
              iconColor: AppTheme.accentGold,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: skins.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final tier = skins[index];
                final config = SkinCatalog.getConfig(tier);
                return _SkinGalleryCard(config: config);
              },
            ),
    );
  }
}

class _SkinGalleryCard extends StatelessWidget {
  final SkinConfig config;

  const _SkinGalleryCard({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.visualProperties['primaryColor'] != null 
            ? Color(config.visualProperties['primaryColor'] as int).withValues(alpha: 0.2)
            : AppTheme.primaryBlue.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: (config.visualProperties['primaryColor'] != null 
                ? Color(config.visualProperties['primaryColor'] as int)
                : AppTheme.primaryBlue).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: (config.visualProperties['primaryColor'] != null 
                  ? Color(config.visualProperties['primaryColor'] as int)
                  : AppTheme.primaryBlue).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getIconForTier(config.tier),
              color: config.visualProperties['primaryColor'] != null 
                  ? Color(config.visualProperties['primaryColor'] as int)
                  : AppTheme.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      config.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRarityColor(config.rarity).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        config.rarity.toString().split('.').last.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _getRarityColor(config.rarity),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  config.description,
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: config.unlockCriteria.map((c) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      c,
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textMuted),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${config.xpRequired} XP',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.lock_outline_rounded,
                color: AppTheme.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer: return Icons.explore_rounded;
      case SkinTier.scholar: return Icons.school_rounded;
      case SkinTier.evidenceKeeper: return Icons.verified_rounded;
      case SkinTier.marathonRunner: return Icons.directions_run_rounded;
      case SkinTier.researcher: return Icons.science_rounded;
      case SkinTier.leader: return Icons.people_rounded;
      case SkinTier.creator: return Icons.palette_rounded;
      case SkinTier.changemaker: return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer: return Icons.star_rounded;
    }
  }

  Color _getRarityColor(SkinRarity rarity) {
    switch (rarity) {
      case SkinRarity.common: return AppTheme.textMuted;
      case SkinRarity.uncommon: return AppTheme.primaryBlue;
      case SkinRarity.rare: return const Color(0xFF8B5CF6);
      case SkinRarity.legendary: return AppTheme.accentGold;
    }
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () { HapticFeedback.lightImpact(); },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.gradientPrimary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Shridhar',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final profile = ref.watch(studentProfileProvider);
                      final grade = profile?.grade ?? 11;
                      final board = profile?.board ?? 'CBSE';
                      final stream = profile?.stream ?? 'Science';
                      return Text(
                        'Grade $grade • $board • $stream',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'Total XP', value: '1,247'),
                      _StatItem(label: 'Streak', value: '12 days'),
                      _StatItem(label: 'Skins', value: '3/9'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Target universities
            _SectionCard(
              title: 'Target Universities',
              children: [
                _TargetUniRow(name: 'MIT', major: 'CS', country: 'US', probability: 0.12, isReach: true),
                _TargetUniRow(name: 'UCLA', major: 'CS', country: 'US', probability: 0.34, isReach: false),
                _TargetUniRow(name: 'UMass', major: 'CS', country: 'US', probability: 0.67, isReach: false),
              ],
            ),
            const SizedBox(height: 16),
            // Activity summary
            _SectionCard(
              title: 'Activity Summary',
              children: [
                _ActivitySummaryRow(category: 'Research', count: 0, xp: 0),
                _ActivitySummaryRow(category: 'Leadership', count: 2, xp: 450),
                _ActivitySummaryRow(category: 'Volunteering', count: 3, xp: 780),
                _ActivitySummaryRow(category: 'Competitions', count: 1, xp: 320),
              ],
            ),
            const SizedBox(height: 16),
            // Settings
            _SectionCard(
              title: 'Settings',
              children: [
                _SettingsRow(icon: Icons.notifications_rounded, title: 'Notifications', subtitle: 'Mission reminders, weekly briefings'),
                _SettingsRow(icon: Icons.location_on_rounded, title: 'Location Privacy', subtitle: 'Precise location stays on device'),
                _SettingsRow(icon: Icons.backup_rounded, title: 'Backup & Sync', subtitle: 'Encrypted backup to cloud'),
                _SettingsRow(
                  icon: Icons.shield_rounded,
                  title: 'Privacy & Data',
                  subtitle: 'What we collect, where it stays',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  ),
                ),
                _SettingsRow(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'FAQ, contact, feedback'),
              ],
            ),
          ],
        ),
      ),
    );
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
          style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

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
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
          ),
          ...children,
        ],
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
    final color = isReach ? const Color(0xFF8B5CF6) : (probability > 0.5 ? const Color(0xFF10B981) : const Color(0xFF3B82F6));

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
                Text(name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text('$major • $country', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Text(
            '${(probability * 100).toInt()}%',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: color),
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

  const _ActivitySummaryRow({required this.category, required this.count, required this.xp});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColors[category.toLowerCase()] ?? AppTheme.primaryBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(_getIcon(category), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                Text('$count activities • $xp XP', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(
              '+$xp',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'research': return Icons.science_rounded;
      case 'leadership': return Icons.people_rounded;
      case 'volunteering': return Icons.volunteer_activism_rounded;
      case 'competitions': return Icons.emoji_events_rounded;
      default: return Icons.star_rounded;
    }
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsRow({required this.icon, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      ),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
      trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
      onTap: onTap != null ? () { HapticFeedback.lightImpact(); onTap!(); } : () {},
    );
  }
}