
import '../extra_service/extra_service_model.dart';
import '../option/option_model.dart';

class OrderModel {
  String? id;
  String? note;
  int? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? address;
  String? bookingDate;
  String? employeeId;
  int? employeeRating;
  String? customerFeedback;
  bool? cleaningToolsRequired;
  bool? cleaningToolsProvided;
  String? serviceType;
  int? distanceToCustomer;
  int? priorityLevel;
  String? notes;
  String? discountCode;
  String? discountAmount;
  int? totalAmount;
  String? realTimeStatus;
  String? jobStartTime;
  String? jobEndTime;
  bool? emergencyRequest;
  String? cleaningAreas;
  String? itemsToClean;
  String? estimatedArrivalTime;
  int? estimatedDuration;
  int? actualDuration;
  String? cancellationDeadline;
  String? code;
  String? timeSlotId;
  String? serviceId;
  String? userId;
  String? timeSlotDetail;
  List<ExtraServiceModel>? extraServices;
  List<OptionModel>? options;

  OrderModel({
    this.id,
    this.note,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.bookingDate,
    this.employeeId,
    this.employeeRating,
    this.customerFeedback,
    this.cleaningToolsRequired,
    this.cleaningToolsProvided,
    this.serviceType,
    this.distanceToCustomer,
    this.priorityLevel,
    this.notes,
    this.discountCode,
    this.discountAmount,
    this.totalAmount,
    this.realTimeStatus,
    this.jobStartTime,
    this.jobEndTime,
    this.emergencyRequest,
    this.cleaningAreas,
    this.itemsToClean,
    this.estimatedArrivalTime,
    this.estimatedDuration,
    this.actualDuration,
    this.cancellationDeadline,
    this.code,
    this.timeSlotId,
    this.serviceId,
    this.userId,
    this.timeSlotDetail,
    this.extraServices,
    this.options,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    price = json['price'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    address = json['address'];
    bookingDate = json['bookingDate'];
    employeeId = json['employeeId'];
    employeeRating = json['employeeRating'];
    customerFeedback = json['customerFeedback'];
    cleaningToolsRequired = json['cleaningToolsRequired'];
    cleaningToolsProvided = json['cleaningToolsProvided'];
    serviceType = json['serviceType'];
    distanceToCustomer = json['distanceToCustomer'];
    priorityLevel = json['priorityLevel'];
    notes = json['notes'];
    discountCode = json['discountCode'];
    discountAmount = json['discountAmount'];
    totalAmount = json['totalAmount'];
    realTimeStatus = json['realTimeStatus'];
    jobStartTime = json['jobStartTime'];
    jobEndTime = json['jobEndTime'];
    emergencyRequest = json['emergencyRequest'];
    cleaningAreas = json['cleaningAreas'];
    itemsToClean = json['itemsToClean'];
    estimatedArrivalTime = json['estimatedArrivalTime'];
    estimatedDuration = json['estimatedDuration'];
    actualDuration = json['actualDuration'];
    cancellationDeadline = json['cancellationDeadline'];
    code = json['code'];
    timeSlotId = json['timeSlotId'];
    serviceId = json['serviceId'];
    userId = json['userId'];
    timeSlotDetail = json['timeSlotDetail'];
    if (json['extraServices'] != null) {
      extraServices = <ExtraServiceModel>[];
      json['extraServices'].forEach((v) {
        extraServices!.add(ExtraServiceModel.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <OptionModel>[];
      json['options'].forEach((v) {
        options!.add(OptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['price'] = price;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['address'] = address;
    data['bookingDate'] = bookingDate;
    data['employeeId'] = employeeId;
    data['employeeRating'] = employeeRating;
    data['customerFeedback'] = customerFeedback;
    data['cleaningToolsRequired'] = cleaningToolsRequired;
    data['cleaningToolsProvided'] = cleaningToolsProvided;
    data['serviceType'] = serviceType;
    data['distanceToCustomer'] = distanceToCustomer;
    data['priorityLevel'] = priorityLevel;
    data['notes'] = notes;
    data['discountCode'] = discountCode;
    data['discountAmount'] = discountAmount;
    data['totalAmount'] = totalAmount;
    data['realTimeStatus'] = realTimeStatus;
    data['jobStartTime'] = jobStartTime;
    data['jobEndTime'] = jobEndTime;
    data['emergencyRequest'] = emergencyRequest;
    data['cleaningAreas'] = cleaningAreas;
    data['itemsToClean'] = itemsToClean;
    data['estimatedArrivalTime'] = estimatedArrivalTime;
    data['estimatedDuration'] = estimatedDuration;
    data['actualDuration'] = actualDuration;
    data['cancellationDeadline'] = cancellationDeadline;
    data['code'] = code;
    data['timeSlotId'] = timeSlotId;
    data['serviceId'] = serviceId;
    data['userId'] = userId;
    data['timeSlotDetail'] = timeSlotDetail;
    if (extraServices != null) {
      data['extraServices'] = extraServices!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}