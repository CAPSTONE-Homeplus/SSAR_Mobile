
import '../../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String notificationId) async {
    await repository.markAsRead(notificationId);
  }
}