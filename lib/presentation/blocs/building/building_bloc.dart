import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/building_repository.dart';
import 'building_event.dart';
import 'building_state.dart';

class BuildingBloc extends Bloc<BuildingEvent, BuildingState> {
  final BuildingRepository _buildingRepository;

  BuildingBloc({required BuildingRepository buildingRepository})
      : _buildingRepository = buildingRepository,
        super(BuildingInitial()){
    on<GetBuildings>(_onGetBuildings);
  }

  Future<void> _onGetBuildings(
      GetBuildings event,
    Emitter<BuildingState> emit,
  ) async {
    emit(BuildingLoading());
    try {
      final response = await _buildingRepository.getBuildings(
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );

      emit(BuildingLoaded(
        buildings: response.items,
        size: response.size,
        page: response.page,
        total: response.total,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(BuildingError(message: e.toString()));
    }
  }

}