import '../../repositories/notification_repository.dart';

class ShowNotificationUseCase {
  final NotificationRepository repository;

  ShowNotificationUseCase(this.repository);

  Future<void> call(String title, String message) async {
    await repository.showNotification(title: title, message: message);
  }
}