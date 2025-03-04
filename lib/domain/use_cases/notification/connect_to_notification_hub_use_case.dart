import 'package:home_clean/domain/repositories/notification_repository.dart';

class ConnectToNotificationHubUseCase {
  final NotificationRepository repository;

  ConnectToNotificationHubUseCase(this.repository);

  Future<void> call() async {
    await repository.connectToNotificationHub();
  }
}
