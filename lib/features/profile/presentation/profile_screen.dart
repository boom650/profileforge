import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/game/level.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileScreen v2 — Premium dark profile with glassmorphism cards.
/// Hero header → stats grid → appearance → profile settings → footer.
/// ────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final mode = ref.watch(themeModeProvider);
    final xp = ref.watch(totalXpProvider(profileId)).valueOrNull ?? 0;
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;
    final streak = ref.watch(streakProvider(profileId)).valueOrNull?.current ?? 0;
    final ob = ref.watch(onboardingProvider(profileId)).valueOrNull;
    final lv = LevelEngine().resolve(xp);
    final levelTitle = LevelEngine().titleFor(lv.level);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      'Profile',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    // Settings icon.
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        size: 20,
                        color: dark ? Palette.textSecondary : Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Hero card: avatar + name + level ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientBanner(
                  gradient: Palette.gradientPrimary,
                  child: Row(
                    children: [
                      // Avatar.
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text('🦉', style: TextStyle(fontSize: 32)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admission Adventurer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level ${lv.level} • $levelTitle',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // XP progress.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: lv.intoLevel / lv.levelSpan,
                                minHeight: 6,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Stats grid ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _StatCard(icon: Icons.bolt, value: '$xp', label: 'Total XP', color: Palette.warning)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard(icon: Icons.diamond, value: '$gems', label: 'Gems', color: Palette.info)),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _StatCard(icon: Icons.local_fire_department, value: '$streak', label: 'Streak', color: Palette.error)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard(icon: Icons.flag, value: '${ob?.readinessScore ?? 0}', label: 'Readiness', color: Palette.accent)),
                  ],
                ),
              ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Appearance ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle('Appearance'),
              ).animate().fadeIn(delay: 300.ms),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(4),
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
              ).animate().fadeIn(delay: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Profile settings ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle('Your profile'),
              ).animate().fadeIn(delay: 400.ms),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.edit_note,
                        title: 'Edit onboarding details',
                        subtitle: ob == null ? 'Not set up yet' : 'Grades, activities, competitions saved',
                        onTap: () => context.push('/onboarding'),
                      ),
                      _SettingsTile(
                        icon: Icons.emoji_events_outlined,
                        title: 'Achievements & badges',
                        onTap: () => context.push('/badges'),
                      ),
                      _SettingsTile(
                        icon: Icons.share_outlined,
                        title: 'Share progress',
                        onTap: () => context.push('/share'),
                      ),
                      _SettingsTile(
                        icon: Icons.auto_awesome,
                        title: 'AI settings',
                        subtitle: 'Configure Gemini API key',
                        onTap: () => context.push('/ai-settings'),
                      ),
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: 'About ProfileForge',
                        subtitle: 'v1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // ── Footer ──
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'ProfileForge builds your plan from real answers — no blind templates.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor?.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat card with glassmorphism.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark ? Palette.textSecondary : Palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme tile.
class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Palette.primary : (dark ? Palette.textSecondary : Palette.textTertiary),
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: selected ? Palette.primary : (dark ? Palette.textPrimary : Palette.textInverse),
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Palette.primary, size: 20)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}

/// Settings tile.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return ListTile(
      leading: Icon(
        icon,
        color: dark ? Palette.textSecondary : Palette.textTertiary,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: dark ? Palette.textPrimary : Palette.textInverse,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: dark ? Palette.textTertiary : Palette.textTertiary,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}
