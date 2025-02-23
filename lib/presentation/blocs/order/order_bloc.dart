import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../../domain/entities/order/order.dart';
import '../../../core/exception/failure.dart';
import '../../../domain/use_cases/order/create_orders_usecase.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;

  OrderBloc({required this.createOrderUseCase}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    final Either<Failure, Orders> result = await createOrderUseCase(SaveOrderParams(createOrder: event.createOrder));

    result.fold(
          (failure) => emit(OrderError(failure.message)),
          (order) => emit(OrderCreated(order)),
    );
  }
}
