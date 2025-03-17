class OrderTracking {
  final String orderId;
  final List<OrderStep> steps;

  OrderTracking({
    required this.orderId,
    required this.steps,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      orderId: json['orderId'] ?? '',
      steps: (json['steps'] as List)
          .map((step) => OrderStep(
        title: step['title'] ?? '',
        description: step['description'] ?? '',
        time: step['time'] ?? '',
        status: step['status'] ?? '',
        subActivities: step['subActivities'] != null
            ? (step['subActivities'] as List)
            .map((subActivity) => ActivityStatus.fromJson(subActivity))
            .toList()
            : [],
      ))
          .toList(),
    );
  }

  factory OrderTracking.fromJsonSignalR(Map<String, dynamic> json) {
    return OrderTracking(
      orderId: json['OrderId'] ?? '',
      steps: (json['Steps'] as List)
          .map((step) => OrderStep(
        title: step['Title'] ?? '',
        description: step['Description'] ?? '',
        time: step['Time'] ?? '',
        status: step['Status'] ?? '',
        subActivities: step['SubActivities'] != null
            ? (step['SubActivities'] as List)
            .map((subActivity) => ActivityStatus.fromJsonSignalR(subActivity))
            .toList()
            : [],
      ))
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'Steps': steps.map((step) => {
        'Title': step.title,
        'Description': step.description,
        'Time': step.time,
        'Status': step.status.toString().split('.').last,
        'SubActivities': step.subActivities?.map((subActivity) => subActivity.toJson()).toList(),
      }).toList(),
    };
  }
}

class OrderStep {
  final String title;
  final String description;
  final String time;
  final String status;
  final List<ActivityStatus>? subActivities;

  OrderStep({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
    this.subActivities,
  });

  factory OrderStep.fromJson(OrderStep json) {
    return OrderStep(
      title: json.title,
      description: json.description,
      time: json.time,
      status: json.status,
      subActivities: json.subActivities,
    );
  }

}

class ActivityStatus {
  final String activityId;
  final String title;
  final String estimatedTime;
  final String status;

  ActivityStatus({
    required this.activityId,
    required this.title,
    required this.estimatedTime,
    required this.status,
  });

  factory ActivityStatus.fromJson(Map<String, dynamic> json) {
    return ActivityStatus(
      activityId: json['activityId'] ?? '',
      title: json['title'] ?? '',
      estimatedTime: json['estimatedTime'] ?? '',
      status: json['status'] ?? '',
    );
  }

  factory ActivityStatus.fromJsonSignalR(Map<String, dynamic> json) {
    return ActivityStatus(
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
