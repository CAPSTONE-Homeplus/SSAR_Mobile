import 'package:home_clean/domain/entities/extra_service/extra_service.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

import '../option/option.dart';

class CreateOrder {
  String address;
  String notes;
  bool emergencyRequest;
  TimeSlot timeSlot;
  Service service;
  String? userId;
  String? houseTypeId;
  List<Option> option;
  List<ExtraService> extraService;

  CreateOrder({
    required this.address,
    required this.notes,
    required this.emergencyRequest,
    required this.timeSlot,
    required this.service,
    this.houseTypeId,
    this.userId,
    required this.option,
    required this.extraService,
  });

  CreateOrder copyWith({
    String? address,
    String? notes,
    bool? emergencyRequest,
    TimeSlot? timeSlot,
    Service? service,
    String? userId,
    String? houseTypeId,
    List<Option>? option,
    List<ExtraService>? extraService,
  }) {
    return CreateOrder(
      address: address ?? this.address,
      notes: notes ?? this.notes,
      emergencyRequest: emergencyRequest ?? this.emergencyRequest,
      timeSlot: timeSlot ?? this.timeSlot,
      service: service ?? this.service,
      userId: userId ?? this.userId,
      houseTypeId: houseTypeId ?? this.houseTypeId,
      option: option ?? this.option,
      extraService: extraService ?? this.extraService,
    );
  }
}