class ServiceInHouseType {
  String? id;
  String? name;
  String? code;
  int? price;
  String? serviceId;
  String? serviceName;
  String? houseTypeId;
  String? houseTypeCode;
  String? houseTypeDescription;

  ServiceInHouseType(
      {this.id,
        this.name,
        this.code,
        this.price,
        this.serviceId,
        this.serviceName,
        this.houseTypeId,
        this.houseTypeCode,
        this.houseTypeDescription});

  ServiceInHouseType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    price = json['price'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    houseTypeId = json['houseTypeId'];
    houseTypeCode = json['houseTypeCode'];
    houseTypeDescription = json['houseTypeDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['price'] = this.price;
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['houseTypeId'] = this.houseTypeId;
    data['houseTypeCode'] = this.houseTypeCode;
    data['houseTypeDescription'] = this.houseTypeDescription;
    return data;
  }
}
