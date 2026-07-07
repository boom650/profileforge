import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../services/competition_calendar_service.dart';
import '../../theme/app_theme.dart';

// ─── Category colour map ────────────────────────────────────────────────────
const Map<String, Color> _categoryColors = {
  'olympiad': Color(0xFF4338CA), // Math/Indigo
  'scholarship': Color(0xFF7C3AED), // Purple
  'hackathon': Color(0xFF059669), // Green (CS)
  'essay': Color(0xFFE11D48), // Red
  'research': Color(0xFFF97316), // Orange (Science)
  'model': Color(0xFF14B8A6), // Teal (Tech)
};

const Map<String, String> _categoryLabels = {
  'olympiad': 'Math',
  'scholarship': 'Physics',
  'hackathon': 'CS',
  'essay': 'Essay',
  'research': 'Science',
  'model': 'Tech',
};

// ─── Status helpers ──────────────────────────────────────────────────────────
enum _CompStatus { upcoming, registrationOpen, registrationClosed, past }

_CompStatus _statusFor(Competition c) {
  final now = DateTime.now();
  if (now.isAfter(c.examDate)) return _CompStatus.past;
  if (c.isRegistrationOpen) return _CompStatus.registrationOpen;
  if (now.isBefore(c.registrationStart)) return _CompStatus.upcoming;
  return _CompStatus.registrationClosed;
}

String _statusLabel(_CompStatus s) => switch (s) {
      _CompStatus.upcoming => 'Upcoming',
      _CompStatus.registrationOpen => 'Registration Open',
      _CompStatus.registrationClosed => 'Reg. Closed',
      _CompStatus.past => 'Past',
    };

Color _statusColor(_CompStatus s) => switch (s) {
      _CompStatus.upcoming => AppTheme.accentTeal,
      _CompStatus.registrationOpen => AppTheme.successGreen,
      _CompStatus.registrationClosed => AppTheme.warningAmber,
      _CompStatus.past => AppTheme.textMuted,
    };

IconData _statusIcon(_CompStatus s) => switch (s) {
      _CompStatus.upcoming => Icons.schedule_rounded,
      _CompStatus.registrationOpen => Icons.how_to_reg_rounded,
      _CompStatus.registrationClosed => Icons.lock_outline_rounded,
      _CompStatus.past => Icons.check_circle_outline_rounded,
    };

// ─── Difficulty heuristics ───────────────────────────────────────────────────
String _difficultyFor(Competition c) {
  if (c.category == 'olympiad' && c.name.contains('National')) return 'Hard';
  if (c.category == 'olympiad') return 'Medium';
  if (c.category == 'hackathon') return 'Medium';
  if (c.category == 'essay') return 'Easy';
  if (c.category == 'research') return 'Hard';
  if (c.category == 'scholarship') return 'Medium';
  return 'Easy';
}

Color _difficultyColor(String d) => switch (d) {
      'Hard' => AppTheme.errorRed,
      'Medium' => AppTheme.warningAmber,
      _ => AppTheme.successGreen,
    };

// ─── Screen ──────────────────────────────────────────────────────────────────
class CompetitionCalendarScreen extends ConsumerStatefulWidget {
  const CompetitionCalendarScreen({super.key});

  @override
  ConsumerState<CompetitionCalendarScreen> createState() =>
      _CompetitionCalendarScreenState();
}

class _CompetitionCalendarScreenState
    extends ConsumerState<CompetitionCalendarScreen> {
  String? _selectedCategory;
  _CompStatus? _selectedStatus;
  Timer? _countdownTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  List<Competition> _filtered(List<Competition> all) {
    return all.where((c) {
      if (_selectedCategory != null && c.category != _selectedCategory) {
        return false;
      }
      if (_selectedStatus != null && _statusFor(c) != _selectedStatus) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => a.examDate.compareTo(b.examDate));
  }

  Competition? _nextUpcoming(List<Competition> all) {
    final upcoming = all.where((c) => c.examDate.isAfter(_now)).toList()
      ..sort((a, b) => a.examDate.compareTo(b.examDate));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(competitionCalendarProvider);
    final all = service.getForGrade(11); // 11th graders
    final filtered = _filtered(all);
    final nextComp = _nextUpcoming(all);

    // Group by month
    final grouped = <String, List<Competition>>{};
    for (final c in filtered) {
      final key = DateFormat('MMMM yyyy').format(c.examDate);
      grouped.putIfAbsent(key, () => []).add(c);
    }

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        title: Text(
          'Competition Calendar',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: CustomScrollView(
        slivers: [
          // ── Countdown banner ──
          if (nextComp != null)
            SliverToBoxAdapter(
              child: _CountdownBanner(
                competition: nextComp,
                now: _now,
              ),
            ),

          // ── Filter chips ──
          SliverToBoxAdapter(
            child: _FilterSection(
              selectedCategory: _selectedCategory,
              selectedStatus: _selectedStatus,
              onCategoryChanged: (v) => setState(() => _selectedCategory = v),
              onStatusChanged: (v) => setState(() => _selectedStatus = v),
            ),
          ),

          // ── Timeline ──
          if (grouped.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No competitions match filters',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else
            for (final entry in grouped.entries) ...[
              // Month header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.value.length}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Cards
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _CompetitionCard(
                    competition: entry.value[i],
                    index: i,
                  ),
                  childCount: entry.value.length,
                ),
              ),
            ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}

// ─── Countdown banner ────────────────────────────────────────────────────────
class _CountdownBanner extends StatelessWidget {
  final Competition competition;
  final DateTime now;
  const _CountdownBanner({required this.competition, required this.now});

  @override
  Widget build(BuildContext context) {
    final diff = competition.examDate.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final mins = diff.inMinutes % 60;
    final secs = diff.inSeconds % 60;

    final catColor = _categoryColors[competition.category] ?? AppTheme.primary;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [catColor, catColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: catColor.withValues(alpha: 0.3),
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
              const Icon(Icons.timer_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'Next Upcoming',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            competition.name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _CountdownUnit(value: '$days', label: 'DAYS'),
              const SizedBox(width: 8),
              _CountdownUnit(value: '$hours', label: 'HRS'),
              const SizedBox(width: 8),
              _CountdownUnit(value: '$mins', label: 'MIN'),
              const SizedBox(width: 8),
              _CountdownUnit(value: '$secs', label: 'SEC'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }
}

class _CountdownUnit extends StatelessWidget {
  final String value;
  final String label;
  const _CountdownUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter section ──────────────────────────────────────────────────────────
class _FilterSection extends StatelessWidget {
  final String? selectedCategory;
  final _CompStatus? selectedStatus;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<_CompStatus?> onStatusChanged;

  const _FilterSection({
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: selectedCategory == null,
                  color: AppTheme.textSecondary,
                  onTap: () => onCategoryChanged(null),
                ),
                for (final entry in _categoryColors.entries)
                  _FilterChip(
                    label: _categoryLabels[entry.key] ?? entry.key,
                    selected: selectedCategory == entry.key,
                    color: entry.value,
                    onTap: () => onCategoryChanged(
                      selectedCategory == entry.key ? null : entry.key,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Status chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All Status',
                  selected: selectedStatus == null,
                  color: AppTheme.textSecondary,
                  onTap: () => onStatusChanged(null),
                ),
                for (final s in _CompStatus.values)
                  _FilterChip(
                    label: _statusLabel(s),
                    selected: selectedStatus == s,
                    color: _statusColor(s),
                    onTap: () => onStatusChanged(
                      selectedStatus == s ? null : s,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? color : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.2),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Competition card ────────────────────────────────────────────────────────
class _CompetitionCard extends StatelessWidget {
  final Competition competition;
  final int index;

  const _CompetitionCard({required this.competition, required this.index});

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColors[competition.category] ?? AppTheme.primary;
    final status = _statusFor(competition);
    final difficulty = _difficultyFor(competition);
    final catLabel =
        _categoryLabels[competition.category] ?? competition.category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: catColor.withValues(alpha: 0.15)),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: category + status + difficulty
              Row(
                children: [
                  // Category chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      catLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: catColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _statusIcon(status),
                          size: 12,
                          color: _statusColor(status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _statusLabel(status),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Difficulty
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                          _difficultyColor(difficulty).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      difficulty,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _difficultyColor(difficulty),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Name
              Text(
                competition.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                competition.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              // Date row
              Row(
                children: [
                  Icon(Icons.event_rounded,
                      size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy').format(competition.examDate),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.app_registration_rounded,
                      size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Reg: ${DateFormat('dd MMM').format(competition.registrationStart)} – ${DateFormat('dd MMM').format(competition.registrationEnd)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Action row
              Row(
                children: [
                  // Eligibility
                  Icon(Icons.school_outlined,
                      size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    competition.eligibility
                        .replaceAll('_', ' ')
                        .replaceAll('class ', 'Class '),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (!competition.isFree) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.attach_money_rounded,
                        size: 14, color: AppTheme.warningAmber),
                    Text(
                      'Paid',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.warningAmber,
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Add to calendar
                  _AddToCalendarButton(competition: competition),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
  }
}

// ─── Add to calendar button ──────────────────────────────────────────────────
class _AddToCalendarButton extends StatelessWidget {
  final Competition competition;
  const _AddToCalendarButton({required this.competition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '📅 Added "${competition.name}" to calendar',
            ),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              size: 14,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Add',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
