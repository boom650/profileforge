import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SplashScreen — Premium animated brand reveal with floating particles,
/// glowing logo, gradient shift, typewriter tagline, and loading bar.
/// ────────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ──────────────────────────────────────────────
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _gradientController;
  late AnimationController _loadingController;
  late AnimationController _typewriterController;

  bool _navigated = false;

  // ── Particle data ──────────────────────────────────────────────────────
  late List<_Particle> _particles;
  final math.Random _rand = math.Random();

  @override
  void initState() {
    super.initState();

    // Generate 35 floating particles.
    _particles = List.generate(35, (_) => _randomParticle());

    // Particle drift — loops forever.
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Logo glow pulse — ping-pong.
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Gradient shift — loops.
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Loading bar — fills over 2200ms (leaves buffer before nav).
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Typewriter — runs once for tagline letters.
    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Kick off animations.
    _loadingController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _typewriterController.forward();
    });

    _navigateAfterDelay();
  }

  _Particle _randomParticle() {
    final colors = [
      Palette.primary,
      Palette.primaryLight,
      Palette.accent,
      Palette.accentLight,
      Palette.info,
      Palette.primaryGlow,
      Palette.accentGlow,
    ];
    return _Particle(
      x: _rand.nextDouble(),
      startY: 1.0 + _rand.nextDouble() * 0.4,
      size: 2.0 + _rand.nextDouble() * 4.0,
      speed: 0.3 + _rand.nextDouble() * 0.7,
      opacity: 0.15 + _rand.nextDouble() * 0.45,
      color: colors[_rand.nextInt(colors.length)],
      wobbleAmp: 8.0 + _rand.nextDouble() * 16.0,
      wobbleFreq: 0.5 + _rand.nextDouble() * 1.5,
      wobblePhase: _rand.nextDouble() * math.pi * 2,
    );
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
      context.go('/home');
    } else if (hasOnboarded && !hasAuth) {
      context.go('/auth-prompt');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _glowController.dispose();
    _gradientController.dispose();
    _loadingController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _gradientController,
          _glowController,
          _particleController,
          _loadingController,
          _typewriterController,
        ]),
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: _buildGradientDecoration(dark),
            child: Stack(
              children: [
                // ── Particles layer ──
                ..._buildParticles(size),

                // ── Center content ──
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // ── Glowing logo ──
                      _buildGlowingLogo(),

                      const SizedBox(height: 28),

                      // ── App name ──
                      _buildAppName(dark),

                      const SizedBox(height: 10),

                      // ── Typewriter tagline ──
                      _buildTypewriterTagline(dark),

                      const Spacer(flex: 3),

                      // ── Loading bar ──
                      _buildLoadingBar(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Gradient background ──────────────────────────────────────────────
  BoxDecoration _buildGradientDecoration(bool dark) {
    final t = _gradientController.value;
    // Subtle hue shift using sin wave.
    final shift = math.sin(t * 2 * math.pi);

    if (dark) {
      final color1 = Color.lerp(Palette.surface0, Palette.surface1, shift * 0.5 + 0.5)!;
      final color2 = Color.lerp(Palette.black, const Color(0xFF0D1526), shift * 0.5 + 0.5)!;
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft + Alignment(shift * 0.3, 0),
          end: Alignment.bottomRight + Alignment(-shift * 0.3, 0),
          colors: [color1, color2],
        ),
      );
    } else {
      final color1 = Color.lerp(const Color(0xFFF0F4FF), const Color(0xFFE8EDFF), shift * 0.5 + 0.5)!;
      final color2 = Color.lerp(Colors.white, const Color(0xFFF5F7FF), shift * 0.5 + 0.5)!;
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft + Alignment(shift * 0.3, 0),
          end: Alignment.bottomRight + Alignment(-shift * 0.3, 0),
          colors: [color1, color2],
        ),
      );
    }
  }

  // ── Particles ────────────────────────────────────────────────────────
  List<Widget> _buildParticles(Size size) {
    final t = _particleController.value;
    return _particles.map((p) {
      // Drift upward; wrap around when off screen.
      double progress = (p.startY - t * p.speed) % 1.4;
      if (progress < -0.1) progress += 1.4;

      final y = progress * size.height;
      final wobble = math.sin(t * p.wobbleFreq * 2 * math.pi + p.wobblePhase) * p.wobbleAmp;
      final x = p.x * size.width + wobble;

      // Fade in at top, fade out at bottom.
      final fadeFactor = progress < 0.1
          ? progress / 0.1
          : progress > 1.0
              ? (1.2 - progress) / 0.2
              : 1.0;
      final opacity = (p.opacity * fadeFactor).clamp(0.0, 1.0);

      return Positioned(
        left: x,
        top: y,
        child: Container(
          width: p.size,
          height: p.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.color.withValues(alpha: opacity),
            boxShadow: [
              BoxShadow(
                color: p.color.withValues(alpha: opacity * 0.6),
                blurRadius: p.size * 2,
                spreadRadius: p.size * 0.5,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // ── Glowing logo ─────────────────────────────────────────────────────
  Widget _buildGlowingLogo() {
    final glowValue = _glowController.value;
    final glowRadius = 30.0 + glowValue * 20.0;
    final glowOpacity = 0.3 + glowValue * 0.25;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: Palette.gradientPrimary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: glowOpacity),
            blurRadius: glowRadius,
            spreadRadius: glowValue * 6,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Palette.accent.withValues(alpha: glowOpacity * 0.6),
            blurRadius: glowRadius * 0.8,
            spreadRadius: glowValue * 4,
            offset: const Offset(0, 4),
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
        .fadeIn(duration: 300.ms);
  }

  // ── App name ─────────────────────────────────────────────────────────
  Widget _buildAppName(bool dark) {
    return Text(
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
        .slideY(begin: 0.1, end: 0);
  }

  // ── Typewriter tagline ───────────────────────────────────────────────
  Widget _buildTypewriterTagline(bool dark) {
    const tagline = 'Forge Your Future';
    final totalChars = tagline.length;
    final progress = _typewriterController.value;
    final visibleChars = (progress * totalChars).floor();

    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visible letters.
          for (int i = 0; i < visibleChars; i++)
            Text(
              tagline[i],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                letterSpacing: 1.5,
              ),
            ),
          // Blinking cursor.
          if (progress < 1.0 && visibleChars < totalChars)
            Container(
              width: 1.5,
              height: 16,
              margin: const EdgeInsets.only(left: 1),
              color: (dark ? Palette.textSecondary : Palette.textTertiary)
                  .withValues(alpha: _glowController.value > 0.5 ? 1.0 : 0.0),
            ),
        ],
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 300.ms);
  }

  // ── Loading bar ──────────────────────────────────────────────────────
  Widget _buildLoadingBar() {
    final progress = _loadingController.value;
    // Ease-out the progress for a natural feel.
    final curvedProgress = Curves.easeOut.transform(progress);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bar track.
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 3,
              width: double.infinity,
              child: LinearProgressIndicator(
                value: curvedProgress,
                backgroundColor: Palette.surface2.withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Palette.primary,
                ),
                minHeight: 3,
              ),
            ),
          ),
          // Glow overlay on the leading edge.
          const SizedBox(height: 2),
        ],
      ),
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Particle data class for the floating particle system.
/// ────────────────────────────────────────────────────────────────────────────
class _Particle {
  /// Normalized x position (0..1).
  final double x;

  /// Starting y offset (>1 means start below screen).
  final double startY;

  /// Diameter in logical pixels.
  final double size;

  /// Drift speed multiplier (higher = faster rise).
  final double speed;

  /// Base opacity (0..1).
  final double opacity;

  /// Particle color.
  final Color color;

  /// Horizontal wobble amplitude in pixels.
  final double wobbleAmp;

  /// Wobble frequency in Hz.
  final double wobbleFreq;

  /// Random phase offset for wobble.
  final double wobblePhase;

  const _Particle({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.wobbleAmp,
    required this.wobbleFreq,
    required this.wobblePhase,
  });
}
