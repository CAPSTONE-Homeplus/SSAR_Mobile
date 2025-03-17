import '../../../domain/entities/notification/notification.dart';

class NotificationModel extends NotificationEntity{
  NotificationModel({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    bool isRead = false,
    String? type,
    Map<String, dynamic>? payload,
  }) : super(
    id: id,
    title: title,
    message: message,
    timestamp: timestamp,
    isRead: isRead,
    type: type,
    payload: payload,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      type: json['type'],
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type,
      'payload': payload,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      type: entity.type,
      payload: entity.payload,
    );
  }
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      payload: payload ?? this.payload,
    );
  }

}