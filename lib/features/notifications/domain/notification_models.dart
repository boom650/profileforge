/// Notification domain — what a user notification is, its type, and the
/// filter views offered in the notification center.
library;

/// Kinds of real app state a notification can be built from.
enum NotificationType { score, ai, achievement, streak, system }

/// Filters offered in the notification center.
enum NotificationFilter {
  all('All'),
  unread('Unread'),
  achievements('Achievements'),
  ai('AI');

  const NotificationFilter(this.label);
  final String label;
}

/// A single notification, derived from real app state (streak, XP ledger,
/// achievements) — nothing fabricated.
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}