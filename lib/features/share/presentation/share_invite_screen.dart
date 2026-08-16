import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ShareInviteScreen — Share ProfileForge with friends.
///
/// Features:
/// - Share link generation
/// - Social media sharing options
/// - Referral code system
/// - Share analytics
/// ────────────────────────────────────────────────────────────────────────────
class ShareInviteScreen extends StatelessWidget {
  const ShareInviteScreen({super.key});

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
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
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
                          color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
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
                      'Share & Invite',
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
                      const SizedBox(height: 16),

                      // ── Hero Card ──
                      _buildHeroCard(dark),
                      const SizedBox(height: 24),

                      // ── Referral Code ──
                      _buildSectionTitle('Your Referral Code', dark),
                      const SizedBox(height: 12),
                      _buildReferralCode(dark),
                      const SizedBox(height: 24),

                      // ── Share Options ──
                      _buildSectionTitle('Share via', dark),
                      const SizedBox(height: 12),
                      _buildShareOptions(dark),
                      const SizedBox(height: 24),

                      // ── Stats ──
                      _buildSectionTitle('Your Referrals', dark),
                      const SizedBox(height: 12),
                      _buildReferralStats(dark),
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

  Widget _buildHeroCard(bool dark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Palette.gradientPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.group_add,
            size: 48,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 16),
          Text(
            'Invite Friends',
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help your friends ace their college applications too!',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Palette.textPrimary : Palette.textInverse,
      ),
    );
  }

  Widget _buildReferralCode(bool dark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Copy to clipboard
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface1.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dark ? Palette.border : const Color(0xFFEDE3D6),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.content_copy, size: 20, color: Palette.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PFORGE-SHRI-2024',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Palette.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Tap to copy',
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Palette.textTertiary : Palette.textSecondary,
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

  Widget _buildShareOptions(bool dark) {
    final options = [
      _ShareOption(
        icon: Icons.share,
        label: 'Share Link',
        color: Palette.primary,
        onTap: () {},
      ),
      _ShareOption(
        icon: Icons.message,
        label: 'Messages',
        color: Palette.success,
        onTap: () {},
      ),
      _ShareOption(
        icon: Icons.mail_outline,
        label: 'Email',
        color: Palette.info,
        onTap: () {},
      ),
      _ShareOption(
        icon: Icons.copy,
        label: 'Copy Link',
        color: Palette.warning,
        onTap: () {
          HapticFeedback.mediumImpact();
        },
      ),
    ];

    return Row(
      children: options.map((option) {
        return Expanded(
          child: GestureDetector(
            onTap: option.onTap,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: option.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(option.icon, color: option.color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: dark ? Palette.textSecondary : Palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReferralStats(bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('5', 'Invited', Icons.person_add, dark),
          _buildStatItem('3', 'Joined', Icons.check_circle, dark),
          _buildStatItem('2', 'Active', Icons.trending_up, dark),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, bool dark) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Palette.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
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
    );
  }
}

class _ShareOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
