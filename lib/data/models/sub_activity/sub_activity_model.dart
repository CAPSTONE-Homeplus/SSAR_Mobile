class SubActivityModel {
  String? id;
  String? name;
  String? code;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? serviceActivityId;

  SubActivityModel({
    this.id,
    this.name,
    this.code,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.serviceActivityId,
  });

  factory SubActivityModel.fromJson(Map<String, dynamic> json) {
    return SubActivityModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      serviceActivityId: json['service_activity_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'service_activity_id': serviceActivityId,
    };
  }
}
