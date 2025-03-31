import '../../domain/entities/laundry_service_type/laundry_service_type.dart';

class LaundryServiceTypeMapper {
  static LaundryServiceType fromJson(Map<String, dynamic> json) {
    return LaundryServiceType(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  static Map<String, dynamic> toJson(LaundryServiceType model) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = model.id;
    data['name'] = model.name;
    data['type'] = model.type;
    data['description'] = model.description;
    data['status'] = model.status;
    data['createdAt'] = model.createdAt;
    data['updatedAt'] = model.updatedAt;
    return data;
  }
}