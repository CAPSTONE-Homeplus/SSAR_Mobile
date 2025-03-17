// class ActivityStatusModel {
//   String activityId;
//   String title;
//   String estimatedTime;
//   String status;
//
//   ActivityStatusModel({
//     required this.activityId,
//     required this.title,
//     required this.estimatedTime,
//     required this.status,
//   });
//
//   factory ActivityStatusModel.fromJson(Map<String, dynamic> json) {
//     return ActivityStatusModel(
//       activityId: json['ActivityId'] ?? '',
//       title: json['Title'] ?? '',
//       estimatedTime: json['EstimatedTime'] ?? '',
//       status: json['Status'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'ActivityId': activityId,
//       'Title': title,
//       'EstimatedTime': estimatedTime,
//       'Status': status,
//     };
//   }
// }
