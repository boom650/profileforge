import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/gamification/missions.dart';
import '../../../models/gamification/skins.dart';
import '../../../../providers/gamification_providers.dart';
import '../../../widgets/celebration_overlay.dart';
import '../../../widgets/micro_interactions.dart';

/// A compact stat card for the dashboard row.
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A quick-action button used in the dashboard action rows.
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// XP progress card showing total XP, progress to next threshold, and current skin.
class XPProgressCard extends StatelessWidget {
  final int xp;
  final String currentSkin;

  const XPProgressCard({super.key, required this.xp, required this.currentSkin});

  @override
  Widget build(BuildContext context) {
    final nextThreshold = _getNextThreshold(xp);
    final progress = xp / nextThreshold;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.isDarkMode
            ? AppTheme.gradientPrimaryDark
            : AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.stars_rounded,
                    color: Theme.of(context).colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Total XP',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary,
                ),
              ),
              const Spacer(),
              CountingAnimation(
                targetValue: xp,
                builder: (context, currentValue) {
                  return Text(
                    '$currentValue / $nextThreshold',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.gradientGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                currentSkin.replaceAll('_', ' ').toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}% to next skin',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: context.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getNextThreshold(int xp) {
    final thresholds = [500, 1500, 2500, 5000, 5000, 5000, 5000, 15000];
    for (final t in thresholds) {
      if (xp < t) return t;
    }
    return 15000;
  }
}

/// Empty state shown when all daily missions are completed.
class EmptyMissionsCard extends StatelessWidget {
  const EmptyMissionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 48, color: AppTheme.successGreen),
          const SizedBox(height: 12),
          Text(
            'All caught up! 🎉',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No daily missions pending. Check back tomorrow!',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card displaying a spike (specialized achievement) with category color coding.
class SpikeCard extends StatelessWidget {
  final dynamic spike;

  const SpikeCard({super.key, required this.spike});

  @override
  Widget build(BuildContext context) {
    // final categoryColor = AppTheme.categoryColors[spike.category.colorKey] ??
    //     Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: categoryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            // color: categoryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              // color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                // spike.category.icon,
                "S",
                style: GoogleFonts.inter(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Description and meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // spike.description,
                  "Spike Description",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Text(
                    //   spike.starsDisplay,
                    //   style: GoogleFonts.inter(
                    //     fontSize: 13,
                    //     color: Theme.of(context).colorScheme.secondary,
                    //     letterSpacing: 1,
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    Text(
                      // spike.category.displayName,
                      "Category",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Impact score circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // gradient: LinearGradient(
              //   colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
            child: Center(
              child: Text(
                // '${spike.impactScore}',
                "10",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress bar for mission completion overview.
class MissionProgressBar extends StatelessWidget {
  final int completed;
  final int total;

  const MissionProgressBar({super.key, required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Progress',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              Text(
                '$completed of $total',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? AppTheme.successGreen
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced mission list tile with progress bar and XP reward.
class MissionListTile extends ConsumerWidget {
  final Mission mission;

  const MissionListTile({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = mission.progressTarget > 0
        ? (mission.progressCurrent / mission.progressTarget).clamp(0.0, 1.0)
        : 0.0;
    final isComplete = mission.isCompleted;
    final isClaimed = mission.isClaimed;
    final diffColor = _difficultyColor(mission.difficulty, context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isComplete
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : context.borderColor,
        ),
        boxShadow: isComplete
            ? []
            : [
                BoxShadow(
                  color: diffColor.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Difficulty badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mission.difficulty.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: diffColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Category badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mission.category.name[0].toUpperCase() +
                        mission.category.name.substring(1),
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                // XP reward
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.stars_rounded,
                          size: 12,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 3),
                      Text(
                        '${mission.xpReward}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              mission.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isComplete ? context.textMuted : context.textPrimary,
                decoration: isComplete ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mission.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: context.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            // Progress bar
            if (mission.progressTarget > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${mission.progressCurrent}/${mission.progressTarget} ${mission.progressUnit}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isComplete
                          ? AppTheme.successGreen
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete
                        ? AppTheme.successGreen
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            // Action button row
            Row(
              children: [
                if (!isComplete && mission.progressTarget > 0)
                  FilledButton(
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      try {
                        await ref.read(updateMissionProgressProvider)(
                          mission.id,
                          mission.progressTarget - mission.progressCurrent,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Mission completed! 🎉 +XP'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                          CelebrationHelper.show(
                            context,
                            type: CelebrationType.missionComplete,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error. Try again.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Complete',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                if (!isComplete && mission.progressTarget == 0)
                  FilledButton(
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      try {
                        await ref.read(updateMissionProgressProvider)(
                          mission.id,
                          mission.progressTarget - mission.progressCurrent,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Mission completed! 🎉 +XP'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                          CelebrationHelper.show(
                            context,
                            type: CelebrationType.missionComplete,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error. Try again.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Claim',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                if (isComplete && !isClaimed)
                  FilledButton(
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      try {
                        await ref.read(claimMissionRewardProvider)(mission.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('XP claimed! 💫'),
                              backgroundColor: AppTheme.successGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error. Try again.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Claim XP',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSecondary,
                        )),
                  ),
                if (isComplete && isClaimed)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 16, color: AppTheme.successGreen),
                        const SizedBox(width: 4),
                        Text(
                          'Done',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _difficultyColor(MissionDifficulty diff, BuildContext context) {
    switch (diff) {
      case MissionDifficulty.easy:
        return AppTheme.successGreen;
      case MissionDifficulty.medium:
        return AppTheme.warningAmber;
      case MissionDifficulty.hard:
        return AppTheme.errorRed;
      case MissionDifficulty.expert:
        return AppTheme.primaryBlue;
      case MissionDifficulty.legendary:
        return AppTheme.accentPurple;
    }
  }
}

/// Floating Action Button opening the chat screen.
class ChatFAB extends StatelessWidget {
  final VoidCallback onTap;

  const ChatFAB({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: const CircleBorder(),
      elevation: 8,
      child: const Icon(Icons.chat_bubble_rounded, size: 28),
    ).animate().scale(delay: 800.ms, duration: 500.ms, curve: Curves.elasticOut);
  }
}

/// Helper to compute time-of-day greeting.
String greetingForHour(int hour) {
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}