import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/order/order_laundry.dart';
import 'package:home_clean/domain/entities/order/order_laundry_detail.dart';

/// Base abstract state for laundry order
abstract class LaundryOrderStateV2 extends Equatable {
  const LaundryOrderStateV2();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LaundryOrderInitialV2 extends LaundryOrderStateV2 {}

/// Loading state (used for both list and detail)
class LaundryOrderLoadingV2 extends LaundryOrderStateV2 {}

/// Loaded list of laundry orders
class LaundryOrderLoadedV2 extends LaundryOrderStateV2 {
  final List<OrderLaundry> orders;

  const LaundryOrderLoadedV2(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// Failed to load list or detail
class LaundryOrderFailureV2 extends LaundryOrderStateV2 {
  final String message;

  const LaundryOrderFailureV2(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading laundry order detail
class LaundryOrderDetailLoadingV2 extends LaundryOrderStateV2 {}

/// Loaded laundry order detail
class LaundryOrderDetailLoadedV2 extends LaundryOrderStateV2 {
  final OrderLaundryDetail detail;

  const LaundryOrderDetailLoadedV2(this.detail);

  @override
  List<Object?> get props => [detail];
}

/// Failed to load laundry order detail
class LaundryOrderDetailFailureV2 extends LaundryOrderStateV2 {
  final String message;

  const LaundryOrderDetailFailureV2(this.message);

  @override
  List<Object?> get props => [message];
}
