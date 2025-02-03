class EquipmentSupplyModel {
  String? id;
  String? name;
  String? urlImage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? serviceId;
  String? code;

  EquipmentSupplyModel({
    this.id,
    this.name,
    this.urlImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.serviceId,
    this.code,
  });

  factory EquipmentSupplyModel.fromJson(Map<String, dynamic> json) {
    return EquipmentSupplyModel(
      id: json['id'],
      name: json['name'],
      urlImage: json['urlImage'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      serviceId: json['serviceId'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'urlImage': urlImage,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'serviceId': serviceId,
      'code': code,
    };
  }
}
