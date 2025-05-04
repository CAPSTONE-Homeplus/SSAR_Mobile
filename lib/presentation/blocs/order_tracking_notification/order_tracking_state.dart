// order_tracking_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/order_tracking.dart';

enum OrderTrackingHubStatus { disconnected, connecting, connected, error }

class OrderTrackingState1 extends Equatable {
  final OrderTrackingHubStatus hubStatus;
  final List<OrderTracking> orderTrackings;
  final String errorMessage;
  final bool isLoading;

  const OrderTrackingState1({
    this.hubStatus = OrderTrackingHubStatus.disconnected,
    this.orderTrackings = const [],
    this.errorMessage = '',
    this.isLoading = false,
  });

  OrderTrackingState1 copyWith({
    OrderTrackingHubStatus? hubStatus,
    List<OrderTracking>? orderTrackings,
    String? errorMessage,
    bool? isLoading,
  }) {
    return OrderTrackingState1(
      hubStatus: hubStatus ?? this.hubStatus,
      orderTrackings: orderTrackings ?? this.orderTrackings,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [hubStatus, orderTrackings, errorMessage, isLoading];
}