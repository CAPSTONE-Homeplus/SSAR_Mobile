class ServiceActivityModel {
  String? id;
  String? name;
  String? code;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? prorityLevel;
  String? estimatedTimePerTask;
  String? safetyMeasures;
  String? serviceId;

  ServiceActivityModel({
    this.id,
    this.name,
    this.code,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.prorityLevel,
    this.estimatedTimePerTask,
    this.safetyMeasures,
    this.serviceId,
  });

  ServiceActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    prorityLevel = json['prority_level'];
    estimatedTimePerTask = json['estimated_time_per_task'];
    safetyMeasures = json['safety_measures'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['prority_level'] = prorityLevel;
    data['estimated_time_per_task'] = estimatedTimePerTask;
    data['safety_measures'] = safetyMeasures;
    data['service_id'] = serviceId;
    return data;
  }
}
