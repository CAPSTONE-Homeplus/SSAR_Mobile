import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/order_repository.dart';
import 'package:home_clean/presentation/blocs/service_in_house_type/service_price_event.dart';
import 'package:home_clean/presentation/blocs/service_in_house_type/service_price_state.dart';

class ServicePriceBloc extends Bloc<ServicePriceEvent, ServicePriceState> {
  final OrderRepository serviceRepository;

  ServicePriceBloc({required this.serviceRepository}) : super(ServicePriceInitial()) {
    on<GetServicePrice>(_onGetServicePrice);
  }

  Future<void> _onGetServicePrice(
      GetServicePrice event,
      Emitter<ServicePriceState> emit,
      ) async {
    emit(ServicePriceLoading());
    try {
      final result = await serviceRepository.getPriceByHouseType(event.houseId, event.serviceId);
      emit(ServicePriceLoaded(servicePrice: result));
    } catch (e) {
      emit(ServicePriceError(message: e.toString()));
    }
  }
}
