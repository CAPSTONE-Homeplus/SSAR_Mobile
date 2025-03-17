import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/use_cases/order/get_order_by_user_use_case.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../../domain/entities/order/order.dart';
import '../../../core/exception/failure.dart';
import '../../../domain/use_cases/order/create_orders_use_case.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderByUserUseCase getOrderByUserUseCase;

  OrderBloc({required this.createOrderUseCase, required this.getOrderByUserUseCase}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrdersByUserEvent>(_onGetOrdersByUser);
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    final Either<Failure, Orders> result = await createOrderUseCase.execute(SaveOrderParams(createOrder: event.createOrder));

    result.fold(
          (failure) => emit(OrderError(failure.message)),
          (order) => emit(OrderCreated(order)),
    );
  }

  Future<void> _onGetOrdersByUser(GetOrdersByUserEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    final Either<Failure, BaseResponse<Orders>> result = await getOrderByUserUseCase.execute(event.search, event.orderBy, event.page, event.size);

    result.fold(
          (failure) => emit(OrderError(failure.message)),
          (orders) => emit(OrdersByUserLoaded(orders)),
    );
  }
}
