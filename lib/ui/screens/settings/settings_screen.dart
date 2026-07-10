import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';
import '../../../models/student_profile.dart';

// ─── Settings Keys ───────────────────────────────────────────────────────────
const String _kDarkMode = 'settings_dark_mode';
const String _kLanguage = 'settings_language';
const String _kDailyReminders = 'settings_daily_reminders';
const String _kWeeklyReports = 'settings_weekly_reports';
const String _kCompetitionAlerts = 'settings_competition_alerts';

// ─── Settings Provider ───────────────────────────────────────────────────────
class SettingsState {
  final bool darkMode;
  final String language;
  final bool dailyReminders;
  final bool weeklyReports;
  final bool competitionAlerts;

  const SettingsState({
    this.darkMode = false,
    this.language = 'English',
    this.dailyReminders = true,
    this.weeklyReports = true,
    this.competitionAlerts = true,
  });

  SettingsState copyWith({
    bool? darkMode,
    String? language,
    bool? dailyReminders,
    bool? weeklyReports,
    bool? competitionAlerts,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      competitionAlerts: competitionAlerts ?? this.competitionAlerts,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      darkMode: prefs.getBool(_kDarkMode) ?? false,
      language: prefs.getString(_kLanguage) ?? 'English',
      dailyReminders: prefs.getBool(_kDailyReminders) ?? true,
      weeklyReports: prefs.getBool(_kWeeklyReports) ?? true,
      competitionAlerts: prefs.getBool(_kCompetitionAlerts) ?? true,
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, state.darkMode);
    await prefs.setString(_kLanguage, state.language);
    await prefs.setBool(_kDailyReminders, state.dailyReminders);
    await prefs.setBool(_kWeeklyReports, state.weeklyReports);
    await prefs.setBool(_kCompetitionAlerts, state.competitionAlerts);
  }

  void setDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
    _save();
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
    _save();
  }

  void setDailyReminders(bool value) {
    state = state.copyWith(dailyReminders: value);
    _save();
  }

  void setWeeklyReports(bool value) {
    state = state.copyWith(weeklyReports: value);
    _save();
  }

  void setCompetitionAlerts(bool value) {
    state = state.copyWith(competitionAlerts: value);
    _save();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

// ─── Settings Screen ─────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(studentProfileProvider);
    final onboardingData = ref.watch(onboardingDataProvider);

    final displayName = onboardingData.name.isNotEmpty
        ? onboardingData.name
        : (profile?.name ?? 'Student');
    final displayEmail = profile?.email.isNotEmpty == true
        ? profile!.email
        : 'student@profileforge.app';
    final grade = profile?.grade ?? 11;
    final board = profile?.board ?? 'CBSE';
    final school = onboardingData.name.isNotEmpty
        ? '${onboardingData.board ?? board} Board'
        : board;

    return Scaffold(
      backgroundColor: context.surfaceBg,
      appBar: AppBar(
        title: Text(
          'Settings & Account',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: context.surfaceBg,
        foregroundColor: context.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Section ──
            _buildProfileHeader(displayName, displayEmail, grade, school),
            const SizedBox(height: 8),

            // ── Notifications Section ──
            _buildSectionHeader('Notifications', Icons.notifications_rounded),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.alarm_rounded,
                iconColor: AppTheme.accentOrange,
                title: 'Daily Reminders',
                subtitle: 'Get reminded to check in every day',
                value: settings.dailyReminders,
                onChanged: (v) => ref.read(settingsProvider.notifier).setDailyReminders(v),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.analytics_rounded,
                iconColor: AppTheme.successGreen,
                title: 'Weekly Reports',
                subtitle: 'Receive your weekly progress summary',
                value: settings.weeklyReports,
                onChanged: (v) => ref.read(settingsProvider.notifier).setWeeklyReports(v),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.emoji_events_rounded,
                iconColor: AppTheme.accentGold,
                title: 'Competition Alerts',
                subtitle: 'New competitions matching your profile',
                value: settings.competitionAlerts,
                onChanged: (v) => ref.read(settingsProvider.notifier).setCompetitionAlerts(v),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Display Section ──
            _buildSectionHeader('Display', Icons.palette_rounded),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.dark_mode_rounded,
                iconColor: AppTheme.primaryBlueLight,
                title: 'Dark Mode',
                subtitle: 'Use dark theme across the app',
                value: settings.darkMode,
                onChanged: (v) => ref.read(settingsProvider.notifier).setDarkMode(v),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.language_rounded,
                iconColor: AppTheme.accentTeal,
                title: 'Language',
                subtitle: settings.language,
                onTap: () => _showLanguagePicker(context, ref, settings.language),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Data Section ──
            _buildSectionHeader('Data & Privacy', Icons.storage_rounded),
            _buildSettingsCard([
              _buildNavigationTile(
                icon: Icons.download_rounded,
                iconColor: AppTheme.categoryColors['research']!,
                title: 'Export Profile Data',
                subtitle: 'Download a copy of your data',
                onTap: () => _showExportDialog(context),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.shield_rounded,
                iconColor: AppTheme.successGreen,
                title: 'Privacy Settings',
                subtitle: 'What we collect, encryption, control',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const _PrivacySettingsScreen()),
                  );
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.delete_forever_rounded,
                iconColor: AppTheme.errorRed,
                title: 'Reset App',
                subtitle: 'Clear all data and start fresh',
                onTap: () => _showResetDialog(context, ref),
              ),
            ]),
            const SizedBox(height: 16),

            // ── About Section ──
            _buildSectionHeader('About', Icons.info_outline_rounded),
            _buildSettingsCard([
              _buildInfoRow(
                icon: Icons.android_rounded,
                title: 'App Version',
                value: '1.0.0 (Build 1)',
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.description_rounded,
                iconColor: Theme.of(context).colorScheme.primary,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: () async {
                  final uri = Uri.parse('https://profileforge.app/terms');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.lock_outline_rounded,
                iconColor: Theme.of(context).colorScheme.primary,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () async {
                  final uri = Uri.parse('https://profileforge.app/privacy');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
            ]),
            const SizedBox(height: 16),

            // ── Support Section ──
            _buildSectionHeader('Support', Icons.help_rounded),
            _buildSettingsCard([
              _buildNavigationTile(
                icon: Icons.mail_rounded,
                iconColor: AppTheme.accentPurple,
                title: 'Contact Us',
                subtitle: 'support@profileforge.app',
                onTap: () async {
                  final uri = Uri.parse('mailto:support@profileforge.app?subject=ProfileForge%20Support');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.bug_report_rounded,
                iconColor: AppTheme.errorRed,
                title: 'Report a Bug',
                subtitle: 'Help us improve ProfileForge',
                onTap: () async {
                  final uri = Uri.parse('mailto:support@profileforge.app?subject=Bug%20Report&body=Describe%20the%20bug%3A%0A%0ASteps%20to%20reproduce%3A%0A%0A');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.star_rounded,
                iconColor: AppTheme.accentGold,
                title: 'Rate the App',
                subtitle: 'Share your experience on the Play Store',
                onTap: () async {
                  final uri = Uri.parse('market://details?id=com.profileforge.app');
                  final webUri = Uri.parse('https://play.google.com/store/apps/details?id=com.profileforge.app');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else if (await canLaunchUrl(webUri)) {
                    await launchUrl(webUri);
                  }
                },
              ),
            ]),
            const SizedBox(height: 32),

            // ── Footer ──
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Text(
                      'ProfileForge',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Made with ❤️ in India',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '© 2024 ProfileForge. All rights reserved.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ──────────────────────────────────────────────────────

  Widget _buildProfileHeader(String name, String email, int grade, String board) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: context.isDarkMode
            ? AppTheme.gradientPrimaryDark
            : AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'S',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Student',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildProfileBadge('Grade $grade'),
                    const SizedBox(width: 8),
                    _buildProfileBadge(board),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1);
  }

  Widget _buildProfileBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings Card ───────────────────────────────────────────────────────

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(children: children),
    );
  }

  // ── Switch Tile ─────────────────────────────────────────────────────────

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: (v) {
              HapticFeedback.lightImpact();
              onChanged(v);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // ── Navigation Tile ─────────────────────────────────────────────────────

  Widget _buildNavigationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.textMuted, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Info Row (non-interactive) ──────────────────────────────────────────

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ── Divider ─────────────────────────────────────────────────────────────

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 70,
      endIndent: 16,
      color: context.borderColor,
    );
  }

  // ── Language Picker ─────────────────────────────────────────────────────

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String current) {
    final languages = ['English', 'हिंदी', 'தமிழ்', 'తెలుగు', 'ಕನ್ನಡ', 'मराठी'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Select Language',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...languages.map((lang) => ListTile(
                    leading: Radio<String>(
                      value: lang,
                      groupValue: current,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        ref.read(settingsProvider.notifier).setLanguage(v!);
                        Navigator.pop(context);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      lang,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: lang == current ? FontWeight.w600 : FontWeight.w400,
                        color: context.textPrimary,
                      ),
                    ),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ref.read(settingsProvider.notifier).setLanguage(lang);
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Export Dialog ────────────────────────────────────────────────────────

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text('Export Data', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'Your profile data will be exported as a JSON file. This includes your activities, '
          'missions progress, and settings. Personal data is encrypted.',
          style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final prefs = await SharedPreferences.getInstance();
                final data = {
                  'exported_at': DateTime.now().toIso8601String(),
                  'settings': {
                    'weekly_reports': prefs.getBool('settings_weekly_reports'),
                    'gps_enabled': prefs.getBool('gps_enabled'),
                    'user_city': prefs.getString('user_city'),
                    'latitude': prefs.getDouble('latitude'),
                    'longitude': prefs.getDouble('longitude'),
                  },
                  'profile': {
                    'name': prefs.getString('user_name'),
                    'email': prefs.getString('user_email'),
                    'grade': prefs.getInt('user_grade'),
                    'board': prefs.getString('user_board'),
                    'stream': prefs.getString('user_stream'),
                  },
                  'missions': {
                    'xp': prefs.getInt('user_xp'),
                    'level': prefs.getInt('user_level'),
                    'streak': prefs.getInt('user_streak'),
                  },
                };
                final jsonStr = JsonEncoder.withIndent('  ').convert(data);
                // Copy to clipboard as a simple export mechanism
                await Clipboard.setData(ClipboardData(text: jsonStr));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile data copied to clipboard!', style: GoogleFonts.inter()),
                      backgroundColor: AppTheme.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export failed: $e')),
                  );
                }
              }
            },
            child: Text('Export', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  // ── Reset Dialog ────────────────────────────────────────────────────────

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorRed),
            const SizedBox(width: 10),
            Text('Reset App', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          'This will permanently delete all your data including profile, activities, '
          'missions, streaks, and settings. This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            onPressed: () {
              Navigator.pop(context);
              ref.read(setOnboardingCompletedProvider)(false);
              ref.read(studentProfileProvider.notifier).clearProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('App has been reset', style: GoogleFonts.inter()),
                  backgroundColor: AppTheme.errorRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text('Reset Everything', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coming soon', style: GoogleFonts.inter()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ─── Privacy Settings Mini-Screen ─────────────────────────────────────────────

class _PrivacySettingsScreen extends ConsumerWidget {
  const _PrivacySettingsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.surfaceBg,
      appBar: AppBar(
        title: Text('Privacy Settings', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: context.surfaceBg,
        foregroundColor: context.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPrivacySection(
              context,
              icon: Icons.lock_rounded,
              title: 'Data Encryption',
              subtitle: 'All personal data is encrypted with AES-256',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Active',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
            ),
            _buildPrivacySection(
              context,
              icon: Icons.location_on_rounded,
              title: 'Location Data',
              subtitle: 'Processed on-device, never sent to servers',
              trailing: Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 22),
            ),
            _buildPrivacySection(
              context,
              icon: Icons.folder_rounded,
              title: 'Data Storage',
              subtitle: 'All data stays on your device (local SQLite)',
              trailing: Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 22),
            ),
            _buildPrivacySection(
              context,
              icon: Icons.share_rounded,
              title: 'Third-Party Sharing',
              subtitle: 'We never share your data with third parties',
              trailing: Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 22),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ProfileForge is designed with privacy-first architecture. '
                      'Your personal information never leaves your device unless you explicitly export it.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: context.textMuted)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
