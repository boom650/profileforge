import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingProgressTracker — Multi-step onboarding progress bar.
///
/// Features:
/// - Animated step indicators
/// - Step labels
/// - Current step highlight
/// - Completed steps with checkmarks
/// - Smooth transitions between steps
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingProgressTracker extends StatelessWidget {
  const OnboardingProgressTracker({
    super.key,
    required this.steps,
    required this.currentStep,
    this.showLabels = true,
    this.height = 4,
    this.activeColor,
  });

  final List<String> steps;
  final int currentStep;
  final bool showLabels;
  final double height;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final progressColor = activeColor ?? Palette.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Progress bar ──
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: List.generate(steps.length, (i) {
                final isCompleted = i < currentStep;
                final isCurrent = i == currentStep - 1;
                final isUpcoming = i >= currentStep;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < steps.length - 1 ? 3 : 0,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      height: height,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? progressColor
                            : isUpcoming
                                ? (dark
                                    ? Palette.surface2
                                    : const Color(0xFFE2E8F0))
                                : progressColor,
                        borderRadius: BorderRadius.circular(height / 2),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: progressColor.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),

        // ── Step labels ──
        if (showLabels) ...[
          const SizedBox(height: 10),
          Row(
            children: List.generate(steps.length, (i) {
              final isCompleted = i < currentStep;
              final isCurrent = i == currentStep - 1;
              final isUpcoming = i >= currentStep;

              return Expanded(
                child: Column(
                  children: [
                    // Step number/icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? progressColor
                            : isCurrent
                                ? progressColor.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isUpcoming && !isCompleted
                            ? Border.all(
                                color: dark
                                    ? Palette.surface2
                                    : const Color(0xFFE2E8F0),
                              )
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent
                                      ? progressColor
                                      : (dark
                                          ? Palette.textTertiary
                                          : Palette.textSecondary),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Label
                    Text(
                      steps[i],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        color: isCurrent
                            ? progressColor
                            : (dark
                                ? Palette.textTertiary
                                : Palette.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// CircularStepProgress — Circular step progress with icons.
class CircularStepProgress extends StatelessWidget {
  const CircularStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
    this.size = 48,
  });

  final List<IconData> steps;
  final int currentStep;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (i) {
        final isCompleted = i < currentStep;
        final isCurrent = i == currentStep - 1;

        return Padding(
          padding: EdgeInsets.only(
            right: i < steps.length - 1 ? 24 : 0,
          ),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Palette.primary
                      : isCurrent
                          ? Palette.primary.withValues(alpha: 0.12)
                          : (dark
                              ? Palette.surface2
                              : const Color(0xFFF1F5F9)),
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: Palette.primary, width: 2)
                      : null,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: Palette.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  steps[i],
                  size: size * 0.45,
                  color: isCompleted
                      ? Colors.white
                      : isCurrent
                          ? Palette.primary
                          : (dark
                              ? Palette.textTertiary
                              : Palette.textSecondary),
                ),
              ),
              if (i < steps.length - 1)
                Container(
                  width: 24,
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: isCompleted
                      ? Palette.primary
                      : (dark ? Palette.surface2 : const Color(0xFFE2E8F0)),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// AnimatedStepCounter — Step counter with animation.
class AnimatedStepCounter extends StatelessWidget {
  const AnimatedStepCounter({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$current',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Palette.primary,
          ),
        ),
        Text(
          ' / $total',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: dark ? Palette.textTertiary : Palette.textSecondary,
          ),
        ),
      ],
    );
  }
}
