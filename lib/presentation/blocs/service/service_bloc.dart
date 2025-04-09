import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/domain/use_cases/service/clear_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/get_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/get_services_use_case.dart';
import 'package:home_clean/domain/use_cases/service/save_selected_service_ids.dart';


part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServicesUseCase getServicesUseCase;
  // final SaveSelectedServiceIds saveSelectedServiceIds;
  // final GetSelectedServiceIds getSelectedServiceIds;
  // final ClearSelectedServiceIds clearSelectedServiceIds;

  ServiceBloc({
    required this.getServicesUseCase,
    // required this.saveSelectedServiceIds,
    // required this.getSelectedServiceIds,
    // required this.clearSelectedServiceIds,
  }) : super(ServiceInitialState()) {
    on<GetServicesEvent>(_onGetServicesEvent);
    // on<SaveServiceIdsEvent>(_onSaveServiceIds);
    // on<GetServiceIdsEvent>(_onGetServiceIds);
    // on<ClearServiceIdsEvent>(_onClearServiceIds);
  }

  Future<void> _onGetServicesEvent(
      GetServicesEvent event,
      Emitter<ServiceState> emit,
      ) async {
    emit(ServiceLoadingState());

    final response = await getServicesUseCase.execute(
      search: event.search,
      orderBy: event.orderBy,
      page: event.page,
      size: event.size,
    );

    response.fold(
          (failure) {
        emit(ServiceErrorState(message: failure.message));
      },
          (services) {
        emit(ServiceSuccessState(services: services));
      },
    );
  }


  // void _onSaveServiceIds(
  //     SaveServiceIdsEvent event, Emitter<ServiceState> emit) async {
  //   await saveSelectedServiceIds(event.ids);
  //   emit(ServiceIdsSavedState());
  // }
  //
  // void _onGetServiceIds(
  //     GetServiceIdsEvent event, Emitter<ServiceState> emit) async {
  //   final ids = await getSelectedServiceIds();
  //   emit(ServiceIdsLoadedState(ids: ids ?? []));
  // }
  //
  // void _onClearServiceIds(
  //     ClearServiceIdsEvent event, Emitter<ServiceState> emit) async {
  //   await clearSelectedServiceIds();
  //   emit(ServiceIdsClearedState());
  // }
}
