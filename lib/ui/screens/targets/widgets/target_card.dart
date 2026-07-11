import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../weekly_targets_model.dart';

class TargetCard extends StatelessWidget {
  final WeeklyTarget target;
  final VoidCallback onToggle;

  const TargetCard({super.key, required this.target, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final meta = getCategoryMeta(target.milestoneType);
    final dueDays = target.daysUntilDue;
    final isOverdue = dueDays != null && dueDays < 0 && !target.isCompleted;
    final isDueSoon = dueDays != null && dueDays >= 0 && dueDays <= 2 && !target.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: target.isCompleted
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : isOverdue
                  ? AppTheme.errorRed.withValues(alpha: 0.3)
                  : context.borderColor,
          width: target.isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status toggle
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: target.isCompleted
                          ? AppTheme.successGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: target.isCompleted
                            ? AppTheme.successGreen
                            : context.borderColor,
                        width: 2,
                      ),
                    ),
                    child: target.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Category badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              target.title,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: target.isCompleted
                                    ? context.textMuted
                                    : context.textPrimary,
                                decoration: target.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: meta.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(meta.icon, color: meta.color, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  meta.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: meta.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (target.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          target.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: context.textMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      // Bottom row: XP + Due date
                      Row(
                        children: [
                          // XP reward
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    color: AppTheme.accentGold, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  '+${target.xpReward} XP',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accentGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Due date countdown
                          if (dueDays != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isOverdue
                                    ? AppTheme.errorRed.withValues(alpha: 0.1)
                                    : isDueSoon
                                        ? AppTheme.accentOrange.withValues(alpha: 0.1)
                                        : context.borderColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isOverdue
                                        ? Icons.warning_rounded
                                        : Icons.schedule_rounded,
                                    size: 13,
                                    color: isOverdue
                                        ? AppTheme.errorRed
                                        : isDueSoon
                                            ? AppTheme.accentOrange
                                            : context.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isOverdue
                                        ? '${-dueDays}d overdue'
                                        : dueDays == 0
                                            ? 'Due today'
                                            : '$dueDays days left',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isOverdue
                                          ? AppTheme.errorRed
                                          : isDueSoon
                                              ? AppTheme.accentOrange
                                              : context.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (target.isCompleted) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '✅ Completed',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress bar
          if (target.progressPct > 0 && !target.isCompleted)
            Padding(
              padding: const EdgeInsets.fromLTRB(62, 0, 16, 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textMuted,
                        ),
                      ),
                      Text(
                        '${target.progressPct}%',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: meta.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: target.progressPct / 100,
                      backgroundColor: meta.color.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(meta.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          // Research milestones list
          if (target.milestones != null && target.milestones!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(62, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Milestones',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...target.milestones!.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(
                                m.completed
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                size: 16,
                                color: m.completed
                                    ? AppTheme.successGreen
                                    : context.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  m.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: m.completed
                                        ? context.textMuted
                                        : context.textPrimary,
                                    decoration: m.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }
}