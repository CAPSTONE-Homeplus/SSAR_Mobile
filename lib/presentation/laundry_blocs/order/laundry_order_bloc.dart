import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../data/laundry_repositories/laundry_order_repo.dart';
import 'laundry_order_event.dart';
import 'laundry_order_state.dart';

class LaundryOrderBloc extends Bloc<LaundryOrderEvent, LaundryOrderState> {
  final LaundryOrderRepository repository; // Inject Repository

  LaundryOrderBloc(this.repository) : super(LaundryOrderInitial()) {
    on<CreateLaundryOrderEvent>(_onCreateLaundryOrder);
    on<GetLaundryOrderEvent>(_onGetLaundryOrder);
  }

  Future<void> _onCreateLaundryOrder(
    CreateLaundryOrderEvent event,
    Emitter<LaundryOrderState> emit,
  ) async {
    emit(LaundryOrderLoading());
    try {
      final response = await repository.createLaundryOrder(event.requestData);
      emit(CreateLaundrySuccess(response));
    } catch (e) {
      emit(LaundryOrderFailure(e.toString()));
    }
  }

  Future<void> _onGetLaundryOrder(
    GetLaundryOrderEvent event,
    Emitter<LaundryOrderState> emit,
  ) async {
    emit(LaundryOrderLoading());
    try {
      final response = await repository.getLaundryOrder(event.orderId);
      emit(GetLaundrySuccess(response));
    } catch (e) {
      emit(LaundryOrderFailure(e.toString()));
    }
  }
}
