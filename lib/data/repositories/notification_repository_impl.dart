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
      final localNotifications = await localDataSource.getNotifications();
      if (!await remoteDataSource.hasNetworkConnection()) {
        return localNotifications;
      }
      return localNotifications;
    } catch (e) {
      return await localDataSource.getNotifications();
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
