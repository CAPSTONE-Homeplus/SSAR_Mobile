part of 'order_bloc.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreated extends OrderState {
  final Orders order;

  OrderCreated(this.order);
}

class TemporaryOrder extends OrderState {
  final CreateOrder temporaryOrder;
  TemporaryOrder(this.temporaryOrder);
}

class OrderSavedToLocal extends OrderState {}

class OrderLoadedFromLocal extends OrderState {
  final Orders order;

  OrderLoadedFromLocal(this.order);
}

class OrderDeletedFromLocal extends OrderState {}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

class OrderException extends OrderState {
  final String message;

  OrderException(this.message);
}