import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/notifications/application/notification_providers.dart';
import 'package:profileforge/features/notifications/domain/notification_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// NotificationCenterScreen — View and manage notifications.
///
/// Features:
/// - Notification list built from REAL app state (streak, XP ledger,
///   achievements) — nothing fabricated
/// - Mark as read/unread (session view; no persistence layer exists yet)
/// - Filter by type
/// - Empty state
/// ────────────────────────────────────────────────────────────────────────────
class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen> {
  NotificationFilter _filter = NotificationFilter.all;
  final Set<String> _readIds = {};
  final Set<String> _deletedIds = {};

  /// REAL notifications, derived live from app state via the repository.
  List<AppNotification> get _notifications {
    final profileId = ref.watch(activeProfileIdProvider).valueOrNull ?? '';
    final base = ref.watch(notificationsProvider(profileId)).valueOrNull ??
        const <AppNotification>[];
    return [
      for (final n in base) n.copyWith(isRead: _readIds.contains(n.id)),
    ];
  }

  void _markAsRead(String id) {
    HapticFeedback.selectionClick();
    setState(() => _readIds.add(id));
  }

  void _deleteNotification(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _deletedIds.add(id));
  }

  void _markAllAsRead() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (final n in _notifications) {
        _readIds.add(n.id);
      }
    });
  }

  List<AppNotification> get _filteredNotifications {
    final visible = _notifications.where((n) => !_deletedIds.contains(n.id));
    switch (_filter) {
      case NotificationFilter.all:
        return visible.toList();
      case NotificationFilter.unread:
        return visible.where((n) => !n.isRead).toList();
      case NotificationFilter.achievements:
        return visible
            .where((n) => n.type == NotificationType.achievement)
            .toList();
      case NotificationFilter.ai:
        return visible.where((n) => n.type == NotificationType.ai).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
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
                          color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
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
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Palette.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unreadCount new',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Palette.primary,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (unreadCount > 0)
                      GestureDetector(
                        onTap: _markAllAsRead,
                        child: Text(
                          'Mark all read',
                          style: TextStyle(
                            fontSize: 12,
                            color: Palette.primary,
                          ),
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
                    children: NotificationFilter.values.map((filter) {
                      final isSelected = _filter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _filter = filter);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Palette.primary.withValues(alpha: 0.15)
                                  : dark
                                      ? Palette.surface2.withValues(alpha: 0.5)
                                      : const Color(0xFFF4ECE1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Palette.primary.withValues(alpha: 0.3)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                filter.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Palette.primary
                                      : (dark
                                          ? Palette.textSecondary
                                          : Palette.textTertiary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Notifications List ──
              Expanded(
                child: _filteredNotifications.isEmpty
                    ? _buildEmptyState(dark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _filteredNotifications[index];
                          return Dismissible(
                            key: Key(notification.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) =>
                                _deleteNotification(notification.id),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Palette.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Palette.error,
                              ),
                            ),
                            child: _buildNotificationItem(
                                notification, dark),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification, bool dark) {
    final typeColor = _getTypeColor(notification.type);

    return GestureDetector(
      onTap: () => _markAsRead(notification.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (dark
                  ? Palette.surface1.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.6))
              : (dark
                  ? Palette.surface1.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? (dark
                    ? Palette.border.withValues(alpha: 0.3)
                    : const Color(0xFFEDE3D6))
                : typeColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getTypeIcon(notification.type),
                size: 20,
                color: typeColor,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: dark
                                ? Palette.textPrimary
                                : Palette.textInverse,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark
                          ? Palette.textSecondary
                          : Palette.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool dark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off,
            size: 48,
            color: dark
                ? Palette.textTertiary.withValues(alpha: 0.5)
                : Palette.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.score:
        return Palette.primary;
      case NotificationType.ai:
        return Palette.info;
      case NotificationType.achievement:
        return Palette.warning;
      case NotificationType.streak:
        return Palette.error;
      case NotificationType.system:
        return Palette.textTertiary;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.score:
        return Icons.speed;
      case NotificationType.ai:
        return Icons.auto_awesome;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.streak:
        return Icons.local_fire_department;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
