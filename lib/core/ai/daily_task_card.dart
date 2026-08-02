import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/ai/task_hierarchy_engine.dart';

/// Daily task card — shows today's personalized task on the home screen.
/// This is the core of the progressive system: small tasks compound into achievements.
class DailyTaskCard extends StatelessWidget {
  const DailyTaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.monthlyProgress,
    this.weeklyProgress,
  });

  final ProfileTask task;
  final VoidCallback onComplete;
  final double? monthlyProgress; // 0.0 - 1.0
  final double? weeklyProgress;  // 0.0 - 1.0

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: dark
              ? [Palette.surface1, Palette.surface0]
              : [Colors.white, const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row.
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bolt, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Task',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Palette.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      task.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${task.estimatedMinutes} min',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Palette.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Task title.
          Text(
            task.title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          // Task description.
          Text(
            task.description,
            style: TextStyle(
              fontSize: 13,
              color: Palette.textSecondary,
              height: 1.5,
            ),
          ),

          // Progress toward monthly goal.
          if (task.monthGoal != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag, size: 14, color: Palette.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Building toward: ${task.monthGoal}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Palette.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (monthlyProgress != null)
                    Text(
                      '${(monthlyProgress! * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Palette.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Complete button.
          GestureDetector(
            onTap: onComplete,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Mark Complete ✓',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
