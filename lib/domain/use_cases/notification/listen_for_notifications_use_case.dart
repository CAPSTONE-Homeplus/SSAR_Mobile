import 'package:home_clean/domain/repositories/notification_repository.dart';

import '../../entities/notification/notification.dart';

class ListenForNotificationsUseCase {
  final NotificationRepository repository;

  ListenForNotificationsUseCase(this.repository);

  Stream<NotificationEntity> call() {
    return repository.onNewNotification();
  }
}