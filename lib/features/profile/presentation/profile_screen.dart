import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/game/level.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);
    final xp = ref.watch(totalXpProvider(profileId)).valueOrNull ?? 0;
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;
    final streak = ref.watch(streakProvider(profileId)).valueOrNull?.current ?? 0;
    final ob = ref.watch(onboardingProvider(profileId)).valueOrNull;
    final lv = LevelEngine().resolve(xp);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + name.
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Palette.green,
                child: const Text('🦉',
                    style:
                        TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admission Adventurer',
                        style: theme.textTheme.titleLarge),
                    Text('Level ${lv.level} • ${LevelEngine().titleFor(lv.level)}',
                        style: TextStyle(color: theme.hintColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(icon: Icons.star, value: '$xp', label: 'Total XP', color: Palette.green)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(icon: Icons.diamond, value: '$gems', label: 'Gems', color: Palette.yellow)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: StatCard(icon: Icons.local_fire_department, value: '$streak', label: 'Day streak', color: Palette.red)),
              const SizedBox(width: 10),
              Expanded(child: StatCard(icon: Icons.flag, value: '${ob?.readinessScore ?? 0}', label: 'Readiness', color: Palette.blue)),
            ],
          ),
          const SizedBox(height: 20),
          SectionTitle('Appearance'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                _ThemeTile(
                  title: 'Light',
                  icon: Icons.light_mode,
                  selected: mode == AppThemeMode.light,
                  onTap: () => ref.read(themeModeProvider.notifier).set(AppThemeMode.light),
                ),
                _ThemeTile(
                  title: 'Dark',
                  icon: Icons.dark_mode,
                  selected: mode == AppThemeMode.dark,
                  onTap: () => ref.read(themeModeProvider.notifier).set(AppThemeMode.dark),
                ),
                _ThemeTile(
                  title: 'System',
                  icon: Icons.settings_brightness,
                  selected: mode == AppThemeMode.system,
                  onTap: () => ref.read(themeModeProvider.notifier).set(AppThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionTitle('Your profile'),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Edit onboarding details'),
            subtitle: Text(ob == null
                ? 'Not set up yet'
                : 'Grades, activities, competitions saved'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/onboarding'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            tileColor: theme.cardColor,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Palette.yellow),
            title: const Text('Achievements & badges'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // badges page exists; could push
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            tileColor: theme.cardColor,
          ),
          const SizedBox(height: 16),
          Text(
              'ProfileForge builds your plan from real answers — no blind templates.',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile(
      {required this.title,
      required this.icon,
      required this.selected,
      required this.onTap});
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: selected ? Palette.green : null),
        title: Text(title),
        trailing: selected
            ? const Icon(Icons.check_circle, color: Palette.green)
            : null,
        onTap: onTap,
        selected: selected,
        selectedTileColor: Palette.green.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
}
