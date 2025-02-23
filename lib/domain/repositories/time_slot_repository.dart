import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

abstract class TimeSlotRepository {
  Future<BaseResponse<TimeSlot>> getTimeSlots(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
