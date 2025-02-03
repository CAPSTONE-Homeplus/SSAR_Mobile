class ExtraServiceModel {
  String? id;
  String? name;
  int? price;
  String? status;
  int? extraTime;
  String? createdAt;
  String? updatedAt;
  String? code;
  String? serviceId;

  ExtraServiceModel({
    this.id,
    this.name,
    this.price,
    this.status,
    this.extraTime,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.serviceId,
  });

  factory ExtraServiceModel.fromJson(Map<String, dynamic> json) {
    return ExtraServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      status: json['status'],
      extraTime: json['extra_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      code: json['code'],
      serviceId: json['service_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'status': status,
      'extra_time': extraTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'code': code,
      'service_id': serviceId,
    };
  }
}
