import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_clean/core/router/app_router.dart';

import '../../core/constant/colors.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Cấu hình Android
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Cấu hình iOS
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Xử lý khi nhấn vào thông báo
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationTap(details.payload);
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    // Cấu hình chi tiết Android
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Thông báo',
      importance: Importance.max,
      priority: Priority.high,

      // Cải thiện hiển thị văn bản dài
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,
        summaryText: body,
      ),

      color: AppColors.primaryColor,

      // Hình ảnh (nếu có)
      largeIcon: imageUrl != null
          ? DrawableResourceAndroidBitmap(imageUrl)
          : null,

      channelShowBadge: true,
      enableLights: true,
      ledColor: const Color(0xFF2ecc71),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    // Cấu hình iOS
    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Hiển thị thông báo với payload tùy chọn
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Xử lý khi nhấn vào thông báo
  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    print('Notification Payload: $payload');

    AppRouter.navigateToHome();
  }
}

// Sử dụng ví dụ
class ExampleUsage {
  void sendNotification() {
    NotificationService.showNotification(
      title: 'Thông báo mới',
      body: 'Nội dung thông báo rất dài có thể hiển thị trên nhiều dòng...',
      payload: 'order_detail', // Điều hướng khi nhấn
    );
  }
}