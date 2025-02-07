class CreateOrderModel {
  String? address;
  String? notes;
  bool? emergencyRequest;
  String? timeSlotId;
  String? serviceId;
  String? userId;
  List<String>? optionIds;
  List<String>? extraServiceIds;

  CreateOrderModel({
    this.address,
    this.notes,
    this.emergencyRequest,
    this.timeSlotId,
    this.serviceId,
    this.userId,
    this.optionIds,
    this.extraServiceIds,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    notes = json['notes'];
    emergencyRequest = json['emergencyRequest'];
    timeSlotId = json['timeSlotId'];
    serviceId = json['serviceId'];
    userId = json['userId'];
    optionIds = json['optionIds'].cast<String>();
    extraServiceIds = json['extraServiceIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['notes'] = notes;
    data['emergencyRequest'] = emergencyRequest;
    data['timeSlotId'] = timeSlotId;
    data['serviceId'] = serviceId;
    data['userId'] = userId;
    data['optionIds'] = optionIds;
    data['extraServiceIds'] = extraServiceIds;
    return data;
  }
}