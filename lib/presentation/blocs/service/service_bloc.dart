import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/service_repository.dart';
import 'package:home_clean/presentation/blocs/service/service_event.dart';
import 'package:home_clean/presentation/blocs/service/service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;

  ServiceBloc({required this.serviceRepository})
      : super(ServiceInitialState()) {
    on<GetServicesEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(ServiceLoadingState());
    try {
      final response = await serviceRepository.getServices(
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );
      emit(ServiceSuccessState(services: response.items));
    } catch (e) {
      emit(ServiceErrorState(message: e.toString()));
    }
  }
}
