import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/gamification/missions.dart';
import '../../../providers/app_providers.dart';
import '../../widgets/celebration_overlay.dart';
import 'widgets/shared_widgets.dart';

/// Missions tab with daily, weekly, and milestone missions.
class MissionsTab extends ConsumerWidget {
  const MissionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionsProvider);
    final dailyMissions =
        missions.where((m) => m.type == MissionType.daily).toList();
    final weeklyMissions =
        missions.where((m) => m.type == MissionType.weekly).toList();
    final milestoneMissions =
        missions.where((m) => m.type == MissionType.milestone).toList();
    final completedCount = missions.where((m) => m.isCompleted).length;
    final totalXP = missions.fold<int>(0, (sum, m) => sum + m.xpReward);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Missions',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 16, color: AppTheme.successGreen),
                  const SizedBox(width: 4),
                  Text(
                    '$completedCount/${missions.length}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    '${totalXP} XP',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Milestones'),
            ],
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        body: TabBarView(
          children: [
            _MissionList(missions: dailyMissions),
            _MissionList(missions: weeklyMissions),
            _MissionList(missions: milestoneMissions),
          ],
        ),
      ),
    );
  }
}

/// Shared mission list widget for each tab.
class _MissionList extends ConsumerWidget {
  final List<Mission> missions;

  const _MissionList({required this.missions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (missions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt_rounded,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No missions here yet!',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Check in daily to unlock new missions and earn XP.\nStart on the Dashboard tab to keep your streak going!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: context.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              Icon(Icons.local_fire_department_rounded,
                  size: 32,
                  color: AppTheme.accentOrange.withValues(alpha: 0.6)),
            ],
          ),
        ),
      );
    }

    final pending = missions.where((m) => !m.isCompleted).toList();
    final completed = missions.where((m) => m.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary bar
        if (missions.isNotEmpty) ...[
          MissionProgressBar(completed: completed.length, total: missions.length),
          const SizedBox(height: 16),
        ],
        // Pending missions
        ...pending.map((m) => MissionListTile(mission: m)),
        // Completed missions
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'COMPLETED',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...completed.map((m) => MissionListTile(mission: m)),
        ],
      ],
    );
  }
}