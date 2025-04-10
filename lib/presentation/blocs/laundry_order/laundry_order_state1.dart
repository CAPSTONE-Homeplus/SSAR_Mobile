import 'package:equatable/equatable.dart';

import '../../../data/datasource/signalr/order_laundry_remote_data_source.dart';

abstract class LaundryOrderState1 extends Equatable {
  const LaundryOrderState1();

  @override
  List<Object?> get props => [];
}

class LaundryOrderInitial1 extends LaundryOrderState1 {}

class LaundryOrderHubConnecting1 extends LaundryOrderState1 {}

class LaundryOrderHubConnected1 extends LaundryOrderState1 {}

class LaundryOrderHubDisconnected1 extends LaundryOrderState1 {}

class LaundryOrderNotificationReceived1 extends LaundryOrderState1 {
  final LaundryOrderToUser orderNotification;

  const LaundryOrderNotificationReceived1(this.orderNotification);

  @override
  List<Object?> get props => [orderNotification];
}

class LaundryOrderError1 extends LaundryOrderState1 {
  final String errorMessage;

  const LaundryOrderError1(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
