import 'package:home_clean/domain/repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String notificationId) async {
    await repository.deleteNotification(notificationId);
  }
}