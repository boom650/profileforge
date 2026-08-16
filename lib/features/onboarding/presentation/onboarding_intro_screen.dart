import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/platypus.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingIntroScreen — Premium intro/welcome before questionnaire.
///
/// Features:
/// - Animated particle background
/// - Feature highlights with staggered animation
/// - Value proposition cards
/// - Get Started CTA
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingIntroScreen extends StatefulWidget {
  const OnboardingIntroScreen({super.key});

  @override
  State<OnboardingIntroScreen> createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends State<OnboardingIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.psychology,
      title: 'Know Yourself',
      subtitle:
          'Discover your unique strengths through our psychology-based assessment.',
      color: Palette.primary,
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome,
      title: 'AI-Powered',
      subtitle:
          'Get personalized recommendations from your AI admissions coach.',
      color: Palette.info,
    ),
    _OnboardingPage(
      icon: Icons.emoji_events,
      title: 'Stand Out',
      subtitle:
          'Craft a compelling application that showcases your authentic self.',
      color: Palette.warning,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      // Navigate to onboarding questionnaire
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final page = _pages[_currentPage];

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
        child: Stack(
          children: [
            // ── Animated Background Particles ──
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ParticlePainter(
                      animation: _controller.value,
                      color: page.color,
                    ),
                  );
                },
              ),
            ),

            // ── Content ──
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ── Logo ──
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: Palette.gradientPrimary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 36,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          duration: 500.ms,
                        ),
                  ),
                  const SizedBox(height: 60),

                  // ── Main Content ──
                  Expanded(
                    child: PageView.builder(
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        final p = _pages[index];
                        return _buildPageContent(p, dark);
                      },
                    ),
                  ),

                  // ── Page Indicators ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _currentPage ? 32 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? page.color
                              : Palette.textTertiary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // ── CTA Button ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: Palette.gradientPrimary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentPage < _pages.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Skip ──
                  if (_currentPage < _pages.length - 1)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/onboarding');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          color: dark ? Palette.textSecondary : Palette.textTertiary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(_OnboardingPage page, bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Icon / Percy ──
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: _currentPage == 0
                ? const Percy(size: 84, semanticLabel: 'Percy the platypus')
                : Icon(
                    page.icon,
                    size: 56,
                    color: page.color,
                  ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.5, 0.5),
                duration: 400.ms,
              ),
          const SizedBox(height: 40),

          // ── Title ──
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: dark ? Palette.textPrimary : Palette.ink,
                ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),

          // ── Subtitle ──
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? Palette.textSecondary : Palette.inkSoft,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.animation, required this.color});

  final double animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (size.width * 0.1) + (size.width * 0.8 * (i / 20));
      final y = (size.height * 0.3) +
          (size.height * 0.4 * (i / 20)) +
          (animation * 30 * (i % 3 == 0 ? 1 : -1));
      final radius = 4.0 + (i % 3) * 2.0;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.color != color;
  }
}
