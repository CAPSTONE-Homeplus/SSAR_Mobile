import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/house/get_house_by_building_use_case.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';

import '../../../domain/use_cases/house/get_house_use_case.dart';
import 'house_state.dart';

class HouseBloc extends Bloc<HouseEvent, HouseState> {
  final GetHouseByBuildingUseCase getHouseByBuildingUseCase;
  final GetHouseUseCase getHouseByUseCase;

  HouseBloc({required this.getHouseByBuildingUseCase, required this.getHouseByUseCase})
      : super(HouseInitial()) {
    on<GetHouseByBuilding>(_onGetHouseByBuildingEvent);
    on<GetHouseById>(_onGetHouseByIdEvent);
  }


  Future<void> _onGetHouseByBuildingEvent(
    GetHouseByBuilding event,
    Emitter<HouseState> emit,
  ) async {
    emit(HouseLoading());
      final response = await getHouseByBuildingUseCase.execute(
        event.buildingId,
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );

    response.fold(
      (failure) => emit(HouseError(message: failure.message)),
      (data) => emit(HouseLoaded(houses: data)),
    );
  }

  Future<void> _onGetHouseByIdEvent(
    GetHouseById event,
    Emitter<HouseState> emit,
  ) async {
    emit(HouseLoading());
    final response = await getHouseByUseCase.execute(event.houseId);

    response.fold(
      (failure) => emit(HouseError(message: failure.message)),
      (data) => emit(HouseLoadedById(house: data)),
    );
  }


}