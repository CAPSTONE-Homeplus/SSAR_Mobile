import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';
import 'package:home_clean/domain/repositories/service_repository.dart';
import 'package:home_clean/domain/use_cases/service/clear_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/get_selected_service_ids.dart';
import 'package:home_clean/domain/use_cases/service/get_services_use_case.dart';
import 'package:home_clean/domain/use_cases/service/save_selected_service_ids.dart';

part 'service_event.dart';

part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServicesUseCase getServicesUseCase;
  final ServiceRepository serviceRepository;

  ServiceBloc({
    required this.getServicesUseCase,
    required this.serviceRepository,
  }) : super(ServiceInitialState()) {
    on<GetServicesEvent>(_onGetServicesEvent);
    on<GetServiceByIdEvent>(_onGetServiceEvent);
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

  Future<void> _onGetServiceEvent(
    GetServiceByIdEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoadingState());
    try {
      final response = await serviceRepository.getServiceById(event.id);
      emit(GetServiceByIdState(service: response));
    } catch (e) {
      emit(ServiceErrorState(message: e.toString()));
    }
  }
}
