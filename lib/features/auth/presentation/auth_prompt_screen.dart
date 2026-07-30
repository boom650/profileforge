import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AuthPromptScreen — Shown AFTER onboarding (Duolingo model).
/// User is already invested. This is "save your progress" not "sign up".
/// ────────────────────────────────────────────────────────────────────────────
class AuthPromptScreen extends StatelessWidget {
  const AuthPromptScreen({super.key});

  Future<void> _continueAsGuest(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_is_guest', true);
    if (context.mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            children: [
              const Spacer(flex: 2),

              // Success icon — "You did it!"
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.primary.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ).animate().scale(
                    begin: const Offset(0, 0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 32),

              // Headline.
              Text(
                'Save your progress',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),

              const SizedBox(height: 12),

              // Subtext.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Create a free account to sync your profile\nacross devices and never lose your streak.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                    height: 1.5,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Benefits list.
              _BenefitRow(icon: Icons.sync, text: 'Sync across all your devices'),
              _BenefitRow(icon: Icons.lock_outline, text: 'Never lose your progress'),
              _BenefitRow(icon: Icons.emoji_events_outlined, text: 'Compete in leagues'),

              const Spacer(flex: 2),

              // Auth buttons.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Google.
                    _AuthButton(
                      label: 'Continue with Google',
                      isGoogle: true,
                      onTap: () {
                        // TODO: Implement Google sign-in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google sign-in coming soon')),
                        );
                      },
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 12),

                    // Apple.
                    _AuthButton(
                      label: 'Continue with Apple',
                      isApple: true,
                      onTap: () {
                        // TODO: Implement Apple sign-in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Apple sign-in coming soon')),
                        );
                      },
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 12),

                    // Email.
                    _AuthButton(
                      label: 'Continue with Email',
                      isOutline: true,
                      onTap: () => context.push('/magic-link'),
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 20),

                    // Skip.
                    TextButton(
                      onPressed: () => _continueAsGuest(context),
                      child: Text(
                        'Maybe later',
                        style: TextStyle(
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Terms.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor?.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Benefit row.
class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Palette.success),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}

/// Auth button — Google, Apple, or Email.
class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.onTap,
    this.isGoogle = false,
    this.isApple = false,
    this.isOutline = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isGoogle;
  final bool isApple;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    if (isGoogle) {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: dark ? Palette.surface1 : Colors.white,
            side: BorderSide(
              color: dark ? Palette.border : const Color(0xFFE2E8F0),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.g_mobiledata, size: 24, color: Color(0xFF4285F4)),
          label: Text(
            label,
            style: TextStyle(
              color: dark ? Palette.textPrimary : Palette.textInverse,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    if (isApple) {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: dark ? Palette.surface1 : Colors.white,
            side: BorderSide(
              color: dark ? Palette.border : const Color(0xFFE2E8F0),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: Icon(
            Icons.apple,
            size: 22,
            color: dark ? Colors.white : Colors.black,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: dark ? Palette.textPrimary : Palette.textInverse,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    // Email outline.
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Palette.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.mail_outline, color: Palette.primary, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Palette.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
