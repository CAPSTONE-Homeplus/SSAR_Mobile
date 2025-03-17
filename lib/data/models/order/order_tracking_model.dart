class OrderTrackingModel {
  final String orderId;
  final List<OrderStepModel> steps;

  OrderTrackingModel({
    required this.orderId,
    required this.steps,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      orderId: json['OrderId'] as String,
      steps: (json['Steps'] as List<dynamic>?)
          ?.map((e) => OrderStepModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'Steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}


class OrderStepModel {
  final String title;
  final String description;
  final String time;
  final String status;
  final List<ActivityStatusModel> subActivities;

  OrderStepModel({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    required this.subActivities,
  });

  factory OrderStepModel.fromJson(Map<String, dynamic> json) {
    return OrderStepModel(
      title: json['Title'] ?? '',
      description: json['Description'] ?? '',
      time: json['Time'] ?? '',
      status: json['Status'] ?? '',
      subActivities: (json['SubActivities'] as List<dynamic>?)
          ?.map((e) => ActivityStatusModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Description': description,
      'Time': time,
      'Status': status,
      'SubActivities': subActivities.map((e) => e.toJson()).toList(),
    };
  }
}

class ActivityStatusModel {
  final String activityId;
  final String title;
  final String estimatedTime;
  final String status;

  ActivityStatusModel({
    required this.activityId,
    required this.title,
    required this.estimatedTime,
    required this.status,
  });

  factory ActivityStatusModel.fromJson(Map<String, dynamic> json) {
    return ActivityStatusModel(
      activityId: json['ActivityId'] ?? '',
      title: json['Title'] ?? '',
      estimatedTime: json['EstimatedTime'] ?? '',
      status: json['Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ActivityId': activityId,
      'Title': title,
      'EstimatedTime': estimatedTime,
      'Status': status,
    };
  }
}