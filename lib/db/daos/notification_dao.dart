import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'notification_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationDao extends DatabaseAccessor<AppDatabase> with _$NotificationDaoMixin {
  NotificationDao(super.db);

  Future<List<NotificationData>> getAllNotifications(String studentId) => 
      (select(notifications)
        ..where((n) => n.studentId.equals(studentId))
        ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();

  Stream<List<NotificationData>> watchNotifications(String studentId) => 
      (select(notifications)
        ..where((n) => n.studentId.equals(studentId))
        ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .watch();

  Future<List<NotificationData>> getUnreadNotifications(String studentId) => 
      (select(notifications)
        ..where((n) => n.studentId.equals(studentId) & n.isRead.equals(false) & n.isArchived.equals(false))
        ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();

  Future<int> getUnreadCount(String studentId) async {
    final result = await (selectOnly(notifications)
      ..addColumns([notifications.id.count()])
      ..where(notifications.studentId.equals(studentId) & notifications.isRead.equals(false) & notifications.isArchived.equals(false)))
      .getSingle();
    return result.read(notifications.id.count()) ?? 0;
  }

  Future<NotificationData?> getNotification(String id) => 
      (select(notifications)..where((n) => n.id.equals(id))).getSingleOrNull();

  Future<int> insertNotification(NotificationsCompanion notification) => 
      into(notifications).insert(notification);

  Future<bool> updateNotification(NotificationsCompanion notification) => 
      update(notifications).replace(notification);

  Future<int> deleteNotification(String id) => 
      (delete(notifications)..where((n) => n.id.equals(id))).go();

  Future<void> markAsRead(String id) => 
      (update(notifications)..where((n) => n.id.equals(id))).write(NotificationsCompanion(
        isRead: const Value(true),
        readAt: Value(DateTime.now()),
      ));

  Future<void> markAllAsRead(String studentId) => 
      (update(notifications)
        ..where((n) => n.studentId.equals(studentId) & n.isRead.equals(false)))
        .write(NotificationsCompanion(
          isRead: const Value(true),
          readAt: Value(DateTime.now()),
        ));

  Future<void> archiveNotification(String id) => 
      (update(notifications)..where((n) => n.id.equals(id))).write(NotificationsCompanion(
        isArchived: const Value(true),
      ));

  Future<void> archiveAllRead(String studentId) => 
      (update(notifications)
        ..where((n) => n.studentId.equals(studentId) & n.isRead.equals(true)))
        .write(NotificationsCompanion(
          isArchived: const Value(true),
        ));
}