import 'dart:convert';
import '../../../config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';

final String apiBase = kApiBaseUrl;

// ─── Models ──────────────────────────────────────────────────────────────────

class WeeklyTarget {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String milestoneType;
  final String pillar;
  final int xpReward;
  final String status;
  final int weekNumber;
  final int year;
  final String? dueDate;
  final String? completedAt;
  final int progressPct;
  final List<TargetMilestone>? milestones;

  const WeeklyTarget({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.milestoneType,
    this.pillar = '',
    this.xpReward = 10,
    required this.status,
    required this.weekNumber,
    required this.year,
    this.dueDate,
    this.completedAt,
    this.progressPct = 0,
    this.milestones,
  });

  factory WeeklyTarget.fromJson(Map<String, dynamic> json) {
    return WeeklyTarget(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'standard',
      milestoneType: json['milestone_type']?.toString() ?? 'standard',
      pillar: json['pillar']?.toString() ?? '',
      xpReward: json['xp_reward'] is int ? json['xp_reward'] : 10,
      status: json['status']?.toString() ?? 'pending',
      weekNumber: json['week_number'] is int ? json['week_number'] : 0,
      year: json['year'] is int ? json['year'] : DateTime.now().year,
      dueDate: json['due_date']?.toString(),
      completedAt: json['completed_at']?.toString(),
      progressPct: json['progress_pct'] is int ? json['progress_pct'] : 0,
      milestones: json['milestones'] != null
          ? (json['milestones'] as List).map((m) => TargetMilestone.fromJson(m)).toList()
          : null,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  DateTime? get dueDateTime {
    if (dueDate == null || dueDate!.isEmpty) return null;
    try {
      return DateTime.parse(dueDate!);
    } catch (_) {
      return null;
    }
  }

  int? get daysUntilDue {
    final due = dueDateTime;
    if (due == null) return null;
    return due.difference(DateTime.now()).inDays;
  }
}

class TargetMilestone {
  final String id;
  final String title;
  final bool completed;

  const TargetMilestone({
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory TargetMilestone.fromJson(Map<String, dynamic> json) {
    return TargetMilestone(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      completed: json['completed'] == true,
    );
  }
}

// ─── Category Metadata ───────────────────────────────────────────────────────

class CategoryMeta {
  final Color color;
  final IconData icon;
  final String label;

  const CategoryMeta(this.color, this.icon, this.label);
}

const Map<String, CategoryMeta> categoryMeta = {
  'research_paper': CategoryMeta(Color(0xFF0891B2), Icons.science_rounded, 'Research'),
  'competition': CategoryMeta(Color(0xFFE11D48), Icons.emoji_events_rounded, 'Competition'),
  'course_cert': CategoryMeta(Color(0xFF059669), Icons.school_rounded, 'Course'),
  'essay_draft': CategoryMeta(Color(0xFF7C3AED), Icons.edit_note_rounded, 'Essay'),
  'volunteer_hours': CategoryMeta(Color(0xFFDB2777), Icons.volunteer_activism_rounded, 'Volunteer'),
  'project_deliverable': CategoryMeta(Color(0xFFF59E0B), Icons.build_rounded, 'Project'),
  'standard': CategoryMeta(Color(0xFF4338CA), Icons.task_alt_rounded, 'Task'),
};

CategoryMeta getCategoryMeta(String type) {
  return categoryMeta[type] ?? categoryMeta['standard']!;
}

// ─── Weekly Targets Provider ─────────────────────────────────────────────────

class WeeklyTargetsState {
  final List<WeeklyTarget> targets;
  final bool loading;
  final String? error;
  final int weekNumber;
  final int year;

  const WeeklyTargetsState({
    this.targets = const [],
    this.loading = false,
    this.error,
    this.weekNumber = 0,
    this.year = 0,
  });

  WeeklyTargetsState copyWith({
    List<WeeklyTarget>? targets,
    bool? loading,
    String? error,
    int? weekNumber,
    int? year,
  }) {
    return WeeklyTargetsState(
      targets: targets ?? this.targets,
      loading: loading ?? this.loading,
      error: error,
      weekNumber: weekNumber ?? this.weekNumber,
      year: year ?? this.year,
    );
  }

  int get completedCount => targets.where((t) => t.isCompleted).length;
  int get totalCount => targets.length;
  int get totalXpAvailable => targets.fold(0, (sum, t) => sum + t.xpReward);
  int get totalXpEarned => targets.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.xpReward);
  double get completionPct => totalCount > 0 ? completedCount / totalCount : 0;
}

class WeeklyTargetsNotifier extends StateNotifier<WeeklyTargetsState> {
  WeeklyTargetsNotifier() : super(const WeeklyTargetsState()) {
    _initCurrentWeek();
  }

  void _initCurrentWeek() {
    final now = DateTime.now();
    final jan1 = DateTime(now.year, 1, 1);
    final days = now.difference(jan1).inDays;
    final weekNum = ((days + jan1.weekday - 1) ~/ 7) + 1;
    state = state.copyWith(weekNumber: weekNum, year: now.year);
  }

  Future<void> fetchTargets(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final response = await http.get(
        Uri.parse('$apiBase/api/weekly-targets?user_id=$userId'
            '&week_number=${state.weekNumber}&year=${state.year}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final targets = data.map((j) => WeeklyTarget.fromJson(j)).toList();
        state = state.copyWith(targets: targets, loading: false);
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Failed to load targets (${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Network error: $e');
    }
  }

  void previousWeek() {
    int newWeek = state.weekNumber - 1;
    int newYear = state.year;
    if (newWeek < 1) {
      newWeek = 52;
      newYear--;
    }
    state = state.copyWith(weekNumber: newWeek, year: newYear);
  }

  void nextWeek() {
    int newWeek = state.weekNumber + 1;
    int newYear = state.year;
    if (newWeek > 52) {
      newWeek = 1;
      newYear++;
    }
    state = state.copyWith(weekNumber: newWeek, year: newYear);
  }

  Future<void> toggleStatus(WeeklyTarget target) async {
    final newStatus = target.isCompleted ? 'pending' : 'completed';
    try {
      final response = await http.patch(
        Uri.parse('$apiBase/api/weekly-targets/${target.id}/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        final updated = WeeklyTarget.fromJson(jsonDecode(response.body));
        final updatedList = state.targets.map((t) => t.id == updated.id ? updated : t).toList();
        state = state.copyWith(targets: updatedList);
      }
    } catch (e) { debugPrint('Error: $e'); }
  }

  Future<void> createTarget({
    required String userId,
    required String title,
    required String description,
    required String category,
    required String milestoneType,
    String? dueDate,
    bool generateMilestones = false,
    String? paperTitle,
  }) async {
    try {
      final body = {
        'user_id': userId,
        'title': title,
        'description': description,
        'category': category,
        'milestone_type': milestoneType,
        'due_date': dueDate,
        'week_number': state.weekNumber,
        'year': state.year,
        'generate_research_milestones': generateMilestones,
      };
      if (paperTitle != null) body['paper_title'] = paperTitle;

      final response = await http.post(
        Uri.parse('$apiBase/api/weekly-targets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newTarget = WeeklyTarget.fromJson(jsonDecode(response.body));
        state = state.copyWith(targets: [...state.targets, newTarget]);
      }
    } catch (e) { debugPrint('Error: $e'); }
  }
}

final weeklyTargetsProvider =
    StateNotifierProvider<WeeklyTargetsNotifier, WeeklyTargetsState>((ref) {
  return WeeklyTargetsNotifier();
});

// ─── Weekly Targets Screen ───────────────────────────────────────────────────

class WeeklyTargetsScreen extends ConsumerStatefulWidget {
  const WeeklyTargetsScreen({super.key});

  @override
  ConsumerState<WeeklyTargetsScreen> createState() => _WeeklyTargetsScreenState();
}

class _WeeklyTargetsScreenState extends ConsumerState<WeeklyTargetsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTargets();
    });
  }

  void _loadTargets() {
    final profile = ref.read(studentProfileProvider);
    final onboarding = ref.read(onboardingDataProvider);
    final userId = profile?.id ?? onboarding.name.hashCode.toString();
    ref.read(weeklyTargetsProvider.notifier).fetchTargets(userId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weeklyTargetsProvider);

    // Group targets by category
    final grouped = <String, List<WeeklyTarget>>{};
    for (final target in state.targets) {
      grouped.putIfAbsent(target.category, () => []).add(target);
    }

    return Scaffold(
      backgroundColor: context.surfaceBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: context.surfaceBg,
            elevation: 0,
            title: Text(
              'Weekly Targets',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _loadTargets();
                },
              ),
            ],
          ),

          // ── Week Selector ──
          SliverToBoxAdapter(
            child: _WeekSelector(
              weekNumber: state.weekNumber,
              year: state.year,
              onPrevious: () {
                HapticFeedback.lightImpact();
                ref.read(weeklyTargetsProvider.notifier).previousWeek();
                _loadTargets();
              },
              onNext: () {
                HapticFeedback.lightImpact();
                ref.read(weeklyTargetsProvider.notifier).nextWeek();
                _loadTargets();
              },
            ),
          ),

          // ── Summary Bar ──
          SliverToBoxAdapter(
            child: _SummaryBar(
              completed: state.completedCount,
              total: state.totalCount,
              xpEarned: state.totalXpEarned,
              xpAvailable: state.totalXpAvailable,
              completionPct: state.completionPct,
            ),
          ),

          // ── Loading / Error / Content ──
          if (state.loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null)
            SliverFillRemaining(
              child: _ErrorState(
                message: state.error!,
                onRetry: _loadTargets,
              ),
            )
          else if (state.targets.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(
                onAddTarget: () => _showAddTargetSheet(context, ref),
              ),
            )
          else ...[
            // ── Targets grouped by category ──
            for (final entry in grouped.entries) ...[
              SliverToBoxAdapter(
                child: _CategoryHeader(
                  category: entry.key,
                  count: entry.value.length,
                  completedCount: entry.value.where((t) => t.isCompleted).length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _TargetCard(
                      target: entry.value[index],
                      onToggle: () =>
                          ref.read(weeklyTargetsProvider.notifier).toggleStatus(entry.value[index]),
                    ),
                    childCount: entry.value.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTargetSheet(context, ref),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Target', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
    );
  }

  // ── Add Target Bottom Sheet ─────────────────────────────────────────────

  void _showAddTargetSheet(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'standard';
    String selectedType = 'standard';
    DateTime? dueDate;
    bool generateMilestones = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final categories = [
            {'value': 'standard', 'label': 'General Task'},
            {'value': 'research_paper', 'label': 'Research Paper'},
            {'value': 'competition', 'label': 'Competition'},
            {'value': 'course_cert', 'label': 'Course / Certificate'},
            {'value': 'essay_draft', 'label': 'Essay Draft'},
            {'value': 'volunteer_hours', 'label': 'Volunteering'},
            {'value': 'project_deliverable', 'label': 'Project'},
          ];

          final types = [
            {'value': 'standard', 'label': 'Standard'},
            {'value': 'research_paper', 'label': 'Research Paper'},
            {'value': 'competition', 'label': 'Competition'},
            {'value': 'course_cert', 'label': 'Course / Certificate'},
            {'value': 'essay_draft', 'label': 'Essay Draft'},
            {'value': 'volunteer_hours', 'label': 'Volunteering'},
            {'value': 'project_deliverable', 'label': 'Project'},
          ];

          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: context.surfaceElevated,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle bar
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.add_task_rounded,
                          color: Theme.of(context).colorScheme.primary, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        'New Weekly Target',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: context.borderColor),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        _buildFieldLabel('Title'),
                        TextField(
                          controller: titleController,
                          decoration: _inputDecoration('e.g., Write research paper introduction'),
                          style: GoogleFonts.inter(fontSize: 15),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        _buildFieldLabel('Description'),
                        TextField(
                          controller: descController,
                          maxLines: 3,
                          decoration: _inputDecoration('What does this target involve?'),
                          style: GoogleFonts.inter(fontSize: 15),
                        ),
                        const SizedBox(height: 20),

                        // Category
                        _buildFieldLabel('Category'),
                        Container(
                          decoration: BoxDecoration(
                            color: context.surfaceBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.borderColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: context.surfaceElevated,
                            style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                            items: categories
                                .map((c) => DropdownMenuItem(
                                      value: c['value'],
                                      child: Text(c['label']!),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setSheetState(() => selectedCategory = v);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Type
                        _buildFieldLabel('Milestone Type'),
                        Container(
                          decoration: BoxDecoration(
                            color: context.surfaceBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.borderColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<String>(
                            value: selectedType,
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: context.surfaceElevated,
                            style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                            items: types
                                .map((t) => DropdownMenuItem(
                                      value: t['value'],
                                      child: Text(t['label']!),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setSheetState(() {
                                selectedType = v;
                                generateMilestones = v == 'research_paper';
                              });
                            },
                          ),
                        ),

                        // Auto-generate milestones toggle for research papers
                        if (selectedType == 'research_paper') ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.accentTeal.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.accentTeal.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome_rounded,
                                    color: AppTheme.accentTeal, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Auto-generate 8 milestones',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Topic selection → Literature review → Methodology → ... → Submission',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: context.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: generateMilestones,
                                  onChanged: (v) =>
                                      setSheetState(() => generateMilestones = v),
                                  activeColor: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // Due date picker
                        _buildFieldLabel('Due Date (Optional)'),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: dueDate ?? DateTime.now().add(const Duration(days: 7)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setSheetState(() => dueDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: context.surfaceBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: Theme.of(context).colorScheme.primary, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  dueDate != null
                                      ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                                      : 'Select a due date',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: dueDate != null
                                        ? context.textPrimary
                                        : context.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Submit button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: titleController.text.trim().isEmpty
                          ? null
                          : () {
                              HapticFeedback.mediumImpact();
                              final profile = ref.read(studentProfileProvider);
                              final onboarding = ref.read(onboardingDataProvider);
                              final userId =
                                  profile?.id ?? onboarding.name.hashCode.toString();

                              ref.read(weeklyTargetsProvider.notifier).createTarget(
                                    userId: userId,
                                    title: titleController.text.trim(),
                                    description: descController.text.trim(),
                                    category: selectedCategory,
                                    milestoneType: selectedType,
                                    dueDate: dueDate?.toIso8601String(),
                                    generateMilestones: generateMilestones,
                                    paperTitle: selectedType == 'research_paper'
                                        ? titleController.text.trim()
                                        : null,
                                  );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Target created! 🎯', style: GoogleFonts.inter()),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppTheme.successGreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        disabledBackgroundColor: context.textMuted.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Create Target',
                        style: GoogleFonts.inter(
                          fontSize: 16,
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
        },
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.textSecondary,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 15, color: context.textMuted),
      filled: true,
      fillColor: context.surfaceBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

// ─── Week Selector ───────────────────────────────────────────────────────────

class _WeekSelector extends StatelessWidget {
  final int weekNumber;
  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _WeekSelector({
    required this.weekNumber,
    required this.year,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    // Compute week date range
    final jan1 = DateTime(year, 1, 1);
    final firstDay = jan1.add(Duration(days: (weekNumber - 1) * 7 - jan1.weekday + 1));
    final lastDay = firstDay.add(const Duration(days: 6));
    final now = DateTime.now();
    final isCurrentWeek =
        weekNumber == _currentWeekNumber(now.year) && year == now.year;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentWeek
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : context.borderColor,
        ),
      ),
      child: Row(
        children: [
          _ArrowButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Week $weekNumber',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    if (isCurrentWeek) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Current',
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
                const SizedBox(height: 2),
                Text(
                  '${_monthShort(firstDay.month)} ${firstDay.day} – ${_monthShort(lastDay.month)} ${lastDay.day}, $year',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
          _ArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  static int _currentWeekNumber(int year) {
    final now = DateTime.now();
    final jan1 = DateTime(year, 1, 1);
    final days = now.difference(jan1).inDays;
    return ((days + jan1.weekday - 1) ~/ 7) + 1;
  }

  static String _monthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ),
    );
  }
}

// ─── Summary Bar ─────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  final int completed;
  final int total;
  final int xpEarned;
  final int xpAvailable;
  final double completionPct;

  const _SummaryBar({
    required this.completed,
    required this.total,
    required this.xpEarned,
    required this.xpAvailable,
    required this.completionPct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: context.isDarkMode
            ? AppTheme.gradientPrimaryDark
            : AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Completion
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completed of $total completed',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: completionPct,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // XP
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFF0F172A), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$xpEarned/$xpAvailable',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'XP Available',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

// ─── Category Header ─────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final String category;
  final int count;
  final int completedCount;

  const _CategoryHeader({
    required this.category,
    required this.count,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final meta = getCategoryMeta(category);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(meta.icon, color: meta.color, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            meta.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: meta.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$completedCount/$count',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: meta.color,
              ),
            ),
          ),
          const Spacer(),
          if (count > 0)
            Text(
              '${((completedCount / count) * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: completedCount == count
                    ? AppTheme.successGreen
                    : context.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Target Card ─────────────────────────────────────────────────────────────

class _TargetCard extends StatelessWidget {
  final WeeklyTarget target;
  final VoidCallback onToggle;

  const _TargetCard({required this.target, required this.onToggle});

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

// ─── Error State ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded,
                  color: AppTheme.errorRed, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Oops!',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Try Again', style: GoogleFonts.inter()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddTarget;

  const _EmptyState({required this.onAddTarget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_task_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 56),
            ),
            const SizedBox(height: 24),
            Text(
              'No Targets This Week',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set weekly goals to stay on track.\nResearch papers, competitions, volunteering — you name it!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onAddTarget,
              icon: const Icon(Icons.add_rounded),
              label: Text('Create Your First Target',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }
}
