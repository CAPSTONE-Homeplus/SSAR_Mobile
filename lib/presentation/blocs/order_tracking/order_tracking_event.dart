import 'package:equatable/equatable.dart';

import '../../../domain/entities/order/order_tracking.dart';

abstract class OrderTrackingEvent extends Equatable {
  const OrderTrackingEvent();

  @override
  List<Object> get props => [];
}

class ConnectToHubEvent extends OrderTrackingEvent {}

class DisconnectFromHubEvent extends OrderTrackingEvent {}

class LoadLocalTrackingsEvent extends OrderTrackingEvent {}

class GetOrderTrackingByIdEvent extends OrderTrackingEvent {
  final String orderId;

  const GetOrderTrackingByIdEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class NewTrackingReceivedEvent extends OrderTrackingEvent {
  final OrderTracking orderTracking;

  const NewTrackingReceivedEvent(this.orderTracking);

  @override
  List<Object> get props => [orderTracking];
}