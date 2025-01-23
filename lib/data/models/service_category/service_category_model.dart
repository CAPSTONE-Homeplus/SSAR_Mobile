class ServiceCategoryModel {
  String? id;
  String? name;
  String? status;
  String? createAt;
  String? updatedAt;
  String? code;

  ServiceCategoryModel(
      {this.id,
      this.name,
      this.status,
      this.createAt,
      this.updatedAt,
      this.code});

  ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createAt = json['createAt'];
    updatedAt = json['updatedAt'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['createAt'] = createAt;
    data['updatedAt'] = updatedAt;
    data['code'] = code;
    return data;
  }
}
