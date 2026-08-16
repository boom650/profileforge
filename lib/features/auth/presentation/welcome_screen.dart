import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/auth/application/auth_providers.dart';
import 'package:profileforge/features/auth/domain/auth_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// WelcomeScreen — First-time user experience.
/// Full-screen hero with auth options. Duolingo-inspired simplicity.
/// ────────────────────────────────────────────────────────────────────────────
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _continueAsGuest(BuildContext context, WidgetRef ref) async {
    final status = await ref.read(authStatusProvider.future);
    if (status != AuthStatus.guest) {
      final repo = await ref.read(authRepositoryProvider.future);
      await repo.continueAsGuest();
    }
    if (context.mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ? [
                    const Color(0xFF1A0F0A),
                    Palette.surface0,
                    Palette.black,
                  ]
                : [
                    const Color(0xFFFBF1E3),
                    Palette.cream,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Hero illustration — abstract geometric shape.
              _HeroIllustration(dark: dark),

              const SizedBox(height: 32),

              // Headline.
              Text(
                'Build Your\nDream Profile',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1),

              const SizedBox(height: 12),

              // Subheadline.
              Text(
                'AI-powered CV builder for students\ntargeting top universities',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.1),

              const SizedBox(height: 8),

              // Social proof.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people, size: 16, color: Palette.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Join 50K+ students worldwide',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Palette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              const Spacer(flex: 2),

              // Auth buttons.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Google sign-in.
                    _AuthButton(
                      label: 'Continue with Google',
                      icon: Icons.g_mobiledata, // Google G
                      isGoogle: true,
                      onTap: () {
                        // TODO: Implement Google sign-in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google sign-in coming soon')),
                        );
                      },
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 12),

                    // Apple sign-in.
                    _AuthButton(
                      label: 'Continue with Apple',
                      icon: Icons.apple,
                      isApple: true,
                      onTap: () {
                        // TODO: Implement Apple sign-in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Apple sign-in coming soon')),
                        );
                      },
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 12),

                    // Email magic link.
                    _AuthButton(
                      label: 'Continue with Email',
                      icon: Icons.mail_outline,
                      isOutline: true,
                      onTap: () => context.push('/magic-link'),
                    ).animate().fadeIn(delay: 900.ms, duration: 400.ms).slideY(begin: 0.05),

                    const SizedBox(height: 20),

                    // Guest / skip.
                    TextButton(
                      onPressed: () => _continueAsGuest(context, ref),
                      child: Text(
                        'Maybe later',
                        style: TextStyle(
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Terms footer.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.6),
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

/// Hero illustration — abstract geometric shapes.
class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow.
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Palette.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.8, 0.8),
                duration: 800.ms,
                curve: Curves.easeOut,
              ),

          // Rotating ring.
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Palette.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(
                begin: 0,
                end: 0.1,
                duration: 3000.ms,
                curve: Curves.easeInOut,
              ),

          // Inner diamond.
          Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ).animate().scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 600.ms,
                delay: 100.ms,
                curve: Curves.elasticOut,
              ),

          // Center icon.
          const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 36,
          ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 500.ms);
  }
}

/// Auth button — Google, Apple, or Email.
class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.isGoogle = false,
    this.isApple = false,
    this.isOutline = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
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
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
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
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(
            Icons.apple,
            size: 22,
            color: dark ? Colors.white : Palette.ink,
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

    // Email — gradient or outline.
    if (isOutline) {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Palette.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: Icon(icon, color: Palette.primary, size: 20),
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

    // Default gradient button.
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Palette.gradientPrimary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Palette.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
