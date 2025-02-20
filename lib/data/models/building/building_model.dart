class BuildingModel {
  String? id;
  String? name;
  String? longitude;
  String? latitude;
  String? code;
  String? createdAt;
  String? updatedAt;
  String? hubId;
  String? clusterId;
  String? status;

  BuildingModel({
    this.id,
    this.name,
    this.longitude,
    this.latitude,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.hubId,
    this.clusterId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'code': code,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'hubId': hubId,
      'clusterId': clusterId,
      'status': status,
    };
  }

  factory BuildingModel.fromJson(Map<String, dynamic> map) {
    return BuildingModel(
      id: map['id'],
      name: map['name'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      code: map['code'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      hubId: map['hubId'],
      clusterId: map['clusterId'],
      status: map['status'],
    );
  }
}