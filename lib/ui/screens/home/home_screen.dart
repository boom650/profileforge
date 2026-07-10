import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_tab.dart';
import 'missions_tab.dart';
import 'opportunities_tab.dart';
import 'skins_tab.dart';
import 'profile_tab.dart';
import 'widgets/shared_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          DashboardTab(onTabChange: _onTabChanged),
          const MissionsTab(),
          const OpportunitiesTab(),
          const SkinsTab(),
          ProfileTab(onTabChange: _onTabChanged),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.task_alt_rounded), label: 'Missions'),
          NavigationDestination(icon: Icon(Icons.explore_rounded), label: 'Opportunities'),
          NavigationDestination(icon: Icon(Icons.palette_rounded), label: 'Skins'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentIndex == 0 
          ? ChatFAB(onTap: () => Navigator.pushNamed(context, '/chat'))
          : null,
    );
  }
}
