part of 'order_bloc.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreated extends OrderState {
  final Orders order;

  OrderCreated(this.order);
}

class OrdersByUserLoaded extends OrderState {
  final BaseResponse<Orders> orders;

  OrdersByUserLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

class OrderLoaded extends OrderState {
  final Orders order;

  OrderLoaded(this.order);
}

class OrderCancelled extends OrderState {
  final bool isCancelled;

  OrderCancelled(this.isCancelled);
}
