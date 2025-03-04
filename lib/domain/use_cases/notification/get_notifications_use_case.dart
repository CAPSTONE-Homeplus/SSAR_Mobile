import 'package:home_clean/domain/repositories/notification_repository.dart';

import '../../entities/notification/notification.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
}