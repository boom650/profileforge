import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

const String _apiBase = 'http://localhost:8081';

// ─── Milestone model ─────────────────────────────────────────────────────────
enum MilestoneStatus { notStarted, inProgress, completed }

class ResearchMilestone {
  final int id;
  final String name;
  final String description;
  final int weekNumber;
  final int xpReward;
  MilestoneStatus status;
  DateTime? dueDate;

  ResearchMilestone({
    required this.id,
    required this.name,
    required this.description,
    required this.weekNumber,
    required this.xpReward,
    this.status = MilestoneStatus.notStarted,
    this.dueDate,
  });

  factory ResearchMilestone.fromJson(Map<String, dynamic> json) {
    return ResearchMilestone(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      weekNumber: json['weekNumber'] as int,
      xpReward: json['xpReward'] as int,
      status: MilestoneStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => MilestoneStatus.notStarted,
      ),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'weekNumber': weekNumber,
        'xpReward': xpReward,
        'status': status.name,
        'dueDate': dueDate?.toIso8601String(),
      };
}

// ─── Default 8-week pipeline ─────────────────────────────────────────────────
List<ResearchMilestone> _defaultMilestones() {
  final now = DateTime.now();
  const defs = [
    (
      name: 'Topic Selection',
      desc:
          'Identify a research question aligned with your interests and available resources.',
      week: 1,
      xp: 100,
    ),
    (
      name: 'Literature Review',
      desc:
          'Survey 15–20 published papers to understand the current state of the field.',
      week: 2,
      xp: 150,
    ),
    (
      name: 'Methodology Design',
      desc:
          'Define experiments, controls, and data collection methods. Get mentor approval.',
      week: 3,
      xp: 150,
    ),
    (
      name: 'Data Collection',
      desc:
          'Execute experiments and gather raw data. Maintain a detailed lab notebook.',
      week: 4,
      xp: 200,
    ),
    (
      name: 'Draft Writing (V1)',
      desc:
          'Write the first draft: Introduction, Methods, Results, Discussion.',
      week: 5,
      xp: 200,
    ),
    (
      name: 'Peer Review',
      desc: 'Share draft with 2–3 peers/mentors for constructive feedback.',
      week: 6,
      xp: 150,
    ),
    (
      name: 'Revision',
      desc:
          'Incorporate feedback, fix methodology gaps, polish writing and figures.',
      week: 7,
      xp: 150,
    ),
    (
      name: 'Submission',
      desc:
          'Final proofread, format, and submit to journal/conference/competition.',
      week: 8,
      xp: 250,
    ),
  ];

  return defs.asMap().entries.map((e) {
    final i = e.key;
    final d = e.value;
    return ResearchMilestone(
      id: i + 1,
      name: d.name,
      description: d.desc,
      weekNumber: d.week,
      xpReward: d.xp,
      status: MilestoneStatus.notStarted,
      dueDate: now.add(Duration(days: 7 * (d.week))),
    );
  }).toList();
}

// ─── State provider ──────────────────────────────────────────────────────────
final researchMilestonesProvider =
    StateNotifierProvider<ResearchMilestonesNotifier, List<ResearchMilestone>>(
  (ref) => ResearchMilestonesNotifier(),
);

class ResearchMilestonesNotifier
    extends StateNotifier<List<ResearchMilestone>> {
  ResearchMilestonesNotifier() : super(_defaultMilestones()) {
    _loadFromApi();
  }

  Future<void> _loadFromApi() async {
    try {
      final res = await http
          .get(Uri.parse('$_apiBase/api/weekly-targets'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
        if (data.isNotEmpty) {
          state = data
              .map((e) => ResearchMilestone.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {
      // API unavailable — keep local defaults
    }
  }

  void toggleStatus(int milestoneId) {
    state = [
      for (final m in state)
        if (m.id == milestoneId) m..status = _nextStatus(m.status) else m,
    ];
    _syncToApi();
  }

  MilestoneStatus _nextStatus(MilestoneStatus current) {
    return switch (current) {
      MilestoneStatus.notStarted => MilestoneStatus.inProgress,
      MilestoneStatus.inProgress => MilestoneStatus.completed,
      MilestoneStatus.completed => MilestoneStatus.notStarted,
    };
  }

  int get completedCount =>
      state.where((m) => m.status == MilestoneStatus.completed).length;
  int get totalXp => state
      .where((m) => m.status == MilestoneStatus.completed)
      .fold(0, (sum, m) => sum + m.xpReward);
  double get progress => state.isEmpty ? 0 : completedCount / state.length;

  Future<void> _syncToApi() async {
    try {
      await http.post(
        Uri.parse('$_apiBase/api/weekly-targets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(state.map((m) => m.toJson()).toList()),
      );
    } catch (_) {
      // Silently fail — local state is source of truth
    }
  }
}

// ─── Screen ──────────────────────────────────────────────────────────────────
class ResearchMilestonesScreen extends ConsumerStatefulWidget {
  const ResearchMilestonesScreen({super.key});

  @override
  ConsumerState<ResearchMilestonesScreen> createState() =>
      _ResearchMilestonesScreenState();
}

class _ResearchMilestonesScreenState
    extends ConsumerState<ResearchMilestonesScreen> {
  @override
  Widget build(BuildContext context) {
    final milestones = ref.watch(researchMilestonesProvider);
    final notifier = ref.read(researchMilestonesProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        title: Text(
          'Research Milestones',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: CustomScrollView(
        slivers: [
          // ── Progress overview ──
          SliverToBoxAdapter(
            child: _ProgressOverview(
              completedCount: notifier.completedCount,
              totalCount: milestones.length,
              totalXp: notifier.totalXp,
              progress: notifier.progress,
            ),
          ),

          // ── Pipeline visual ──
          SliverToBoxAdapter(
            child: _PipelineVisual(milestones: milestones),
          ),

          // ── Milestone cards ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _MilestoneCard(
                milestone: milestones[i],
                isFirst: i == 0,
                isLast: i == milestones.length - 1,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  notifier.toggleStatus(milestones[i].id);
                },
              ),
              childCount: milestones.length,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}

// ─── Progress overview ───────────────────────────────────────────────────────
class _ProgressOverview extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final int totalXp;
  final double progress;

  const _ProgressOverview({
    required this.completedCount,
    required this.totalCount,
    required this.totalXp,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Research Pipeline',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$completedCount / $totalCount',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // XP earned
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppTheme.accentGold, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$totalXp XP earned',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}% complete',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }
}

// ─── Pipeline visual (horizontal step indicators) ────────────────────────────
class _PipelineVisual extends StatelessWidget {
  final List<ResearchMilestone> milestones;
  const _PipelineVisual({required this.milestones});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          for (int i = 0; i < milestones.length; i++) ...[
            _StepDot(
              milestone: milestones[i],
              isLast: i == milestones.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final ResearchMilestone milestone;
  final bool isLast;
  const _StepDot({required this.milestone, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = _dotColor(milestone.status);
    final isCompleted = milestone.status == MilestoneStatus.completed;
    final isActive = milestone.status == MilestoneStatus.inProgress;

    return Expanded(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive
                      ? color
                      : isCompleted
                          ? color
                          : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: isActive ? 3 : 2,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : Text(
                          '${milestone.weekNumber}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isActive ? Colors.white : color,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'W${milestone.weekNumber}',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          if (!isLast)
            Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? color : color.withValues(alpha: 0.2),
              ),
            ),
        ],
      ),
    );
  }

  Color _dotColor(MilestoneStatus s) => switch (s) {
        MilestoneStatus.completed => AppTheme.successGreen,
        MilestoneStatus.inProgress => AppTheme.primary,
        MilestoneStatus.notStarted => AppTheme.textMuted,
      };
}

// ─── Milestone card ──────────────────────────────────────────────────────────
class _MilestoneCard extends StatelessWidget {
  final ResearchMilestone milestone;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _MilestoneCard({
    required this.milestone,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(milestone.status);
    final isCompleted = milestone.status == MilestoneStatus.completed;
    final isActive = milestone.status == MilestoneStatus.inProgress;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        isFirst ? 4 : 2,
        20,
        isLast ? 4 : 2,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isActive
                ? statusColor.withValues(alpha: 0.04)
                : isCompleted
                    ? AppTheme.successGreen.withValues(alpha: 0.04)
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? statusColor.withValues(alpha: 0.3)
                  : isCompleted
                      ? AppTheme.successGreen.withValues(alpha: 0.2)
                      : AppTheme.textMuted.withValues(alpha: 0.15),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: step number + status icon
              Column(
                children: [
                  // Status circle
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.successGreen
                            : isActive
                                ? statusColor
                                : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 18)
                            : isActive
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    '${milestone.weekNumber}',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  // Connector line
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 24,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.successGreen
                            : AppTheme.textMuted.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // Right: content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + XP
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            milestone.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        // XP badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.accentGold.withValues(alpha: 0.15)
                                : AppTheme.textMuted.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 12,
                                color: isCompleted
                                    ? AppTheme.accentGold
                                    : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${milestone.xpReward}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isCompleted
                                      ? AppTheme.accentGold
                                      : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      milestone.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Bottom row: due date + weekly target + status
                    Row(
                      children: [
                        // Due date
                        if (milestone.dueDate != null) ...[
                          Icon(Icons.calendar_today_rounded,
                              size: 12, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM').format(milestone.dueDate!),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        // Weekly target
                        Icon(Icons.flag_rounded,
                            size: 12, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Week ${milestone.weekNumber} target',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        // Tap hint
                        Text(
                          isCompleted
                              ? 'Tap to reset'
                              : isActive
                                  ? 'Tap to complete'
                                  : 'Tap to start',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(
            delay: Duration(milliseconds: 60 * milestone.id),
          ),
    );
  }

  Color _statusColor(MilestoneStatus s) => switch (s) {
        MilestoneStatus.completed => AppTheme.successGreen,
        MilestoneStatus.inProgress => AppTheme.primary,
        MilestoneStatus.notStarted => AppTheme.textMuted,
      };
}
