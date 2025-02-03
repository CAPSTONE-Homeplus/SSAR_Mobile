import 'package:home_clean/data/models/time_slot/time_slot_model.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

class TimeSlotMapper {
  static TimeSlot toEntity(TimeSlotModel model) {
    return TimeSlot(
      id: model.id,
      startTime: model.startTime,
      endTime: model.endTime,
      description: model.description,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      code: model.code,
    );
  }

  static TimeSlotModel toModel(TimeSlot entity) {
    return TimeSlotModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      description: entity.description,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      code: entity.code,
    );
  }
}
