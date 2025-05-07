import 'package:equatable/equatable.dart';

/// Base abstract event
abstract class LaundryOrderEventV2 extends Equatable {
  const LaundryOrderEventV2();

  @override
  List<Object?> get props => [];
}

/// Event: Fetch list of laundry orders by user ID
class GetLaundryOrdersV2 extends LaundryOrderEventV2 {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  const GetLaundryOrdersV2({
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [search, orderBy, page, size];
}

/// Event: Fetch laundry order detail by order ID
class GetLaundryOrderDetailV2 extends LaundryOrderEventV2 {
  final String orderId;

  const GetLaundryOrderDetailV2(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
