import '../../repositories/notification_repository.dart';

class InitializeNotificationUseCase {
  final NotificationRepository repository;

  InitializeNotificationUseCase(this.repository);

  Future<void> call() async {
    await repository.init();
  }
}
