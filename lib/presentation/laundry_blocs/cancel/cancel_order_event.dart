// In laundry_order_event.dart
import 'package:equatable/equatable.dart';

abstract class CancelOrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Add this among your other events
class CancelLaundryOrderEvent extends CancelOrderEvent {
  final String orderId;

  CancelLaundryOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}