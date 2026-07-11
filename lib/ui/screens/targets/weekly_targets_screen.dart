import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/providers.dart';
import 'weekly_targets_model.dart';
import 'weekly_targets_provider.dart';
import 'widgets/widgets.dart';

// Re-export for backward compatibility
export 'weekly_targets_model.dart';
export 'weekly_targets_provider.dart';
export 'widgets/widgets.dart';

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
                semanticLabel: 'Refresh targets',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _loadTargets();
                },
              ),
            ],
          ),

          // ── Week Selector ──
          SliverToBoxAdapter(
            child: WeekSelector(
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
            child: SummaryBar(
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
              child: ErrorState(
                message: state.error!,
                onRetry: _loadTargets,
              ),
            )
          else if (state.targets.isEmpty)
            SliverFillRemaining(
              child: EmptyState(
                onAddTarget: () => _showAddTargetSheet(context, ref),
              ),
            )
          else ...[
            // ── Targets grouped by category ──
            for (final entry in grouped.entries) ...[
              SliverToBoxAdapter(
                child: CategoryHeader(
                  category: entry.key,
                  count: entry.value.length,
                  completedCount: entry.value.where((t) => t.isCompleted).length,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => TargetCard(
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
                          decoration: _inputDecoration(context, 'e.g., Write research paper introduction'),
                          style: GoogleFonts.inter(fontSize: 15),
                        ),
                        const SizedBox(height: 20),

                        // Description
                        _buildFieldLabel('Description'),
                        TextField(
                          controller: descController,
                          maxLines: 3,
                          decoration: _inputDecoration(context, 'What does this target involve?'),
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

  InputDecoration _inputDecoration(BuildContext context, String hint) {
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