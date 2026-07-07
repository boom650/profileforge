import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen1Welcome extends StatefulWidget {
  const Screen1Welcome({super.key});

  @override
  State<Screen1Welcome> createState() => _Screen1WelcomeState();
}

class _Screen1WelcomeState extends State<Screen1Welcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, _) {
        final t = _gradientController.value;
        final angle = t * math.pi;
        final begin = Alignment(math.cos(angle), math.sin(angle));
        final end = Alignment(-math.cos(angle), -math.sin(angle));
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: const [
                Color(0xFF0F172A),
                Color(0xFF1E1B4B),
                Color(0xFF312E81),
                Color(0xFF1E293B),
              ],
            ),
          ),
          child: _WelcomeContent(),
        );
      },
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 120,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Logo with glow effect
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.gradientPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
                  .then(delay: 400.ms)
                  .shimmer(duration: 1200.ms),
              const SizedBox(height: 40),
              // Main headline
              Text(
                'Your Dream\nUniversity\nAwaits.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
              const SizedBox(height: 16),
              // Gradient accent line
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().fadeIn(delay: 600.ms).scaleX(begin: 0),
              const SizedBox(height: 20),
              // Value proposition
              Text(
                'ProfileForge is the AI-powered admissions coach\nbuilt exclusively for Indian students\ntargeting global universities.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
              const SizedBox(height: 48),
              // Feature highlights with glass cards
              _GlassFeatureItem(
                icon: Icons.psychology_rounded,
                title: 'AI Probability Engine',
                subtitle: 'Run 10,000 simulations per university. Watch your odds climb every week.',
                color: AppTheme.primaryBlueLight,
                delay: 800,
              ),
              const SizedBox(height: 12),
              _GlassFeatureItem(
                icon: Icons.explore_rounded,
                title: 'Hyper-Local Opportunities',
                subtitle: 'NGOs, labs, competitions, hackathons — matched to your location & schedule.',
                color: AppTheme.successGreen,
                delay: 900,
              ),
              const SizedBox(height: 12),
              _GlassFeatureItem(
                icon: Icons.emoji_events_rounded,
                title: 'Earn Skins, Not Boring Coins',
                subtitle: 'Unlock Researcher, Leader, Creator, Changemaker & Trailblazer personas.',
                color: AppTheme.accentGold,
                delay: 1000,
              ),
              const SizedBox(height: 12),
              _GlassFeatureItem(
                icon: Icons.auto_awesome_rounded,
                title: 'Smart Mission Engine',
                subtitle: 'Weekly missions auto-scheduled to your free periods. Never clashes with school.',
                color: AppTheme.accentOrange,
                delay: 1100,
              ),
              const SizedBox(height: 40),
              // Privacy badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      color: AppTheme.successGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your data stays on your device. 100% private.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1200.ms),
              const SizedBox(height: 24),
              Text(
                'Built for Indian 11th graders\ntargeting Ivy League & top global universities',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.35),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 1300.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final int delay;

  const _GlassFeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideX(begin: 0.15);
  }
}
