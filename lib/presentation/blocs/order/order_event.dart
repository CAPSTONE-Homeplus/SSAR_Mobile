part of 'order_bloc.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final CreateOrder createOrder;

  CreateOrderEvent(this.createOrder);
}

class GetOrdersByUserEvent extends OrderEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetOrdersByUserEvent({this.search, this.orderBy, this.page, this.size});
}

class GetOrderEvent extends OrderEvent {
  final String orderId;

  GetOrderEvent(this.orderId);
}

class CancelOrder extends OrderEvent {
  final String orderId;
  final CancellationRequest cancellationRequest;

  CancelOrder(this.orderId, this.cancellationRequest);
}
