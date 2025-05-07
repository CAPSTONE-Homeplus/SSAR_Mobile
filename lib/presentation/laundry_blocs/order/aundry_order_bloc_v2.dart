import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/order_repository.dart';

import 'laundry_order_event_v2.dart';
import 'laundry_order_state_v2.dart';

class LaundryOrderBlocV2
    extends Bloc<LaundryOrderEventV2, LaundryOrderStateV2> {
  final OrderRepository orderRepository;

  LaundryOrderBlocV2({required this.orderRepository})
      : super(LaundryOrderInitialV2()) {
    on<GetLaundryOrdersV2>(_onGetLaundryOrders);
    on<GetLaundryOrderDetailV2>(_onGetLaundryOrderDetail);
  }

  Future<void> _onGetLaundryOrders(
    GetLaundryOrdersV2 event,
    Emitter<LaundryOrderStateV2> emit,
  ) async {
    emit(LaundryOrderLoadingV2());

    try {
      final response = await orderRepository.getOrdersByLaundryUser(
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );

      emit(LaundryOrderLoadedV2(response.items ?? []));
    } catch (e) {
      emit(LaundryOrderFailureV2(e.toString()));
    }
  }

  Future<void> _onGetLaundryOrderDetail(
    GetLaundryOrderDetailV2 event,
    Emitter<LaundryOrderStateV2> emit,
  ) async {
    emit(LaundryOrderLoadingV2());

    try {
      final detail = await orderRepository.getLaundryOrderDetail(event.orderId);
      emit(LaundryOrderDetailLoadedV2(detail));
    } catch (e) {
      emit(LaundryOrderFailureV2(e.toString()));
    }
  }
}
