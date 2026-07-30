import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SplashScreen — Animated brand reveal with auto-navigation.
/// Shows logo + tagline, then routes to auth gate or home.
/// ────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted || _navigated) return;
    _navigated = true;

    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('pf_onboarded') ?? false;
    final hasAuth = prefs.getString('pf_auth_token') != null;

    if (!mounted) return;

    if (hasOnboarded && hasAuth) {
      // Fully set up → go to home.
      context.go('/home');
    } else if (hasOnboarded && !hasAuth) {
      // Onboarded but not signed up → show auth prompt.
      context.go('/auth-prompt');
    } else {
      // New user → start onboarding (Duolingo model: invest first, auth later).
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                ? [Palette.surface0, Palette.black]
                : [const Color(0xFFF0F4FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo mark — stylized "PF" monogram.
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.primary.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'PF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // App name.
              Text(
                'ProfileForge',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 8),

              // Tagline.
              Text(
                'Forge Your Future',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                  letterSpacing: 1.5,
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const Spacer(flex: 3),

              // Loading indicator.
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Palette.primary.withValues(alpha: 0.6),
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
