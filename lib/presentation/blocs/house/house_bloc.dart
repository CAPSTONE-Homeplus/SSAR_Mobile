import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/house/get_house_by_building_use_case.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';

import '../../../core/constant/constant.dart';
import 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final GetHouseByBuildingUseCase getHouseByBuildingUseCase;

  HouseBloc({required this.getHouseByBuildingUseCase})
      : super(HouseInitial()) {
    on<GetHouseByBuilding>(_onGetHouseByBuildingEvent);
  }


  Future<void> _onGetHouseByBuildingEvent(
    GetHouseByBuilding event,
    Emitter<HouseState> emit,
  ) async {
    emit(HouseLoading());
    try {
      final response = await getHouseByBuildingUseCase.execute(
        event.buildingId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(HouseLoaded(houses: response));
    } catch (e) {
      emit(HouseError(message: e.toString()));
    }
  }


}