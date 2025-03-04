import 'package:home_clean/domain/repositories/notification_repository.dart';

class DisconnectFromNotificationHubUseCase {
  final NotificationRepository repository;

  DisconnectFromNotificationHubUseCase(this.repository);

  Future<void> call() async {
    await repository.disconnectFromNotificationHub();
  }
}