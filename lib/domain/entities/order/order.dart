import '../extra_service/extra_service.dart';
import '../option/option.dart';

class Order {
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
  List<ExtraService>? extraServices;
  List<Option>? options;

  Order({
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
    this.extraServices,
    this.options,
  });
}