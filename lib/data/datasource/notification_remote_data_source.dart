import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_clean/data/datasource/auth_local_datasource.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

import '../models/notification/notification_model.dart';
import 'notification_local_data_source.dart';

class NotificationRemoteDataSource {
  late HubConnection hubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final NotificationLocalDataSource localDataSource;
  final StreamController<NotificationModel> _notificationController = StreamController<NotificationModel>.broadcast();

  Stream<NotificationModel> get notificationStream => _notificationController.stream;

  NotificationRemoteDataSource({
    required this.authLocalDataSource,
    required this.localDataSource, // Thêm vào
  });

  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> connectToHub() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
      'https://vinwallet.onrender.com/vinWalletHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    hubConnection.on('ReceiveNotificationToAll', _handleNotification);
    hubConnection.on('ReceiveNotificationToUser', _handleNotification);
    hubConnection.on('ReceiveNotificationToGroup', _handleNotification);

    await _startSignalRConnection();
  }
  void _handleNotification(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) {
      print('⚠️ Nhận thông báo nhưng không có dữ liệu hợp lệ');
      return;
    }

    try {
      // Nếu chỉ có một phần tử, sử dụng nó làm message chính
      String message = arguments.first?.toString() ?? 'Có thông báo mới';

      final notification = NotificationModel(
        id: const Uuid().v4(),
        title: 'Thông báo', // Giữ title chung hoặc có thể cập nhật theo nội dung
        message: message, // Hiển thị nội dung chính của thông báo
        timestamp: DateTime.now(),
        isRead: false,
        type: 'custom',
        payload: arguments.length > 1 ? {for (int i = 0; i < arguments.length; i++) 'arg_$i': arguments[i]} : null,
      );

      print('📢 Nhận thông báo: $message');
      localDataSource.addNotification(notification);

      _notificationController.add(notification);
    } catch (e) {
      print('❌ Lỗi khi xử lý thông báo: $e');
    }
  }


  Future<void> _startSignalRConnection() async {
    if (hubConnection.state == HubConnectionState.Connected ||
        hubConnection.state == HubConnectionState.Connecting) {
      print('🔄 SignalR đã kết nối hoặc đang kết nối, không cần kết nối lại.');
      return;
    }

    try {
      await hubConnection.start();
      print('✅ Kết nối SignalR thành công');
    } catch (e) {
      print('❌ Lỗi kết nối SignalR: $e');
      await Future.delayed(Duration(seconds: 5));
      await _startSignalRConnection();
    }
  }


  Future<void> disconnectFromHub() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.stop();
    }
  }

  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    // Giả định API gọi để lấy thông báo từ server
    // Trong một ứng dụng thực tế, bạn sẽ thay thế điều này bằng một lệnh gọi API thực tế
    await Future.delayed(Duration(seconds: 1)); // Giả lập độ trễ mạng
    return []; // Trả về danh sách rỗng cho ví dụ này
  }

  Future<void> markAsRead(String notificationId) async {
    // API call để đánh dấu thông báo đã đọc trên server
    await Future.delayed(Duration(milliseconds: 300));
  }

  Future<void> deleteNotification(String notificationId) async {
    // API call để xóa thông báo trên server
    await Future.delayed(Duration(milliseconds: 300));
  }
}
