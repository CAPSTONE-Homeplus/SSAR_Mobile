import 'package:equatable/equatable.dart';

import '../../../domain/entities/order/order_tracking.dart';

abstract class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object> get props => [];
}

class OrderTrackingInitial extends OrderTrackingState {}

class OrderTrackingLoading extends OrderTrackingState {}

class HubConnected extends OrderTrackingState {}

class HubConnectionFailed extends OrderTrackingState {
  final String message;

  const HubConnectionFailed(this.message);

  @override
  List<Object> get props => [message];
}

class HubDisconnected extends OrderTrackingState {}

class TrackingsLoaded extends OrderTrackingState {
  final List<OrderTracking> trackings;

  const TrackingsLoaded(this.trackings);

  @override
  List<Object> get props => [trackings];
}

class OrderTrackingLoaded extends OrderTrackingState {
  final OrderTracking tracking;

  const OrderTrackingLoaded(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class OrderTrackingUpdated extends OrderTrackingState {
  final OrderTracking tracking;

  const OrderTrackingUpdated(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError(this.message);

  @override
  List<Object> get props => [message];
}