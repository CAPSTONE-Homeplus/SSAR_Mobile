class Service {
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

  Service(
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
}
