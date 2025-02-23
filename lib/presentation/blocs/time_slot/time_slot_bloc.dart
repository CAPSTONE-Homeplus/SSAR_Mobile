import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_event.dart';
import 'package:home_clean/presentation/blocs/time_slot/time_slot_state.dart';

import '../../../domain/use_cases/time_slot/get_time_slots_usecase.dart';

class TimeSlotBloc extends Bloc<TimeSlotEvent, TimeSlotState> {
  final GetTimeSlotsUsecase getTimeSlotsUsecase;

  TimeSlotBloc({required this.getTimeSlotsUsecase}) : super(TimeSlotInitial()) {
    on<GetTimeSlotEvents>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetTimeSlotEvents event,
    Emitter<TimeSlotState> emit,
  ) async {
    emit(TimeSlotLoading());
    try {
      final response = await getTimeSlotsUsecase.execute(
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(TimeSlotLoaded(timeSlots: response.items));
    } catch (e) {
      emit(TimeSlotError(message: e.toString()));
    }
  }
}
