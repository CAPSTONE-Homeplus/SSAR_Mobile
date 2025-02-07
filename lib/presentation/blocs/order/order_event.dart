part of 'order_bloc.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final CreateOrder createOrder;

  CreateOrderEvent(this.createOrder);
}

class SaveTemporaryOrderEvent extends OrderEvent {
  final CreateOrder createOrder;
  SaveTemporaryOrderEvent(this.createOrder);
}

class UpdateTemporaryOrderEvent extends OrderEvent {
  final CreateOrder updatedOrder;

  UpdateTemporaryOrderEvent(this.updatedOrder);
}


class SaveOrderToLocalEvent extends OrderEvent {
  final CreateOrder createOrder;

  SaveOrderToLocalEvent(this.createOrder);
}

class GetOrderFromLocalEvent extends OrderEvent {}

class DeleteOrderFromLocalEvent extends OrderEvent {}