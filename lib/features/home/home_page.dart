import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/buddy/presentation/buddies_screen.dart';
import 'package:profileforge/features/geo/presentation/geo_screen.dart';
import 'package:profileforge/features/leagues/presentation/leagues_screen.dart';
import 'package:profileforge/features/missions/presentation/missions_screen.dart';
import 'package:profileforge/features/skins/presentation/skins_screen.dart';
import 'package:profileforge/features/streak/presentation/streak_card.dart';
import 'package:profileforge/features/teams/presentation/teams_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.profileId});
  final String profileId;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _tab = 0;

  late final List<Widget> _screens = [
    _Dashboard(profileId: widget.profileId),
    MissionsScreen(profileId: widget.profileId),
    LeaguesScreen(profileId: widget.profileId),
    BuddiesScreen(profileId: widget.profileId),
    TeamsScreen(profileId: widget.profileId),
    SkinsScreen(profileId: widget.profileId),
    GeoScreen(lat: 1.3521, lng: 103.8198),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _tab, children: _screens)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Missions'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Leagues'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Buddies'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Teams'),
          NavigationDestination(icon: Icon(Icons.checkroom), label: 'Skins'),
          NavigationDestination(icon: Icon(Icons.explore), label: 'Discover'),
        ],
      ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wide = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      appBar: AppBar(title: const Text('ProfileForge')),
      body: ListView(
        padding: EdgeInsets.all(wide ? 32 : 16),
        children: [
          StreakCard(profileId: profileId),
          const SizedBox(height: 16),
          const Text('Your growth OS is live. Pick a tab to start.'),
        ],
      ),
    );
  }
}
