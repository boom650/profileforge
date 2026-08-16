import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// TutorialOverlay — Step-by-step tooltip system for new users.
///
/// Based on research:
/// - 12-uiux-gamification-engagement.md (guided onboarding)
/// - 12-uiux-information-architecture-navigation.md (wayfinding)
///
/// Features:
/// - Overlay tooltips with directional arrows
/// - Progress indicator
/// - Skip option
/// - Persists completion state
/// ────────────────────────────────────────────────────────────────────────────
class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.child,
    this.onComplete,
    this.onStart,
  });

  final List<TutorialStep> steps;
  final Widget child;
  final VoidCallback? onComplete;
  final VoidCallback? onStart;

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _showTutorial = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _checkTutorialStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('pf_tutorial_completed') ?? false;
    if (!completed && mounted) {
      setState(() => _showTutorial = true);
      _controller.forward();
      widget.onStart?.call();
    }
  }

  void _nextStep() {
    HapticFeedback.selectionClick();
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _completeTutorial();
    }
  }

  Future<void> _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_tutorial_completed', true);
    await _controller.reverse();
    setState(() => _showTutorial = false);
    widget.onComplete?.call();
  }

  void _skipTutorial() {
    HapticFeedback.lightImpact();
    _completeTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showTutorial) _buildOverlay(),
      ],
    );
  }

  Widget _buildOverlay() {
    final step = widget.steps[_currentStep];
    final dark = isDark(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Stack(
            children: [
              // ── Dark Overlay ──
              Positioned.fill(
                child: GestureDetector(
                  onTap: _nextStep,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7 * _fadeAnimation.value),
                  ),
                ),
              ),

              // ── Tooltip ──
              Positioned(
                top: step.position == TutorialPosition.top
                    ? 100
                    : step.position == TutorialPosition.bottom
                        ? screenHeight - 250
                        : screenHeight / 2 - 100,
                left: 24,
                right: 24,
                child: _buildTooltip(step, dark),
              ),

              // ── Progress Dots ──
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: _buildProgressDots(dark),
              ),

              // ── Skip Button ──
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 20,
                child: GestureDetector(
                  onTap: _skipTutorial,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTooltip(TutorialStep step, bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? Palette.surface1 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step indicator
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${_currentStep + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            step.description,
            style: TextStyle(
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
              height: 1.5,
            ),
          ),

          if (step.icon != null) ...[
            const SizedBox(height: 16),
            Center(
              child: Icon(
                step.icon!,
                size: 48,
                color: Palette.primary,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Next button
          GestureDetector(
            onTap: _nextStep,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _currentStep < widget.steps.length - 1 ? 'Next' : 'Got it!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots(bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.steps.length, (i) {
        final isActive = i == _currentStep;
        final isCompleted = i < _currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isCompleted || isActive
                ? Palette.primary
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// TutorialStep — Data for a single tutorial step.
class TutorialStep {
  final String title;
  final String description;
  final IconData? icon;
  final TutorialPosition position;

  const TutorialStep({
    required this.title,
    required this.description,
    this.icon,
    this.position = TutorialPosition.bottom,
  });
}

enum TutorialPosition { top, middle, bottom }

/// TutorialManager — Manages showing tutorials across the app.
class TutorialManager {
  static TutorialManager? _instance;
  static TutorialManager get instance => _instance ??= TutorialManager._();
  TutorialManager._();

  /// Check if tutorial has been completed.
  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pf_tutorial_completed') ?? false;
  }

  /// Reset tutorial (for testing or re-showing).
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_tutorial_completed', false);
  }

  /// Get default home tutorial steps.
  List<TutorialStep> get homeTutorial => [
        const TutorialStep(
          title: 'Welcome to ProfileForge!',
          description:
              'Your AI-powered college admissions coach. Let us show you around.',
          icon: Icons.rocket_launch,
          position: TutorialPosition.bottom,
        ),
        const TutorialStep(
          title: 'Profile Score',
          description:
              'Your overall profile score updates as you complete activities and improve your application.',
          icon: Icons.speed,
          position: TutorialPosition.top,
        ),
        const TutorialStep(
          title: 'Quick Actions',
          description:
              'Access your most-used features quickly from here.',
          icon: Icons.flash_on,
          position: TutorialPosition.middle,
        ),
        const TutorialStep(
          title: 'AI Recommendations',
          description:
              'Get personalized suggestions based on your profile and target schools.',
          icon: Icons.auto_awesome,
          position: TutorialPosition.bottom,
        ),
        const TutorialStep(
          title: 'You\'re All Set!',
          description:
              'Start by chatting with your AI coach or completing your profile.',
          icon: Icons.check_circle,
          position: TutorialPosition.bottom,
        ),
      ];
}
