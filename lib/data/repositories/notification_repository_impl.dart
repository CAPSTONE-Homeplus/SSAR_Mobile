import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late HubConnection hubConnection;

  NotificationRepositoryImpl(this.flutterLocalNotificationsPlugin);

  @override
  Future<void> init() async {
    // Cấu hình Flutter Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Khởi tạo SignalR
    _initializeSignalRConnection();
  }

  void _initializeSignalRConnection() {
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://vinwallet.onrender.com/vinWalletHub',
          options: HttpConnectionOptions(
            headers: MessageHeaders()..setHeaderValue('houseId', '7ba29697-37eb-4062-bd43-1ee399e33868'),
          ),
        )
        .withAutomaticReconnect()
        .build();

    hubConnection.on('ReceiveNotificationToAll', (arguments) {
      print('📩 Nhận sự kiện ReceiveNotificationToAll: $arguments');
      _handleSignalRNotification(arguments);
    });
    hubConnection.on('ReceiveNotificationToUser', (arguments) {
      print('📩 Nhận sự kiện ReceiveNotificationToUser: $arguments');
      _handleSignalRNotification(arguments);
    });
    hubConnection.on('ReceiveNotificationToGroup', (arguments) {
      print('📩 Nhận sự kiện ReceiveNotificationToGroup: $arguments');
      _handleSignalRNotification(arguments);
    });
    _startSignalRConnection();
  }

  Future<void> _startSignalRConnection() async {
    try {
      await hubConnection.start();
      print('Kết nối SignalR thành công');

    } catch (e) {
      print('Lỗi kết nối SignalR: $e');
      await Future.delayed(Duration(seconds: 5));
      await _startSignalRConnection();
    }
  }

  void _handleSignalRNotification(List<Object?>? arguments) {
    print('🔔 Dữ liệu nhận từ SignalR: $arguments');

    if (arguments != null && arguments.length >= 2) {
      String title = arguments[0]?.toString() ?? 'Thông báo';
      String message = arguments[1]?.toString() ?? 'Nội dung thông báo';
      showNotification(title: title, message: message);
    }
  }


  @override
  Future<void> showNotification({required String title, required String message}) async {
    print('🛑 Gửi thông báo: Title: $title, Message: $message');

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Thông báo',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      autoCancel: true,
    );
    NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 10000,
      title,
      message,
      platformDetails,
    );
  }

}
