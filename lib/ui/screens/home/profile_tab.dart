import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/student_profile.dart';
import '../../../models/gamification/skins.dart';
import '../../../models/opportunity_feed.dart';
import '../../../providers/providers.dart';
import '../settings/settings_screen.dart';
import '../privacy/privacy_screen.dart';
import 'widgets/shared_widgets.dart';

/// Profile tab — comprehensive student profile with stats, target universities,
/// activity summary, and settings access.
class ProfileTab extends ConsumerWidget {
  final ValueChanged<int> onTabChange;

  const ProfileTab({super.key, required this.onTabChange});

  /// Maps an ActivityCategory enum value to the lowercase color key used by AppColors.categoryColors.
  static String _categoryColorKey(ActivityCategory cat) {
    switch (cat) {
      case ActivityCategory.work:
        return 'work';
      default:
        return cat.name; // clubs, sports, arts, competitions, research, volunteering, leadership, courses, unique
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
            icon: const Icon(Icons.analytics_rounded),
            tooltip: 'Statistics',
            semanticLabel: 'Open statistics',
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            semanticLabel: 'Edit profile',
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
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
                          label: 'Streak', value: '${streak.currentStreak} days'),
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
                  value: '$totalXP',
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
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(
                          'Complete onboarding to set target universities',
                          style: TextStyle(fontSize: 13),
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
                      final displayCat =
                          cat.name[0].toUpperCase() + cat.name.substring(1);
                      return _ActivitySummaryRow(
                          category: displayCat, count: count, xp: xpVal);
                    }).toList()
                  : [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Text(
                          'Add activities in onboarding to see your summary',
                          style: TextStyle(fontSize: 13),
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
                  semanticLabel: 'Open notifications settings',
                ),
                _SettingsRow(
                  icon: Icons.dark_mode_rounded,
                  title: 'Appearance & Language',
                  subtitle: 'Dark mode, themes, regional languages',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                  semanticLabel: 'Open appearance and language settings',
                ),
                _SettingsRow(
                  icon: Icons.storage_rounded,
                  title: 'Data & Privacy',
                  subtitle: 'Export data, privacy settings, terms',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                  semanticLabel: 'Open data and privacy settings',
                ),
                _SettingsRow(
                  icon: Icons.shield_rounded,
                  title: 'Privacy & Data',
                  subtitle: 'What we collect, where it stays',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  ),
                  semanticLabel: 'Open privacy and data settings',
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

/// Simple stat item for the profile header.
class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value, super.key});

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

/// Quick stat item for the row under the profile header.
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 11, color: context.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section card with a title and children.
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    this.icon,
    required this.children,
    super.key,
  });

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

/// Target university row with probability badge.
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
    final probPct = (probability * 100).round();
    Color probColor;
    if (probPct >= 70) probColor = AppTheme.successGreen;
    else if (probPct >= 40) probColor = AppTheme.warningAmber;
    else probColor = AppTheme.errorRed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isReach ? AppTheme.errorRed : probColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                if (major.isNotEmpty || country.isNotEmpty)
                  Text(
                    [major, country].where((s) => s.isNotEmpty).join(' • '),
                    style: GoogleFonts.inter(
                        fontSize: 12, color: context.textMuted),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: probColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$probPct%',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: probColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Activity summary row.
class _ActivitySummaryRow extends StatelessWidget {
  final String category;
  final int count;
  final int xp;

  const _ActivitySummaryRow(
      {required this.category, required this.count, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(category,
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Text('$count',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$xp XP',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings row.
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? semanticLabel;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  size: 20, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: context.textMuted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: context.textMuted),
          ],
        ),
      ),
    );
    child = MergeSemantics(child: child);
    if (semanticLabel != null) {
      child = Semantics(
        label: semanticLabel,
        button: true,
        child: child,
      );
    }
    return child;
  }
  }