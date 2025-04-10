import 'package:equatable/equatable.dart';

import '../../../data/datasource/signalr/order_laundry_remote_data_source.dart';

abstract class LaundryOrderEvent1 extends Equatable {
  const LaundryOrderEvent1();

  @override
  List<Object?> get props => [];
}

class ConnectToLaundryOrderHub1 extends LaundryOrderEvent1 {}

class DisconnectFromLaundryOrderHub1 extends LaundryOrderEvent1 {}

class ReceiveLaundryOrderNotification1 extends LaundryOrderEvent1 {
  final LaundryOrderToUser orderNotification;

  const ReceiveLaundryOrderNotification1(this.orderNotification);

  @override
  List<Object?> get props => [orderNotification];
}