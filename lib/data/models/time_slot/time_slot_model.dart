class TimeSlotModel {
  String? id;
  String? startTime;
  String? endTime;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? code;

  TimeSlotModel({
    this.id,
    this.startTime,
    this.endTime,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.code,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'code': code,
    };
  }
}
