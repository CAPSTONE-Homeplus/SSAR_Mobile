import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getFCMToken();
    _setupFirebaseMessaging();
    _setupLocalNotifications();
  }

  void _setupFirebaseMessaging() {
    // Lấy Token để gửi thông báo đến thiết bị này
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
    });

    // Đăng ký nhận thông báo khi app đang chạy
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.notification?.title}');
      _showNotification(message);
    });

    // Đăng ký nhận thông báo khi app ở chế độ nền
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'App was opened from a notification: ${message.notification?.title}');
    });

    // Xử lý khi app bị tắt hoặc không chạy
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.notification?.title}');
    // Xử lý thông báo ở đây nếu cần
  }

  void _getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }

  void _setupLocalNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id', // ID của kênh thông báo
      'your_channel_name', // Tên kênh thông báo
      importance: Importance.max, // Độ quan trọng của thông báo
      playSound: true,
      showWhen: true,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nhận thông báo tự động")),
      body: Center(
        child: Text("Chờ thông báo..."),
      ),
    );
  }
}
