// order_tracking_event.dart
import 'package:equatable/equatable.dart';
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

class LoadOrderTrackings extends OrderTrackingEvent1 {}