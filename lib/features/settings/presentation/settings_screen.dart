import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Unified Settings Screen — All app settings in one place.
///
/// Sections:
/// - Account (name, email, profile)
/// - AI Settings (provider config, API keys)
/// - Appearance (theme, notifications)
/// - Data & Privacy
/// - About & Support
///
/// Based on research:
/// - 09-comprehensive-data-privacy-security.md
/// - 10-cross-platform-responsive-design.md
/// ────────────────────────────────────────────────────────────────────────────
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _userName = '';
  String _userEmail = '';
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  bool _hapticFeedback = true;
  String _aiProvider = 'None';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('pf_user_name') ?? '';
      _userEmail = prefs.getString('pf_user_email') ?? '';
      _notificationsEnabled = prefs.getBool('pf_notifications') ?? true;
      _darkMode = prefs.getBool('pf_dark_mode') ?? true;
      _hapticFeedback = prefs.getBool('pf_haptic_feedback') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              _buildHeader(dark),

              // ── Settings List ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // ── Account Section ──
                    _buildSection(
                      title: 'Account',
                      icon: Icons.person_outline,
                      dark: dark,
                      children: [
                        _SettingsTile(
                          icon: Icons.person,
                          title: 'Profile',
                          subtitle: _userName.isNotEmpty ? _userName : 'Set your name',
                          onTap: () => _showEditProfileSheet(dark),
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          subtitle: _userEmail.isNotEmpty ? _userEmail : 'Add email',
                          onTap: () => _showEditEmailSheet(dark),
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.psychology,
                          title: 'Psychology Profile',
                          subtitle: 'View your personality traits',
                          onTap: () => context.push('/profile-score'),
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.score,
                          title: 'Profile Score',
                          subtitle: 'View your admission readiness',
                          onTap: () => context.push('/profile-score'),
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── AI Section ──
                    _buildSection(
                      title: 'AI Settings',
                      icon: Icons.auto_awesome,
                      dark: dark,
                      children: [
                        _SettingsTile(
                          icon: Icons.api,
                          title: 'API Keys',
                          subtitle: 'Configure AI providers',
                          onTap: () => context.push('/ai-settings'),
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.chat_bubble_outline,
                          title: 'AI Chat',
                          subtitle: 'Psychology-adapted conversation',
                          onTap: () => context.push('/ai-chat'),
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Appearance Section ──
                    _buildSection(
                      title: 'Appearance',
                      icon: Icons.palette_outlined,
                      dark: dark,
                      children: [
                        _SettingsSwitch(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() => _darkMode = value);
                            _saveSetting('pf_dark_mode', value);
                            ref.read(themeModeProvider.notifier).set(
                                value ? AppThemeMode.dark : AppThemeMode.light);
                          },
                          dark: dark,
                        ),
                        _SettingsSwitch(
                          icon: Icons.vibration,
                          title: 'Haptic Feedback',
                          value: _hapticFeedback,
                          onChanged: (value) {
                            setState(() => _hapticFeedback = value);
                            _saveSetting('pf_haptic_feedback', value);
                          },
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Notifications Section ──
                    _buildSection(
                      title: 'Notifications',
                      icon: Icons.notifications_outlined,
                      dark: dark,
                      children: [
                        _SettingsSwitch(
                          icon: Icons.notifications,
                          title: 'Enable Notifications',
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                            _saveSetting('pf_notifications', value);
                          },
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Data & Privacy Section ──
                    _buildSection(
                      title: 'Data & Privacy',
                      icon: Icons.shield_outlined,
                      dark: dark,
                      children: [
                        _SettingsTile(
                          icon: Icons.download,
                          title: 'Export Data',
                          subtitle: 'Download your data',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Export feature coming soon'),
                                backgroundColor: Palette.info,
                              ),
                            );
                          },
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.delete_outline,
                          title: 'Clear Data',
                          subtitle: 'Remove all local data',
                          onTap: () => _showClearDataDialog(dark),
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Privacy policy coming soon'),
                                backgroundColor: Palette.info,
                              ),
                            );
                          },
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── About Section ──
                    _buildSection(
                      title: 'About',
                      icon: Icons.info_outline,
                      dark: dark,
                      children: [
                        _SettingsTile(
                          icon: Icons.star_outline,
                          title: 'Rate ProfileForge',
                          subtitle: 'Help us improve',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Rating feature coming soon'),
                                backgroundColor: Palette.info,
                              ),
                            );
                          },
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get assistance',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Support feature coming soon'),
                                backgroundColor: Palette.info,
                              ),
                            );
                          },
                          dark: dark,
                        ),
                        _SettingsTile(
                          icon: Icons.code,
                          title: 'Version',
                          subtitle: '1.0.0 (Build 1)',
                          onTap: null,
                          dark: dark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 12),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Settings',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
        ],
      ),
    );
  }

  /// ── Section Builder ──────────────────────────────────────────────────────
  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool dark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Palette.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Palette.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.6)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dark
                  ? Palette.border.withValues(alpha: 0.4)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 52,
                      color: dark
                          ? Palette.border.withValues(alpha: 0.3)
                          : const Color(0xFFF1F5F9),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  /// ── Edit Profile Sheet ───────────────────────────────────────────────────
  void _showEditProfileSheet(bool dark) {
    final controller = TextEditingController(text: _userName);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: dark ? Palette.surface0 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Name',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Your name',
                filled: true,
                fillColor: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await _saveSetting('pf_user_name', controller.text.trim());
                setState(() => _userName = controller.text.trim());
                if (mounted) Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  /// ── Edit Email Sheet ─────────────────────────────────────────────────────
  void _showEditEmailSheet(bool dark) {
    final controller = TextEditingController(text: _userEmail);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: dark ? Palette.surface0 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Email',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'your@email.com',
                filled: true,
                fillColor: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await _saveSetting('pf_user_email', controller.text.trim());
                setState(() => _userEmail = controller.text.trim());
                if (mounted) Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  /// ── Clear Data Dialog ────────────────────────────────────────────────────
  void _showClearDataDialog(bool dark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Data?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        content: Text(
          'This will remove all your profile data, settings, and AI configurations. This cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Palette.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared'),
                    backgroundColor: Palette.error,
                  ),
                );
              }
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Palette.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Settings Tile ──────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.dark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: dark ? Palette.textTertiary : Palette.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// ── Settings Switch ────────────────────────────────────────────────────────
class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.dark,
  });

  final IconData icon;
  final String title;
  final bool value;
  final Function(bool) onChanged;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Palette.primary,
            activeTrackColor: Palette.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
