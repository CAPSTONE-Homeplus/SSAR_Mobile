import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_clean/data/datasource/auth_local_datasource.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late HubConnection hubConnection;
  List<Map<String, String>> notifications = [];
  final AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();


  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _initializeSignalRConnection();
  }

  void _initializeSignalRConnection() {
    hubConnection = HubConnectionBuilder()
        .withUrl(
      'https://vinwallet.onrender.com/vinWalletHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    hubConnection.on('ReceiveNotificationToAll', (arguments) {
      _handleSignalRNotification(arguments);
    });
    hubConnection.on('ReceiveNotificationToUser', (arguments) {
      _handleSignalRNotification(arguments);
    });
    hubConnection.on('ReceiveNotificationToGroup', (arguments) {
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

  /// Hàm lấy token (giả định bạn có hàm này)
  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    print("Token hiện tại: $currentToken");
    return currentToken ?? '';
  }

  void _handleSignalRNotification(List<Object?>? arguments) {
    if (arguments != null && arguments.length >= 2) {
      String title = arguments[0]?.toString() ?? 'Thông báo';
      String message = arguments[1]?.toString() ?? 'Nội dung thông báo';
      setState(() {
        notifications.insert(0, {'title': title, 'message': message});
      });
      _showNotification(title: title, message: message);
    }
  }

  Future<void> _showNotification({required String title, required String message}) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông báo')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]['title']!),
            subtitle: Text(notifications[index]['message']!),
            leading: Icon(Icons.notifications, color: Colors.blue),
          );
        },
      ),
    );
  }
}