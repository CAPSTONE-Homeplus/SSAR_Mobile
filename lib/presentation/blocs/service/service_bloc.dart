import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/domain/use_cases/service/clear_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/get_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/save_selected_service_ids.dart';

import '../../../domain/repositories/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;
  final SaveSelectedServiceIds saveSelectedServiceIds;
  final GetSelectedServiceIds getSelectedServiceIds;
  final ClearSelectedServiceIds clearSelectedServiceIds;

  ServiceBloc({
    required this.serviceRepository,
    required this.saveSelectedServiceIds,
    required this.getSelectedServiceIds,
    required this.clearSelectedServiceIds,
  }) : super(ServiceInitialState()) {
    on<GetServicesEvent>(_onGetServicesEvent);
    on<SaveServiceIdsEvent>(_onSaveServiceIds);
    on<GetServiceIdsEvent>(_onGetServiceIds);
    on<ClearServiceIdsEvent>(_onClearServiceIds);
  }

  Future<void> _onGetServicesEvent(
    GetServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoadingState());
    try {
      final response = await serviceRepository.getServices(
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );
      emit(ServiceSuccessState(services: response.items));
    } catch (e) {
      emit(ServiceErrorState(message: e.toString()));
    }
  }

  void _onSaveServiceIds(
      SaveServiceIdsEvent event, Emitter<ServiceState> emit) async {
    await saveSelectedServiceIds(event.ids);
    emit(ServiceIdsSavedState());
  }

  void _onGetServiceIds(
      GetServiceIdsEvent event, Emitter<ServiceState> emit) async {
    final ids = await getSelectedServiceIds();
    emit(ServiceIdsLoadedState(ids: ids ?? []));
  }

  void _onClearServiceIds(
      ClearServiceIdsEvent event, Emitter<ServiceState> emit) async {
    await clearSelectedServiceIds();
    emit(ServiceIdsClearedState());
  }
}
