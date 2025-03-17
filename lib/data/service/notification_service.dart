import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/constant/colors.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification(
      String title,
      String body,
      {String? imageUrl}
      ) async {
    // Cấu hình chi tiết Android
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Thông báo',
      importance: Importance.max,
      priority: Priority.high,

      // Tùy chỉnh giao diện
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,

        // Màu sắc và định dạng
        summaryText: 'Thông báo mới',
        htmlFormatSummaryText: true,
      ),

      // Tùy chỉnh màu sắc
      color: AppColors.primaryColor,

      // Hình ảnh (nếu có)
      largeIcon: imageUrl != null
          ? DrawableResourceAndroidBitmap(imageUrl)
          : null,

      // Các thuộc tính giao diện khác
      channelShowBadge: true,
      enableLights: true,
      ledColor: const Color(0xFF2ecc71),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    // Cấu hình chi tiết thông báo
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      // Có thể thêm cấu hình cho iOS ở đây nếu cần
    );

    // Hiển thị thông báo
    await FlutterLocalNotificationsPlugin().show(
      0, // ID thông báo
      title,
      body,
      notificationDetails,

      // Payload để xử lý khi nhấn vào thông báo
      payload: 'custom_notification',
    );
  }

  // Phương thức để xử lý khi người dùng nhấn vào thông báo
  static void onNotificationTap(String? payload) {
    if (payload != null) {
      // Xử lý khi nhấn vào thông báo
      // Ví dụ: chuyển đến một màn hình cụ thể
      // Navigator.of(context).push(...)
    }
  }
}
