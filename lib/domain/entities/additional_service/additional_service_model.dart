class AdditionalService{
  String? id;
  String? serviceCode;
  String? name;
  String? description;
  double? price;
  String? priceType;
  String? appliesTo;
  int? processingTimeAdjustment;
  String? status;
  String? createdAt;
  String? updatedAt;

  AdditionalService({
    this.id,
    this.serviceCode,
    this.name,
    this.description,
    this.price,
    this.priceType,
    this.appliesTo,
    this.processingTimeAdjustment,
    this.status,
    this.createdAt,
    this.updatedAt,
  });


  AdditionalService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceCode = json['serviceCode'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    priceType = json['priceType'];
    appliesTo = json['appliesTo'];
    processingTimeAdjustment = json['processingTimeAdjustment'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceCode'] = serviceCode;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['priceType'] = priceType;
    data['appliesTo'] = appliesTo;
    data['processingTimeAdjustment'] = processingTimeAdjustment;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

}