class ActivityStatusModel {
  String activityId;
  String status;

  ActivityStatusModel({required this.activityId, required this.status});

  factory ActivityStatusModel.fromJson(Map<String, dynamic> json) {
    return ActivityStatusModel(
      activityId: json['ActivityId'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ActivityId': activityId,
      'Status': status,
    };
  }
}
