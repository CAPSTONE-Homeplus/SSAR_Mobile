abstract class NotificationRepository {
  Future<void> showNotification({required String title, required String message});
  Future<void> init();
}