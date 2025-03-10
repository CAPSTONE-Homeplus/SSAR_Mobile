import 'package:home_clean/data/datasource/local/wallet_local_data_source.dart';
import 'package:home_clean/data/datasource/signalr/wallet_remote_data_source.dart';

import '../../../domain/repositories/notification_repository.dart';

import '../models/notification/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final WalletLocalDataSource localDataSource;
  final WalletRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      // Ưu tiên lấy dữ liệu từ local trước
      final localNotifications = await localDataSource.getNotifications();

      // Nếu không có kết nối mạng hoặc có lỗi, trả về dữ liệu local
      if (!await remoteDataSource.hasNetworkConnection()) {
        return localNotifications;
      }

      // Lấy dữ liệu từ remote nếu có mạng
      final remoteNotifications = await remoteDataSource.fetchNotifications();

      // Lưu lại vào local để sử dụng offline
      await localDataSource.saveNotifications(remoteNotifications);

      return remoteNotifications;
    } catch (e) {
      // Trong trường hợp lỗi, trả về dữ liệu local
      return await localDataSource.getNotifications();
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await localDataSource.markAsRead(notificationId);
    if (await remoteDataSource.hasNetworkConnection()) {
      await remoteDataSource.markAsRead(notificationId);
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await localDataSource.deleteNotification(notificationId);
    if (await remoteDataSource.hasNetworkConnection()) {
      await remoteDataSource.deleteNotification(notificationId);
    }
  }

  @override
  Future<void> connectToNotificationHub() async {
    await remoteDataSource.connectToHub();
  }

  @override
  Future<void> disconnectFromNotificationHub() async {
    await remoteDataSource.disconnectFromHub();
  }

  @override
  Stream<NotificationModel> onNewNotification() {
    return remoteDataSource.notificationStream;
  }
}
