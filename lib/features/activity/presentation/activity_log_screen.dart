import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ActivityLogScreen — Timeline view of all user activities.
///
/// Features:
/// - Timeline with chronological entries (REAL XP ledger, no fabrications)
/// - Activity type filters
/// - Date grouping
/// - Detail expansion on tap
/// ────────────────────────────────────────────────────────────────────────────
class ActivityLogScreen extends ConsumerStatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  ConsumerState<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends ConsumerState<ActivityLogScreen> {
  ActivityType? _filter;

  /// REAL activity stream — the XP ledger is the single source of truth.
  /// Every XP event (mission, quest, focus session, login) becomes an
  /// activity entry. Nothing is fabricated.
  List<_Activity> _activitiesFromEvents(List<XpEventRow> events) {
    return events.map((e) {
      final (type, icon, color) = switch (e.source) {
        'mission' => (ActivityType.scoreUpdate, Icons.task_alt, Palette.primary),
        'quest' => (ActivityType.scoreUpdate, Icons.flag, Palette.success),
        'focus' => (ActivityType.aiChat, Icons.timer, Palette.info),
        'login' => (ActivityType.system, Icons.login, Palette.textTertiary),
        _ => (ActivityType.system, Icons.bolt, Palette.textTertiary),
      };
      return _Activity(
        type: type,
        title: _titleFor(e.source),
        description: '+${e.amount} XP · balance ${e.balanceAfter}',
        timestamp: e.at,
        icon: icon,
        color: color,
      );
    }).toList();
  }

  String _titleFor(String source) {
    return switch (source) {
      'mission' => 'Mission Completed',
      'quest' => 'Quest Completed',
      'focus' => 'Focus Session Ended',
      'login' => 'Daily Login',
      _ => 'XP Earned',
    };
  }

  List<_Activity> get _filteredActivities {
    // Read the REAL ledger; empty history = honest empty state.
    final profileId = ref.watch(activeProfileIdProvider).valueOrNull ?? '';
    final eventsAsync = ref.watch(xpHistoryProvider(profileId));
    final all = eventsAsync.valueOrNull ?? const <XpEventRow>[];
    final activities = _activitiesFromEvents(all)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (_filter == null) return activities;
    return activities.where((a) => a.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final filtered = _filteredActivities;

    // Group by date
    final grouped = <String, List<_Activity>>{};
    for (final activity in filtered) {
      final key = _formatDate(activity.timestamp);
      grouped.putIfAbsent(key, () => []).add(activity);
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Activity Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${filtered.length} activities',
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? Palette.textSecondary : Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Filters ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All', null, dark),
                      _buildFilterChip('Score', ActivityType.scoreUpdate, dark),
                      _buildFilterChip('AI', ActivityType.aiChat, dark),
                      _buildFilterChip('Badges', ActivityType.achievement, dark),
                      _buildFilterChip('Profile', ActivityType.profileEdit, dark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Timeline ──
              Expanded(
                child: grouped.isEmpty
                    ? _buildEmptyState(dark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _getGroupedItemCount(grouped),
                        itemBuilder: (context, index) {
                          return _buildTimelineItem(index, grouped, dark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ActivityType? type, bool dark) {
    final isSelected = _filter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _filter = type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? Palette.primary.withValues(alpha: 0.15)
                : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Palette.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Palette.primary
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getGroupedItemCount(Map<String, List<_Activity>> grouped) {
    int count = 0;
    for (final entry in grouped.entries) {
      count += 1 + entry.value.length; // 1 for date header + items
    }
    return count;
  }

  Widget _buildTimelineItem(int index, Map<String, List<_Activity>> grouped, bool dark) {
    int currentIndex = 0;
    for (final entry in grouped.entries) {
      if (currentIndex == index) {
        // Date header
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Text(
            entry.key,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: dark ? Palette.textTertiary : Palette.textSecondary,
            ),
          ),
        );
      }
      currentIndex++;

      for (final activity in entry.value) {
        if (currentIndex == index) {
          return _buildActivityEntry(activity, dark);
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildActivityEntry(_Activity activity, bool dark) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline Line ──
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: activity.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: dark
                        ? Palette.border.withValues(alpha: 0.3)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _showActivityDetail(activity, dark);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: dark
                      ? Palette.surface1.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dark ? Palette.border : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: activity.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(activity.icon, size: 18, color: activity.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: dark ? Palette.textPrimary : Palette.textInverse,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: dark ? Palette.textSecondary : Palette.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(activity.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: Palette.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: dark ? Palette.textTertiary : Palette.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool dark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: dark
                ? Palette.textTertiary.withValues(alpha: 0.5)
                : Palette.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Activities Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different filter',
            style: TextStyle(
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDetail(_Activity activity, bool dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: dark ? Palette.surface1 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activity.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(activity.icon, size: 24, color: activity.color),
              ),
              const SizedBox(height: 16),
              Text(
                activity.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatDate(activity.timestamp)} at ${_formatTime(activity.timestamp)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }
    return '${_monthName(date.month)} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}

enum ActivityType {
  scoreUpdate,
  aiChat,
  achievement,
  profileEdit,
  onboarding,
  system,
}

class _Activity {
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  const _Activity({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}
