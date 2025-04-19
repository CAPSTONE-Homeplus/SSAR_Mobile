class TimeSlotModel {
  String? id;
  String? startTime;
  String? endTime;
  String? description;
  String? status;
  String? code;

  TimeSlotModel({
    this.id,
    this.startTime,
    this.endTime,
    this.description,
    this.status,
    this.code,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      description: json['description'],
      status: json['status'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'status': status,
      'code': code,
    };
  }
}
