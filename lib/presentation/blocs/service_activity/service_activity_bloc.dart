import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/service_activity_repository.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_event.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_state.dart';

class ServiceActivityBloc
    extends Bloc<ServiceActivityEvent, ServiceActivityState> {
  final ServiceActivityRepository serviceActivityRepository;

  ServiceActivityBloc({required this.serviceActivityRepository})
      : super(ServiceActivityInitialState()) {
    on<GetServiceActivitiesByServiceIdEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetServiceActivitiesByServiceIdEvent event,
    Emitter<ServiceActivityState> emit,
  ) async {
    emit(ServiceActivityLoadingState());
    try {
      final response =
          await serviceActivityRepository.getServiceActivitiesByServiceId(
        serviceId: event.serviceId,
      );

      emit(ServiceActivitySuccessState(serviceActivities: response.items));
    } catch (e) {
      emit(ServiceActivityErrorState(message: e.toString()));
    }
  }
}
