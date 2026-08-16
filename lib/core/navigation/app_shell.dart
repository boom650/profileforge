import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// Main app shell: keeps the primary tab state alive via an [IndexedStack]
/// (go_router StatefulShellRoute) and owns the bottom navigation bar.
/// Back-press on a non-home tab returns to Home instead of exiting the app.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0, initialLocation: false);
        }
      },
      child: Scaffold(
        backgroundColor: dark ? Palette.black : Palette.cream,
        body: SafeArea(child: navigationShell),
        bottomNavigationBar: _ShellNav(
          currentIndex: navigationShell.currentIndex,
          onSelected: (i) =>
              navigationShell.goBranch(i, initialLocation: false),
        ),
      ),
    );
  }
}

class _ShellNav extends StatelessWidget {
  const _ShellNav({required this.currentIndex, required this.onSelected});

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      (icon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.flag_rounded, label: 'Missions'),
      (icon: Icons.emoji_events_rounded, label: 'Leagues'),
      (icon: Icons.group_rounded, label: 'Buddies'),
      (icon: Icons.diamond_rounded, label: 'Skins'),
      (icon: Icons.explore_rounded, label: 'Discover'),
    ];
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelected,
      destinations: items
          .map((i) => NavigationDestination(
                icon: Icon(i.icon),
                selectedIcon: Icon(i.icon, color: Palette.primary),
                label: i.label,
              ))
          .toList(),
    );
  }
}