// order_tracking_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/order/order_tracking.dart';
import '../../../data/datasource/signalr/order_tracking_remote_data_source.dart';

enum OrderTrackingHubStatus { disconnected, connecting, connected, error }

class OrderTrackingState1 extends Equatable {
  final OrderTrackingHubStatus hubStatus;
  final List<OrderTracking> orderTrackings;
  final List<SendOrderToStaff> sendOrderToStaffs;
  final String errorMessage;
  final bool isLoading;

  const OrderTrackingState1({
    this.hubStatus = OrderTrackingHubStatus.disconnected,
    this.orderTrackings = const [],
    this.sendOrderToStaffs = const [],
    this.errorMessage = '',
    this.isLoading = false,
  });

  OrderTrackingState1 copyWith({
    OrderTrackingHubStatus? hubStatus,
    List<OrderTracking>? orderTrackings,
    List<SendOrderToStaff>? sendOrderToStaffs,
    String? errorMessage,
    bool? isLoading,
  }) {
    return OrderTrackingState1(
      hubStatus: hubStatus ?? this.hubStatus,
      orderTrackings: orderTrackings ?? this.orderTrackings,
      sendOrderToStaffs: sendOrderToStaffs ?? this.sendOrderToStaffs,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    hubStatus,
    orderTrackings,
    sendOrderToStaffs,
    errorMessage,
    isLoading
  ];
}