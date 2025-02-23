import 'package:home_clean/data/mappers/option_mapper.dart';

import '../../domain/entities/order/order.dart';
import '../models/extra_service/extra_service_model.dart';
import '../models/option/option_model.dart';
import '../models/order/order_model.dart';
import 'extra_service_mapper.dart';

class OrderMapper {
  static OrderModel fromMapToOrderModel(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      note: map['note'],
      price: map['price'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      address: map['address'],
      bookingDate: map['bookingDate'],
      employeeId: map['employeeId'],
      employeeRating: map['employeeRating'],
      customerFeedback: map['customerFeedback'],
      cleaningToolsRequired: map['cleaningToolsRequired'],
      cleaningToolsProvided: map['cleaningToolsProvided'],
      serviceType: map['serviceType'],
      distanceToCustomer: map['distanceToCustomer'],
      priorityLevel: map['priorityLevel'],
      notes: map['notes'],
      discountCode: map['discountCode'],
      discountAmount: map['discountAmount'],
      totalAmount: map['totalAmount'],
      realTimeStatus: map['realTimeStatus'],
      jobStartTime: map['jobStartTime'],
      jobEndTime: map['jobEndTime'],
      emergencyRequest: map['emergencyRequest'],
      cleaningAreas: map['cleaningAreas'],
      itemsToClean: map['itemsToClean'],
      estimatedArrivalTime: map['estimatedArrivalTime'],
      estimatedDuration: map['estimatedDuration'],
      actualDuration: map['actualDuration'],
      cancellationDeadline: map['cancellationDeadline'],
      code: map['code'],
      timeSlotId: map['timeSlotId'],
      serviceId: map['serviceId'],
      userId: map['userId'],

      extraServices: (map['extraServices'] as List?)
          ?.where((e) => e != null)
          .map((e) => ExtraServiceModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],

      options: (map['options'] as List?)
          ?.where((e) => e != null)
          .map((e) => OptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }


  static Orders toEntity(OrderModel model) {
    return Orders(
      id: model.id,
      note: model.note,
      price: model.price,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      address: model.address,
      bookingDate: model.bookingDate,
      employeeId: model.employeeId,
      employeeRating: model.employeeRating,
      customerFeedback: model.customerFeedback,
      cleaningToolsRequired: model.cleaningToolsRequired,
      cleaningToolsProvided: model.cleaningToolsProvided,
      serviceType: model.serviceType,
      distanceToCustomer: model.distanceToCustomer,
      priorityLevel: model.priorityLevel,
      notes: model.notes,
      discountCode: model.discountCode,
      discountAmount: model.discountAmount,
      totalAmount: model.totalAmount,
      realTimeStatus: model.realTimeStatus,
      jobStartTime: model.jobStartTime,
      jobEndTime: model.jobEndTime,
      emergencyRequest: model.emergencyRequest,
      cleaningAreas: model.cleaningAreas,
      itemsToClean: model.itemsToClean,
      estimatedArrivalTime: model.estimatedArrivalTime,
      estimatedDuration: model.estimatedDuration,
      actualDuration: model.actualDuration,
      cancellationDeadline: model.cancellationDeadline,
      code: model.code,
      timeSlotId: model.timeSlotId,
      serviceId: model.serviceId,
      userId: model.userId,
      extraServices: ExtraServiceMapper.toListEntity(model.extraServices ?? []),
      options: OptionMapper.toListEntity(model.options ?? []),
    );
  }

  static OrderModel toModel(Orders entity) {
    return OrderModel(
      id: entity.id,
      note: entity.note,
      price: entity.price,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      address: entity.address,
      bookingDate: entity.bookingDate,
      employeeId: entity.employeeId,
      employeeRating: entity.employeeRating,
      customerFeedback: entity.customerFeedback,
      cleaningToolsRequired: entity.cleaningToolsRequired,
      cleaningToolsProvided: entity.cleaningToolsProvided,
      serviceType: entity.serviceType,
      distanceToCustomer: entity.distanceToCustomer,
      priorityLevel: entity.priorityLevel,
      notes: entity.notes,
      discountCode: entity.discountCode,
      discountAmount: entity.discountAmount,
      totalAmount: entity.totalAmount,
      realTimeStatus: entity.realTimeStatus,
      jobStartTime: entity.jobStartTime,
      jobEndTime: entity.jobEndTime,
      emergencyRequest: entity.emergencyRequest,
      cleaningAreas: entity.cleaningAreas,
      itemsToClean: entity.itemsToClean,
      estimatedArrivalTime: entity.estimatedArrivalTime,
      estimatedDuration: entity.estimatedDuration,
      actualDuration: entity.actualDuration,
      cancellationDeadline: entity.cancellationDeadline,
      code: entity.code,
      timeSlotId: entity.timeSlotId,
      serviceId: entity.serviceId,
      userId: entity.userId,
      extraServices: ExtraServiceMapper.toListModel(entity.extraServices ?? []),
      options: OptionMapper.toListModel(entity.options ?? []),
    );
  }

}