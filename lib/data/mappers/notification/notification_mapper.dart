import 'dart:convert';

class NotificationMapper {
  static Map<String, dynamic>? normalizeNotification(Object? arguments) {
    if (arguments == null) return null;

    try {
      if (arguments is List && arguments.isNotEmpty) {
        arguments = arguments.first;
      }

      Map<String, dynamic> notificationData;

      if (arguments is String) {
        notificationData = json.decode(arguments);
      } else {
        return null;
      }

      String? type = notificationData['Type'] as String?;
      dynamic data = notificationData['Data'];

      if (type == null || data == null || type != 'InviteWallet') {
        return null;
      }

      if (data is List) {
        List<Map<String, dynamic>> activities = data.map((item) {
          return {
            'activityId': item['ActivityId']?.toString(),
            'status': item['Status']?.toString(),
          };
        }).toList();

        return {
          'activities': activities,
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}