import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/notification/notification_model.dart';

class NotificationLocalDataSource {
  static const String NOTIFICATIONS_KEY = 'notifications_key';

  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationsJson = prefs.getString(NOTIFICATIONS_KEY);

    if (notificationsJson == null) {
      return [];
    }

    List<dynamic> jsonList = json.decode(notificationsJson);
    return jsonList
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = json.encode(
      notifications.map((notification) => notification.toJson()).toList(),
    );

    await prefs.setString(NOTIFICATIONS_KEY, jsonData);
  }

  Future<void> addNotification(NotificationModel notification) async {
    List<NotificationModel> notifications = await getNotifications();
    notifications.insert(0, notification);
    await saveNotifications(notifications);
  }

  Future<void> markAsRead(String notificationId) async {
    List<NotificationModel> notifications = await getNotifications();

    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].id == notificationId) {
        final updatedNotification = NotificationModel(
          id: notifications[i].id,
          title: notifications[i].title,
          message: notifications[i].message,
          timestamp: notifications[i].timestamp,
          isRead: true,
          type: notifications[i].type,
          payload: notifications[i].payload,
        );

        notifications[i] = updatedNotification;
        break;
      }
    }

    await saveNotifications(notifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    List<NotificationModel> notifications = await getNotifications();
    notifications.removeWhere((notification) => notification.id == notificationId);
    await saveNotifications(notifications);
  }
}