class Option {
  String? id;
  String? name;
  int? price;
  String? note;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? isMandatory;
  int? maxQuantity;
  int? discount;
  String? code;
  String? serviceId;

  Option({
    this.id,
    this.name,
    this.price,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isMandatory,
    this.maxQuantity,
    this.discount,
    this.code,
    this.serviceId,
  });
}
