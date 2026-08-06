import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/glass_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SettingsMainScreen — Central settings hub.
///
/// Sections:
/// - Account (profile, email, password)
/// - Preferences (theme, language, notifications)
/// - AI Settings (provider, model)
/// - Data (export, import, clear)
/// - Support (help, feedback, rate)
/// - About (version, licenses)
/// ────────────────────────────────────────────────────────────────────────────
class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Account Section ──
                      _buildSectionHeader('Account', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            subtitle: 'Name, email, avatar',
                            onTap: () => Navigator.pushNamed(context, '/profile-edit'),
                          ),
                          _SettingsItem(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            subtitle: 'Update your password',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.delete_outline,
                            title: 'Delete Account',
                            subtitle: 'Permanently delete your account',
                            onTap: () {},
                            isDestructive: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Preferences Section ──
                      _buildSectionHeader('Preferences', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.dark_mode_outlined,
                            title: 'Theme',
                            subtitle: 'System',
                            onTap: () => Navigator.pushNamed(context, '/theme-switcher'),
                          ),
                          _SettingsItem(
                            icon: Icons.language,
                            title: 'Language',
                            subtitle: 'English',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Manage notification preferences',
                            onTap: () => Navigator.pushNamed(context, '/notifications'),
                          ),
                          _SettingsItem(
                            icon: Icons.vibration,
                            title: 'Haptic Feedback',
                            subtitle: 'Enabled',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── AI Settings Section ──
                      _buildSectionHeader('AI Settings', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.key,
                            title: 'API Key',
                            subtitle: 'Configure AI provider',
                            onTap: () => Navigator.pushNamed(context, '/api-key-setup'),
                          ),
                          _SettingsItem(
                            icon: Icons.smart_toy_outlined,
                            title: 'AI Model',
                            subtitle: 'Claude 3.5 Sonnet',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.tune,
                            title: 'AI Personality',
                            subtitle: 'Coach',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Data Section ──
                      _buildSectionHeader('Data', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.download,
                            title: 'Export Data',
                            subtitle: 'Download your data as JSON',
                            onTap: () => Navigator.pushNamed(context, '/data-export-import'),
                          ),
                          _SettingsItem(
                            icon: Icons.upload,
                            title: 'Import Data',
                            subtitle: 'Restore from JSON backup',
                            onTap: () => Navigator.pushNamed(context, '/data-export-import'),
                          ),
                          _SettingsItem(
                            icon: Icons.delete_sweep,
                            title: 'Clear All Data',
                            subtitle: 'Reset app to defaults',
                            onTap: () {},
                            isDestructive: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Support Section ──
                      _buildSectionHeader('Support', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.help_outline,
                            title: 'Help & FAQ',
                            subtitle: 'Get help with ProfileForge',
                            onTap: () => Navigator.pushNamed(context, '/help'),
                          ),
                          _SettingsItem(
                            icon: Icons.feedback_outlined,
                            title: 'Send Feedback',
                            subtitle: 'Report issues or suggest features',
                            onTap: () => Navigator.pushNamed(context, '/help'),
                          ),
                          _SettingsItem(
                            icon: Icons.star_border,
                            title: 'Rate ProfileForge',
                            subtitle: 'Rate us on the app store',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.share,
                            title: 'Share with Friends',
                            subtitle: 'Invite friends to ProfileForge',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── About Section ──
                      _buildSectionHeader('About', dark),
                      const SizedBox(height: 8),
                      _buildSettingsGroup(
                        dark,
                        items: [
                          _SettingsItem(
                            icon: Icons.info_outline,
                            title: 'Version',
                            subtitle: '1.0.0 (Build 42)',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.description_outlined,
                            title: 'Licenses',
                            subtitle: 'Open source licenses',
                            onTap: () => showLicensePage(
                              context: context,
                              applicationName: 'ProfileForge',
                              applicationVersion: '1.0.0',
                            ),
                          ),
                          _SettingsItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'How we handle your data',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.gavel,
                            title: 'Terms of Service',
                            subtitle: 'App terms and conditions',
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ── App Logo ──
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: Palette.gradientPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.school,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ProfileForge',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: dark ? Palette.textSecondary : Palette.textTertiary,
                              ),
                            ),
                            Text(
                              'v1.0.0',
                              style: TextStyle(
                                fontSize: 11,
                                color: Palette.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: dark ? Palette.textTertiary : Palette.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsGroup(bool dark, {required List<_SettingsItem> items}) {
    return GlassContainer(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Divider
            return Divider(
              height: 1,
              indent: 52,
              color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
            );
          }

          final itemIndex = index ~/ 2;
          final item = items[itemIndex];

          return _buildSettingsItem(item, dark);
        }),
      ),
    );
  }

  Widget _buildSettingsItem(_SettingsItem item, bool dark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        item.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? Palette.error.withValues(alpha: 0.12)
                    : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 18,
                color: item.isDestructive
                    ? Palette.error
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: item.isDestructive
                          ? Palette.error
                          : (dark ? Palette.textPrimary : Palette.textInverse),
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Palette.textTertiary : Palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: dark ? Palette.textTertiary : Palette.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}
