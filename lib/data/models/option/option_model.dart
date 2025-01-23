class OptionModel {
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

  OptionModel({
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

  OptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    note = json['note'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isMandatory = json['is_mandatory'];
    maxQuantity = json['max_quantity'];
    discount = json['discount'];
    code = json['code'];
    serviceId = json['service_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['note'] = note;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_mandatory'] = isMandatory;
    data['max_quantity'] = maxQuantity;
    data['discount'] = discount;
    data['code'] = code;
    data['service_id'] = serviceId;
    return data;
  }
}
