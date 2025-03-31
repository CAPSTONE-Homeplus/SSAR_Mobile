class LaundryServiceTypeModel {
  String? id;
  String? type;
  String? name;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;

  LaundryServiceTypeModel({
    this.id,
    this.type,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  LaundryServiceTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}