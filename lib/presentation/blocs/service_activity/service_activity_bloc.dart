import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/service_activity/get_service_activities_by_service_usecase.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_event.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_state.dart';
import '../../../core/constant/constants.dart';

class ServiceActivityBloc
    extends Bloc<ServiceActivityEvent, ServiceActivityState> {
  final GetServiceActivitiesByServiceUsecase getServiceActivitiesByService;

  ServiceActivityBloc({required this.getServiceActivitiesByService})
      : super(ServiceActivityInitialState()) {
    on<GetServiceActivitiesByServiceIdEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetServiceActivitiesByServiceIdEvent event,
    Emitter<ServiceActivityState> emit,
  ) async {
    emit(ServiceActivityLoadingState());
    try {
      final response = await getServiceActivitiesByService.execute(
        event.serviceId,
        event.search,
        event.orderBy,
        event.page ,
        event.size,
      );

      emit(ServiceActivitySuccessState(serviceActivities: response.items));
    } catch (e) {
      emit(ServiceActivityErrorState(message: e.toString()));
    }
  }
}
