import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/effects/error_widgets.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/tap_scale.dart';
import '../application/calendar_provider.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Calendar screen — Premium heat-map calendar with session visualization.
/// ────────────────────────────────────────────────────────────────────────────
class CalendarScreen extends ConsumerStatefulWidget {
  final String profileId;
  const CalendarScreen({super.key, required this.profileId});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final calendarAsync = ref.watch(calendarProvider(widget.profileId));

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'Study Calendar',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: calendarAsync.when(
        data: (sessions) {
          final monthSessions = sessions.where((s) =>
              s.startedAt.year == _currentMonth.year &&
              s.startedAt.month == _currentMonth.month).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month header
                _buildMonthHeader(),
                const SizedBox(height: 20),

                // Calendar grid
                _buildCalendarGrid(sessions),
                const SizedBox(height: 24),

                // Legend
                _buildLegend(),
                const SizedBox(height: 24),

                // Month stats
                _buildMonthStats(monthSessions),
                const SizedBox(height: 24),

                // Recent sessions
                if (monthSessions.isNotEmpty) ...[
                  Text(
                    'Sessions This Month',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...monthSessions.take(5).map((s) => _buildSessionTile(s)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Palette.primary)),
        error: (e, _) => PremiumErrorWidget(
          title: 'Failed to load calendar',
          message: '$e',
          onRetry: () {},
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TapScale(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Palette.surface1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Palette.border.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
            key: ValueKey(_currentMonth),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TapScale(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Palette.surface1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Palette.border.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildCalendarGrid(List sessions) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // Sunday = 0
    final daysInMonth = lastDay.day;

    // Count sessions per day
    final dayCounts = <int, int>{};
    for (final s in sessions) {
      if (s.startedAt.year == _currentMonth.year && s.startedAt.month == _currentMonth.month) {
        dayCounts[s.startedAt.day] = (dayCounts[s.startedAt.day] ?? 0) + 1;
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    color: Palette.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),

          // Calendar cells
          ...List.generate(((startWeekday + daysInMonth) / 7).ceil(), (week) {
            return Row(
              children: List.generate(7, (dayOfWeek) {
                final cellIndex = week * 7 + dayOfWeek;
                final dayNum = cellIndex - startWeekday + 1;

                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 44));
                }

                final count = dayCounts[dayNum] ?? 0;
                final intensity = count == 0 ? 0.0 : (count >= 3 ? 1.0 : count / 3);
                final isToday = DateTime.now().year == _currentMonth.year &&
                    DateTime.now().month == _currentMonth.month &&
                    DateTime.now().day == dayNum;

                return Expanded(
                  child: TapScale(
                    onTap: () => HapticFeedback.selectionClick(),
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: count > 0
                            ? Palette.primary.withValues(alpha: 0.1 + intensity * 0.4)
                            : (isToday ? Palette.primary.withValues(alpha: 0.1) : Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday
                            ? Border.all(color: Palette.primary, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNum',
                          style: TextStyle(
                            color: isToday
                                ? Palette.primary
                                : (count > 0 ? Colors.white : Palette.textSecondary),
                            fontSize: 13,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Less', style: TextStyle(color: Palette.textTertiary, fontSize: 11)),
        const SizedBox(width: 8),
        ...List.generate(5, (i) => Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Palette.primary.withValues(alpha: i == 0 ? 0.05 : 0.1 + (i / 4) * 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        )),
        const SizedBox(width: 8),
        Text('More', style: TextStyle(color: Palette.textTertiary, fontSize: 11)),
      ],
    );
  }

  Widget _buildMonthStats(List sessions) {
    final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final daysActive = sessions.map((s) => s.startedAt.day).toSet().length;
    final avgPerDay = daysActive > 0 ? (totalMinutes / daysActive).round() : 0;

    return Row(
      children: [
        _statCard('Sessions', '${sessions.length}', Palette.primary),
        const SizedBox(width: 10),
        _statCard('Hours', '${(totalMinutes / 60).toStringAsFixed(1)}', Palette.accent),
        const SizedBox(width: 10),
        _statCard('Active Days', '$daysActive', Palette.success),
        const SizedBox(width: 10),
        _statCard('Avg/Day', '${avgPerDay}m', Palette.info),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Palette.textTertiary, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(dynamic session) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.timer, color: Palette.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.taskType ?? 'Study Session',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${session.durationMinutes} min • ${_formatDate(session.startedAt)}',
                    style: TextStyle(color: Palette.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Palette.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${session.xpEarned} XP',
                style: const TextStyle(
                  color: Palette.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = ['', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month];
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month]} ${dt.day}';
  }
}
