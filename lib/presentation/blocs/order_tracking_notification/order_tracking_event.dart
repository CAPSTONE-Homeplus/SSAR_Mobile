// order_tracking_event.dart
import 'package:equatable/equatable.dart';
import 'package:home_clean/data/datasource/signalr/order_tracking_remote_data_source.dart';
import '../../../domain/entities/order/order_tracking.dart';

abstract class OrderTrackingEvent1 extends Equatable {
  const OrderTrackingEvent1();

  @override
  List<Object?> get props => [];
}

class ConnectToOrderTrackingHub extends OrderTrackingEvent1 {}

class DisconnectFromOrderTrackingHub extends OrderTrackingEvent1 {}

class OrderTrackingReceived extends OrderTrackingEvent1 {
  final OrderTracking orderTracking;

  const OrderTrackingReceived(this.orderTracking);

  @override
  List<Object?> get props => [orderTracking];
}

class OrderDetailReceived extends OrderTrackingEvent1 {
  final SendOrderToStaff sendOrderToStaff;

  const OrderDetailReceived(this.sendOrderToStaff);

  @override
  List<Object> get props => [sendOrderToStaff];
}

class LoadOrderTrackings extends OrderTrackingEvent1 {}

class OrderTrackingError extends OrderTrackingEvent1 {
  final String errorMessage;

  const OrderTrackingError(this.errorMessage);
}