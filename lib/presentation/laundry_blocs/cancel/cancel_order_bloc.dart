// In laundry_order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/laundry_blocs/cancel/cancel_order_event.dart';
import 'package:home_clean/presentation/laundry_blocs/cancel/cancel_order_state.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../data/laundry_repositories/laundry_order_repo.dart';
import '../order/laundry_order_event.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  final LaundryOrderRepository repository;

  CancelOrderBloc({required this.repository}) : super(CancelLaundryOrderInitial()) {
    // Add this among your other event handlers
    on<CancelLaundryOrderEvent>(_onCancelLaundryOrder);
  }

  // Add this method to your bloc
  Future<void> _onCancelLaundryOrder(
      CancelLaundryOrderEvent event,
      Emitter<CancelOrderState> emit,
      ) async {
    emit(CancelLaundryOrderLoading());

    try {
      final response = await repository.cancelLaundryOrder(event.orderId);
      emit(CancelLaundryOrderSuccess(response));
    } on ApiException catch (e) {
      emit(CancelLaundryOrderFailure(e.description ?? "Có lỗi xảy ra"));
    } catch (e) {
      emit(CancelLaundryOrderFailure(e.toString()));
    }
  }
}