import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/score_widgets.dart';
import 'package:profileforge/core/widgets/feedback_widgets.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingCompletionScreen — Celebration screen after psychology onboarding.
///
/// Features:
/// - Confetti animation
/// - Profile summary with radar chart
/// - AI personality insights preview
/// - Animated mascot
/// - Smooth transition to home
///
/// Based on research:
/// - 12-uiux-gamification-engagement.md (celebration rewards)
/// - 12-uiux-animation-motion-design.md (Disney principles)
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingCompletionScreen extends ConsumerStatefulWidget {
  const OnboardingCompletionScreen({super.key, required this.profileId});

  final String profileId;

  @override
  ConsumerState<OnboardingCompletionScreen> createState() =>
      _OnboardingCompletionScreenState();
}

class _OnboardingCompletionScreenState
    extends ConsumerState<OnboardingCompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _mascotController;
  late AnimationController _summaryController;
  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();

    // Confetti burst
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Mascot bounce
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Summary reveal
    _summaryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Button pulse
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Stagger animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _confettiController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _mascotController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _summaryController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _buttonController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _mascotController.dispose();
    _summaryController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _continueToHome() {
    HapticFeedback.heavyImpact();
    context.go('/home');
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
                ? [
                    const Color(0xFF0B1120),
                    Palette.surface0,
                    Palette.black,
                  ]
                : [
                    const Color(0xFFEEF2FF),
                    const Color(0xFFF8FAFC),
                    Colors.white,
                  ],
          ),
        ),
        child: Stack(
          children: [
            // ── Confetti Layer ──
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, _) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                    dark: dark,
                  ),
                );
              },
            ),

            // ── Main Content ──
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // ── Mascot ──
                    _buildMascot(dark),

                    const SizedBox(height: 24),

                    // ── Title ──
                    _buildTitle(dark),

                    const SizedBox(height: 12),

                    // ── Subtitle ──
                    _buildSubtitle(dark),

                    const SizedBox(height: 32),

                    // ── Profile Summary ──
                    _buildProfileSummary(dark),

                    const SizedBox(height: 32),

                    // ── AI Preview ──
                    _buildAIPreview(dark),

                    const Spacer(flex: 2),

                    // ── Continue Button ──
                    _buildContinueButton(dark),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMascot(bool dark) {
    return AnimatedBuilder(
      animation: _mascotController,
      builder: (context, child) {
        return Transform.scale(
          scale: _mascotController.value,
          child: Transform.rotate(
            angle: sin(_mascotController.value * pi * 2) * 0.05,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: Palette.gradientPrimary,
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '🧑‍🎓',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(bool dark) {
    return AnimatedBuilder(
      animation: _summaryController,
      builder: (context, child) {
        return Opacity(
          opacity: _summaryController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _summaryController.value)),
            child: Text(
              'Profile Complete!',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle(bool dark) {
    return AnimatedBuilder(
      animation: _summaryController,
      builder: (context, child) {
        return Opacity(
          opacity: _summaryController.value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - _summaryController.value)),
            child: Text(
              'Your AI coach now understands your personality,\nstress response, and learning style.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSummary(bool dark) {
    // Real measured psych data (v7) — never hardcoded labels.
    final profile =
        ref.watch(psychologicalProfileProvider(widget.profileId).value);
    final p = profile;
    return AnimatedBuilder(
      animation: _summaryController,
      builder: (context, child) {
        return Opacity(
          opacity: _summaryController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _summaryController.value)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: dark
                    ? Palette.surface1.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dark ? Palette.border : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: dark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Personality radar — real Big Five/SDT data (research 02c).
                  if (p != null) ...[
                    PersonalityRadar(
                      values: p.radarData,
                      labels: p.radarLabels,
                      size: 180,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Personality Traits
                  _buildTraitRow(
                    icon: Icons.psychology,
                    label: 'Personality',
                    value: p == null
                        ? 'Assessment in progress'
                        : _personalityLabel(p),
                    color: Palette.primary,
                    dark: dark,
                  ),
                  const SizedBox(height: 12),
                  _buildTraitRow(
                    icon: Icons.self_improvement,
                    label: 'Stress Response',
                    value: p == null
                        ? 'Assessment in progress'
                        : _supportLabel(p.supportLevel),
                    color: Palette.success,
                    dark: dark,
                  ),
                  const SizedBox(height: 12),
                  _buildTraitRow(
                    icon: Icons.school,
                    label: 'Learning Style',
                    value: p == null
                        ? 'Assessment in progress'
                        : _structureLabel(p.structurePreference),
                    color: Palette.info,
                    dark: dark,
                  ),
                  const SizedBox(height: 12),
                  _buildTraitRow(
                    icon: Icons.chat_bubble_outline,
                    label: 'Communication',
                    value: p == null
                        ? 'Assessment in progress'
                        : _communicationLabel(p.communicationStyle),
                    color: Palette.warning,
                    dark: dark,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Dominant Big Five pair → human label (research 02c-key-insights).
  String _personalityLabel(PsychologicalProfile p) {
    final dims = <String, double>{
      'Open': p.openness,
      'Conscientious': p.conscientiousness,
      'Energetic': p.extraversion,
      'Warm': p.agreeableness,
      'Steady': 1.0 - p.neuroticism,
    };
    final sorted = dims.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return '${sorted[0].key} & ${sorted[1].key}';
  }

  String _supportLabel(SupportLevel s) => switch (s) {
        SupportLevel.high => 'Needs reassurance & structure',
        SupportLevel.moderate => 'Balanced support',
        SupportLevel.low => 'Direct, practical advice',
      };

  String _structureLabel(StructurePreference s) => switch (s) {
        StructurePreference.detailed => 'Step-by-step with deadlines',
        StructurePreference.moderate => 'Balanced structure',
        StructurePreference.flexible => 'Flexible, small chunks',
      };

  String _communicationLabel(CommunicationStyle c) => switch (c) {
        CommunicationStyle.enthusiastic => 'Expressive & warm',
        CommunicationStyle.gentle => 'Thoughtful & supportive',
        CommunicationStyle.direct => 'Direct & candid',
        CommunicationStyle.analytical => 'Analytical & precise',
        CommunicationStyle.balanced => 'Methodical & clear',
      };

  Widget _buildTraitRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool dark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: dark ? Palette.textTertiary : Palette.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIPreview(bool dark) {
    return AnimatedBuilder(
      animation: _summaryController,
      builder: (context, child) {
        return Opacity(
          opacity: _summaryController.value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - _summaryController.value)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Palette.primary.withValues(alpha: 0.1),
                    Palette.accentPink.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Palette.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: Palette.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Coach Ready',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: dark ? Palette.textPrimary : Palette.textInverse,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your responses will be tailored to your personality and stress patterns.',
                          style: TextStyle(
                            fontSize: 11,
                            color: dark ? Palette.textSecondary : Palette.textTertiary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(bool dark) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        final pulse = 1.0 + sin(_buttonController.value * pi) * 0.02;
        return Transform.scale(
          scale: pulse,
          child: GestureDetector(
            onTap: _continueToHome,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Start Your Journey',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ConfettiPainter — Draws confetti particles.
/// ────────────────────────────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress, required this.dark});

  final double progress;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final colors = [
      Palette.primary,
      Palette.accentPink,
      Palette.success,
      Palette.warning,
      Palette.info,
      const Color(0xFF6C63FF),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
    ];

    for (int i = 0; i < 60; i++) {
      final startX = size.width * random.nextDouble();
      final startY = -20.0;
      final endY = size.height * 0.6;

      final currentY =
          startY + (endY - startY) * Curves.easeOut.transform(progress);

      final drift = sin(progress * pi * 2 + i) * 30;
      final currentX = startX + drift;

      final rotation = progress * pi * 4 * (random.nextDouble() - 0.5);
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(rotation);

      // Draw confetti piece
      final shape = random.nextInt(3);
      if (shape == 0) {
        // Rectangle
        canvas.drawRect(
          const Rect.fromLTWH(-4, -2, 8, 4),
          paint,
        );
      } else if (shape == 1) {
        // Circle
        canvas.drawCircle(Offset.zero, 3, paint);
      } else {
        // Triangle
        final path = Path()
          ..moveTo(0, -4)
          ..lineTo(-3, 3)
          ..lineTo(3, 3)
          ..close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
