import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../models/gamification/missions.dart';
import 'micro_interactions.dart';

class MissionCard extends ConsumerWidget {
  final Mission mission;

  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeColors = {
      MissionType.daily: AppTheme.primaryBlue,
      MissionType.weekly: AppTheme.primaryPurple,
      MissionType.milestone: AppTheme.accentGold,
      MissionType.inSchool: AppTheme.successGreen,
      MissionType.research: AppTheme.primaryPurple,
      MissionType.leadership: AppTheme.errorRed,
      MissionType.volunteering: AppTheme.accentOrange,
    };

    final color = typeColors[mission.type] ?? AppTheme.primaryBlue;

    return TapScale(
      onTap: mission.isCompleted ? null : () {
        HapticHelper.light();
      },
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: mission.isCompleted ? 0.3 : 0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Type indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTypeIcon(mission.type),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          // Mission content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mission.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: mission.isCompleted ? AppTheme.textMuted : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (mission.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_rounded, size: 12, color: AppTheme.successGreen),
                            const SizedBox(width: 4),
                            Text(
                              'Done',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  mission.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: mission.isCompleted ? AppTheme.textMuted : AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+${mission.xpReward} XP',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (mission.metadata != null) ...[
                      const SizedBox(width: 8),
                      ...mission.metadata!.entries.take(2).map((e) => Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${e.key}: ${e.value}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      )),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Action button
          if (mission.isClaimed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Completed',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successGreen,
                ),
              ),
            )
          else if (mission.isCompleted)
            TapScale(
              onTap: null,
              child: ElevatedButton(
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  await ref.read(claimMissionRewardProvider)(mission.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Claimed ${mission.xpReward} XP reward! 🎉'),
                        backgroundColor: AppTheme.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(80, 48),
                ),
                child: Text(
                  'Claim',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            )
          else
            TapScale(
              onTap: null,
              child: ElevatedButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  await ref.read(updateMissionProgressProvider)(mission.id, 1);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mission.progressCurrent + 1 >= mission.progressTarget
                            ? 'Mission completed! 🎉'
                            : 'Progress: ${mission.progressCurrent + 1}/${mission.progressTarget}'),
                        backgroundColor: color,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(80, 48),
                ),
                child: Text(
                  mission.progressCurrent > 0 ? 'Continue' : 'Start',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  IconData _getTypeIcon(MissionType type) {
    switch (type) {
      case MissionType.daily: return Icons.today_rounded;
      case MissionType.weekly: return Icons.calendar_view_week_rounded;
      case MissionType.milestone: return Icons.flag_rounded;
      case MissionType.inSchool: return Icons.school_rounded;
      case MissionType.research: return Icons.science_rounded;
      case MissionType.leadership: return Icons.people_rounded;
      case MissionType.volunteering: return Icons.volunteer_activism_rounded;
      case MissionType.special: return Icons.star_rounded;
    }
  }
}