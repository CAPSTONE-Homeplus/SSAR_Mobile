class ServiceModel {
  String? id;
  String? name;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? prorityLevel;
  int? price;
  int? discount;
  int? duration;
  int? maxCapacity;
  String? serviceCode;
  bool? isFeatured;
  bool? isAvailable;
  Null? createdBy;
  Null? updatedBy;
  String? code;
  String? serviceCategoryId;

  ServiceModel(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.prorityLevel,
      this.price,
      this.discount,
      this.duration,
      this.maxCapacity,
      this.serviceCode,
      this.isFeatured,
      this.isAvailable,
      this.createdBy,
      this.updatedBy,
      this.code,
      this.serviceCategoryId});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    prorityLevel = json['prorityLevel'];
    price = json['price'];
    discount = json['discount'];
    duration = json['duration'];
    maxCapacity = json['maxCapacity'];
    serviceCode = json['serviceCode'];
    isFeatured = json['isFeatured'];
    isAvailable = json['isAvailable'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    code = json['code'];
    serviceCategoryId = json['serviceCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['prorityLevel'] = this.prorityLevel;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['maxCapacity'] = this.maxCapacity;
    data['serviceCode'] = this.serviceCode;
    data['isFeatured'] = this.isFeatured;
    data['isAvailable'] = this.isAvailable;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['code'] = this.code;
    data['serviceCategoryId'] = this.serviceCategoryId;
    return data;
  }
}
