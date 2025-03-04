import '../entities/notification/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<void> connectToNotificationHub();
  Future<void> disconnectFromNotificationHub();
  Stream<NotificationEntity> onNewNotification();
}