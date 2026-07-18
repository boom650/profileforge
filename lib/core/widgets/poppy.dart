import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// Reusable "poppy" UI atoms used across every screen.

class PoppyButton extends StatelessWidget {
  const PoppyButton(
      {super.key, required this.label, required this.onTap, this.color});
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color ?? Palette.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
        child: Text(label),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action});
  final String text;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const Spacer(),
            if (action != null) action!,
          ],
        ),
      );
}

class PillarChip extends StatelessWidget {
  const PillarChip(this.pillar, {super.key, this.selected = false});
  final String pillar;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final c = pillarColor(pillar);
    return Chip(
      avatar: selected ? null : null,
      label: Text(pillar[0].toUpperCase() + pillar.substring(1),
          style: TextStyle(
              color: selected ? Colors.white : c, fontWeight: FontWeight.w800)),
      backgroundColor: selected ? c : c.withOpacity(0.12),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard(
      {super.key,
      required this.icon,
      required this.value,
      required this.label,
      this.color});
  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final c = color ?? Palette.green;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}

/// Circular XP/level ring.
class XpRing extends StatelessWidget {
  const XpRing(
      {super.key,
      required this.progress,
      required this.centerTop,
      required this.centerBottom,
      this.color});
  final double progress; // 0..1
  final String centerTop;
  final String centerBottom;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final c = color ?? Palette.green;
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 9,
              color: c,
              backgroundColor: c.withOpacity(0.18),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(centerTop,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900)),
              Text(centerBottom,
                  style: TextStyle(
                      fontSize: 11, color: Theme.of(context).hintColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class RarityBadge extends StatelessWidget {
  const RarityBadge(this.rarity, {super.key});
  final String rarity;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: rarityColor(rarity),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(rarity[0].toUpperCase() + rarity.substring(1),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5)),
      );
}

/// Shared bottom navigation for the main tabs.
Widget appBottomNav(BuildContext context, String current) {
  const items = [
    (icon: Icons.home, label: 'Home', route: '/home'),
    (icon: Icons.flag, label: 'Missions', route: '/missions'),
    (icon: Icons.emoji_events, label: 'Leagues', route: '/leagues'),
    (icon: Icons.group, label: 'Buddies', route: '/buddies'),
    (icon: Icons.style, label: 'Skins', route: '/skins'),
    (icon: Icons.explore, label: 'Discover', route: '/discover'),
  ];
  final idx = items.indexWhere((i) => i.route == current).clamp(0, items.length - 1);
  return NavigationBar(
    selectedIndex: idx,
    onDestinationSelected: (i) {
      final route = items[i].route;
      if (route != current) context.go(route);
    },
    destinations: items
        .map((i) => NavigationDestination(
              icon: Icon(i.icon),
              label: i.label,
            ))
        .toList(),
  );
}

/// Gradient banner used as a screen header.
class GradientBanner extends StatelessWidget {
  const GradientBanner(
      {super.key, required this.child, required this.from, required this.to});
  final Widget child;
  final Color from;
  final Color to;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [from, to], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
        ),
        child: child,
      );
}
