import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/usecases/order/create_orders.dart';
import '../../../domain/usecases/order/delete_order_from_local.dart';
import '../../../domain/usecases/order/get_order_from_local.dart';
import '../../../domain/usecases/order/save_order_to_local.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrders createOrder;
  final SaveOrderToLocal saveOrderToLocal;
  final GetOrderFromLocal getOrderFromLocal;
  final DeleteOrderFromLocal deleteOrderFromLocal;

  OrderBloc({
    required this.createOrder,
    required this.saveOrderToLocal,
    required this.getOrderFromLocal,
    required this.deleteOrderFromLocal,
  }) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<SaveOrderToLocalEvent>(_onSaveOrderToLocal);
    on<GetOrderFromLocalEvent>(_onGetOrderFromLocal);
    on<DeleteOrderFromLocalEvent>(_onDeleteOrderFromLocal);
  }

  void _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final response = await createOrder(event.createOrder);
      if (response is Order) {
        emit(OrderCreated(response));
      } else {
        emit(OrderError('An error occurred'));
      }
    } catch (e) {
      emit(OrderError('An error occurred: $e'));
    }
  }

  void _onSaveOrderToLocal(SaveOrderToLocalEvent event, Emitter<OrderState> emit) async {
    await saveOrderToLocal(event.createOrder);
    emit(OrderSavedToLocal());
  }

  void _onGetOrderFromLocal(GetOrderFromLocalEvent event, Emitter<OrderState> emit) async {
    final order = await getOrderFromLocal();
    if (order != null) {
      emit(OrderLoadedFromLocal(order));
    } else {
      emit(OrderError('No order found in local DB'));
    }
  }

  void _onDeleteOrderFromLocal(DeleteOrderFromLocalEvent event, Emitter<OrderState> emit) async {
    await deleteOrderFromLocal();
    emit(OrderDeletedFromLocal());
  }


}
