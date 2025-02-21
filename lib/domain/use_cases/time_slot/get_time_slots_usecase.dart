import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

import '../../repositories/time_slot_repository.dart';


class GetTimeSlotsUsecase {
  final TimeSlotRepository _timeSlotRepository;

  GetTimeSlotsUsecase(this._timeSlotRepository);

  Future<BaseResponse<TimeSlot>> execute(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _timeSlotRepository.getTimeSlots(
      search,
      orderBy,
      page,
      size,
    );
  }
}
