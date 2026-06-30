import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_providers.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;

  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final typeColors = {
      MissionType.daily: AppTheme.primaryBlue,
      MissionType.weekly: const Color(0xFF8B5CF6),
      MissionType.milestone: AppTheme.accentGold,
      MissionType.inSchool: const Color(0xFF10B981),
      MissionType.research: const Color(0xFF8B5CF6),
      MissionType.leadership: const Color(0xFFEF4444),
      MissionType.volunteering: const Color(0xFFEC4899),
    };

    final color = typeColors[mission.type] ?? AppTheme.primaryBlue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
          if (!mission.isCompleted)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: const Size(80, 36),
              ),
              child: Text(
                'Start',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            )
          else
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
            ),
        ],
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
    }
  }
}

// Compact skin showcase for dashboard
class SkinShowcaseCompact extends StatelessWidget {
  final String currentSkin;

  const SkinShowcaseCompact({super.key, required this.currentSkin});

  @override
  Widget build(BuildContext context) {
    final skinData = _getSkinData(currentSkin);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            skinData['color'].withValues(alpha: 0.15),
            skinData['color'].withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: skinData['color'].withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: skinData['color'].withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(skinData['icon'], color: skinData['color'], size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skinData['name'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  skinData['description'],
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                skinData['rarity'],
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: skinData['color'],
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: skinData['color'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSkinData(String skin) {
    switch (skin) {
      case 'explorer':
        return {
          'name': 'Academic Explorer',
          'description': 'First steps into academic exploration',
          'icon': Icons.explore_rounded,
          'color': const Color(0xFF4A90D9),
          'rarity': 'COMMON',
        };
      case 'scholar':
        return {
          'name': 'Scholar',
          'description': 'Deep academic commitment',
          'icon': Icons.school_rounded,
          'color': const Color(0xFF2E6DA4),
          'rarity': 'COMMON',
        };
      case 'evidence_keeper':
        return {
          'name': 'Evidence Keeper',
          'description': 'Master of documentation',
          'icon': Icons.verified_rounded,
          'color': const Color(0xFF27AE60),
          'rarity': 'UNCOMMON',
        };
      case 'marathon_runner':
        return {
          'name': 'Marathon Runner',
          'description': 'Consistency incarnate',
          'icon': Icons.directions_run_rounded,
          'color': const Color(0xFFE67E22),
          'rarity': 'UNCOMMON',
        };
      case 'researcher':
        return {
          'name': 'Researcher',
          'description': 'Seeker of new knowledge',
          'icon': Icons.science_rounded,
          'color': const Color(0xFF8E44AD),
          'rarity': 'RARE',
        };
      case 'leader':
        return {
          'name': 'Leader',
          'description': 'Guides others, builds teams',
          'icon': Icons.people_rounded,
          'color': const Color(0xFFC0392B),
          'rarity': 'RARE',
        };
      case 'creator':
        return {
          'name': 'Creator',
          'description': 'Makes things that didn\'t exist',
          'icon': Icons.palette_rounded,
          'color': const Color(0xFFE74C3C),
          'rarity': 'RARE',
        };
      case 'changemaker':
        return {
          'name': 'Changemaker',
          'description': 'Impacts community, solves problems',
          'icon': Icons.volunteer_activism_rounded,
          'color': const Color(0xFF16A085),
          'rarity': 'RARE',
        };
      case 'trailblazer':
        return {
          'name': 'Trailblazer',
          'description': 'Legendary — masters all pillars',
          'icon': Icons.star_rounded,
          'color': const Color(0xFFF39C12),
          'rarity': 'LEGENDARY',
        };
      default:
        return {
          'name': 'Academic Explorer',
          'description': 'First steps into academic exploration',
          'icon': Icons.explore_rounded,
          'color': const Color(0xFF4A90D9),
          'rarity': 'COMMON',
        };
    }
  }
}