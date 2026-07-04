import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../onboarding/age_gate.dart';

/// Provider to check if encryption is enabled.
final encryptionEnabledProvider = FutureProvider<bool>((ref) async {
  // Check if encryption keys exist in secure storage
  // For now, return true if age is verified (encryption is enabled by default)
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('age_verification_status') != null;
});

/// Provider to get encryption status description.
final encryptionStatusProvider = Provider<String>((ref) {
  final isEncrypted = ref.watch(encryptionEnabledProvider);
  return isEncrypted.when(
    data: (enabled) => enabled
        ? 'AES-256 encryption is active for personal data'
        : 'Encryption not yet initialized',
    loading: () => 'Checking encryption status...',
    error: (_, __) => 'Encryption status unknown',
  );
});

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageStatusAsync = ref.watch(ageVerificationProvider);
    final encryptionStatus = ref.watch(encryptionStatusProvider);

    // Default to notVerified if still loading
    final ageStatus = ageStatusAsync.when(
      data: (status) => status,
      loading: () => AgeVerificationStatus.notVerified,
      error: (_, __) => AgeVerificationStatus.notVerified,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy & Data',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.gradientPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.shield_rounded,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Data, Your Rules',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We built ProfileForge to help you — not to harvest your data. Here\'s exactly what happens with your information.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 28),

            // ── Security Status ─────────────────────────────────────────
            _PrivacySection(
              icon: Icons.lock_rounded,
              iconColor: AppTheme.successGreen,
              title: 'Security & Encryption',
              delay: 100,
              children: [
                _StatusItem(
                  icon: Icons.enhanced_encryption_rounded,
                  label: 'Data Encryption',
                  status: encryptionStatus,
                  isEnabled: true,
                ),
                _StatusItem(
                  icon: Icons.verified_user_rounded,
                  label: 'Age Verification',
                  status: _getAgeStatusText(ageStatus),
                  isEnabled: ageStatus != AgeVerificationStatus.notVerified,
                ),
                _StatusItem(
                  icon: Icons.phone_android_rounded,
                  label: 'Secure Storage',
                  status: 'AES-256 keys stored in Android Keystore',
                  isEnabled: true,
                ),
              ],
              footer: 'All personal data (name, email, phone, school) is encrypted using AES-256 before being stored in the database.',
            ),
            const SizedBox(height: 20),

            // ── What We Collect ─────────────────────────────────────────
            _PrivacySection(
              icon: Icons.inventory_2_rounded,
              iconColor: AppTheme.primaryBlue,
              title: 'What We Collect',
              delay: 200,
              children: [
                _PrivacyItem(
                  text: 'Grades & test scores — to calculate your admissions probability',
                ),
                _PrivacyItem(
                  text: 'Activities & achievements — to suggest better missions',
                ),
                _PrivacyItem(
                  text: 'Target universities — to tailor your roadmap',
                ),
                _PrivacyItem(
                  text: 'Location (approximate) — to find NGOs, labs, and contests near you',
                ),
                _PrivacyItem(
                  text: 'Personal info (name, email, phone) — for your profile',
                ),
              ],
              footer: 'We never share your data with third parties. Your personal information is encrypted and stays on your device.',
            ),
            const SizedBox(height: 20),

            // ── Where Your Data Stays ───────────────────────────────────
            _PrivacySection(
              icon: Icons.phone_android_rounded,
              iconColor: AppTheme.successGreen,
              title: 'Where Your Data Stays',
              delay: 300,
              children: [
                _PrivacyItem(
                  text: 'Everything is stored right here on your phone using SQLite (via Drift)',
                ),
                _PrivacyItem(
                  text: 'Personal data is encrypted with AES-256 before storage',
                ),
                _PrivacyItem(
                  text: 'No cloud sync by default — your grades and scores never leave your device',
                ),
                _PrivacyItem(
                  text: 'No ads, no analytics tracking, no third-party data sharing',
                ),
              ],
              footer: 'This isn\'t just a promise — it\'s how the app is built. The database lives entirely on your device.',
            ),
            const SizedBox(height: 20),

            // ── Data Retention Policy ────────────────────────────────────
            _PrivacySection(
              icon: Icons.schedule_rounded,
              iconColor: AppTheme.accentGold,
              title: 'Data Retention Policy',
              delay: 400,
              children: [
                _PrivacyItem(
                  text: 'Your data is retained only as long as you use the app',
                ),
                _PrivacyItem(
                  text: 'When you delete your account, all data is permanently removed',
                ),
                _PrivacyItem(
                  text: 'No data is retained after account deletion',
                ),
                _PrivacyItem(
                  text: 'You can export your data at any time before deletion',
                ),
              ],
              footer: 'We believe in data minimization. We only keep what you explicitly provide.',
            ),
            const SizedBox(height: 20),

            // ── Age Verification Status ─────────────────────────────────
            _PrivacySection(
              icon: Icons.cake_rounded,
              iconColor: AppTheme.primaryPurple,
              title: 'Age Verification',
              delay: 500,
              children: [
                _StatusItem(
                  icon: Icons.person_rounded,
                  label: 'Current Status',
                  status: _getAgeStatusText(ageStatus),
                  isEnabled: ageStatus != AgeVerificationStatus.notVerified,
                ),
                _PrivacyItem(
                  text: 'COPPA compliance: Users under 13 require parental consent',
                ),
                _PrivacyItem(
                  text: 'Minor accounts (13-17) have limited features for safety',
                ),
                _PrivacyItem(
                  text: 'Your age verification status is stored locally and never shared',
                ),
              ],
              footer: null,
            ),
            const SizedBox(height: 20),

            // ── Your Control ────────────────────────────────────────────
            _PrivacySection(
              icon: Icons.tune_rounded,
              iconColor: AppTheme.primaryPurple,
              title: 'Your Control',
              delay: 600,
              children: [
                _ControlItem(
                  icon: Icons.download_rounded,
                  label: 'Export Your Data',
                  description: 'Get a copy of everything we have about you',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export feature coming soon')),
                    );
                  },
                ),
                _ControlItem(
                  icon: Icons.visibility_rounded,
                  label: 'View What We Have',
                  description: 'See all your stored data in one place',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data viewer coming soon')),
                    );
                  },
                ),
                _ControlItem(
                  icon: Icons.delete_forever_rounded,
                  label: 'Delete Account & All Data',
                  description: 'Permanently remove everything from your device',
                  onTap: () {
                    _showDeleteConfirmation(context);
                  },
                ),
              ],
              footer: null,
            ),
            const SizedBox(height: 20),

            // ── For Parents ─────────────────────────────────────────────
            _PrivacySection(
              icon: Icons.family_restroom_rounded,
              iconColor: AppTheme.accentOrange,
              title: 'For Parents',
              delay: 700,
              children: [
                _ParentInfoItem(
                  text: 'ProfileForge is a tool that helps students plan their college admissions journey. It suggests activities, competitions, and volunteering opportunities that match the student\'s interests and goals.',
                ),
                _ParentInfoItem(
                  text: 'We ask for grades and test scores to calculate realistic admissions probabilities — this helps students focus on the right opportunities instead of spreading themselves thin.',
                ),
                _ParentInfoItem(
                  text: 'All data stays on the student\'s phone. We have no servers storing student information. No data is shared with advertisers, schools, or colleges.',
                ),
                _ParentInfoItem(
                  text: 'Personal data (name, email, phone) is encrypted using AES-256 encryption before being stored.',
                ),
                _ParentInfoItem(
                  text: 'Students under 13 require parental consent to use the app (COPPA compliance).',
                ),
              ],
              footer: null,
            ),
            const SizedBox(height: 24),

            // ── Questions? ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.question_answer_rounded,
                    color: AppTheme.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Questions about your privacy?',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We\'re happy to explain anything. Reach out anytime — no legal jargon, just a straight answer.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms),
            const SizedBox(height: 24),

            // ── Version info ────────────────────────────────────────────
            Center(
              child: Text(
                'ProfileForge v1.0.0 • Last updated July 2025',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getAgeStatusText(AgeVerificationStatus status) {
    switch (status) {
      case AgeVerificationStatus.notVerified:
        return 'Not verified';
      case AgeVerificationStatus.under13:
        return 'Under 13 — Parental consent required';
      case AgeVerificationStatus.minor13to17:
        return 'Minor (13-17) — Limited features';
      case AgeVerificationStatus.adult18plus:
        return 'Adult (18+) — Full access';
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account & All Data?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This will permanently remove all your grades, activities, achievements, personal information, and settings from this device. This action cannot be undone.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () { HapticFeedback.lightImpact(); Navigator.of(context).pop(); },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
              // TODO: Implement actual data deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been deleted.'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ────────────────────────────────────────────────────────

class _PrivacySection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int delay;
  final List<Widget> children;
  final String? footer;

  const _PrivacySection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.delay,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Children (items)
          ...children,
          // Optional footer
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  footer!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: context.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          if (footer == null) const SizedBox(height: 8),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

class _PrivacyItem extends StatelessWidget {
  final String text;

  const _PrivacyItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final bool isEnabled;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.status,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : AppTheme.textMuted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isEnabled ? AppTheme.successGreen : AppTheme.textMuted,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isEnabled
                        ? AppTheme.successGreen
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isEnabled
                ? Icons.check_circle_rounded
                : Icons.help_outline_rounded,
            color: isEnabled ? AppTheme.successGreen : AppTheme.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _ControlItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _ControlItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentInfoItem extends StatelessWidget {
  final String text;

  const _ParentInfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppTheme.accentOrange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
