import 'activity_status_model.dart';

class OrderActivityStatusModel {
  String orderId;
  List<ActivityStatusModel> activityStatuses;

  OrderActivityStatusModel({required this.orderId, required this.activityStatuses});

  factory OrderActivityStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderActivityStatusModel(
      orderId: json['OrderId'],
      activityStatuses: (json['ActivityStatuses'] as List)
          .map((item) => ActivityStatusModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'ActivityStatuses': activityStatuses.map((e) => e.toJson()).toList(),
    };
  }
}