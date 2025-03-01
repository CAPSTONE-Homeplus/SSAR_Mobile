import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/building_repository.dart';
import '../../../domain/use_cases/building/get_building_use_case.dart';
import '../../../domain/use_cases/building/get_buildings_use_case.dart';
import 'building_event.dart';
import 'building_state.dart';

class BuildingBloc extends Bloc<BuildingEvent, BuildingState> {
  final GetBuildingUseCase getBuildingUseCase;
  final GetBuildingsUseCase getBuildingsUseCase;

 BuildingBloc({
    required this.getBuildingUseCase,
    required this.getBuildingsUseCase,
  }) : super(BuildingInitial()) {
    on<GetBuilding>(_onGetBuilding);
    on<GetBuildings>(_onGetBuildings);
  }

  Future<void> _onGetBuildings(
      GetBuildings event,
    Emitter<BuildingState> emit,
  ) async {
    emit(BuildingLoading());
    final response = await getBuildingsUseCase.execute(
      event.search,
      event.orderBy,
      event.page,
      event.size,
    );
    response.fold(
      (failure) => emit(BuildingError(message: failure.message)),
      (data) => emit(BuildingLoaded(
        buildings: data,
      )),
    );
  }

  Future<void> _onGetBuilding(
    GetBuilding event,
    Emitter<BuildingState> emit,
  ) async {
    emit(BuildingLoading());
    final response = await getBuildingUseCase.execute(event.buildingId ?? '');
    response.fold(
      (failure) => emit(BuildingError(message: failure.message)),
      (data) => emit(OneBuildingLoaded(building: data)),
    );
  }

}