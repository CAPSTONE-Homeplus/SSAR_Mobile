import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/signalr/order_laundry_remote_data_source.dart';
import 'laundry_order_event1.dart';
import 'laundry_order_state1.dart';

class LaundryOrderBloc1 extends Bloc<LaundryOrderEvent1, LaundryOrderState1> {
  final OrderLaundryRemoteDataSource _remoteDataSource;
  StreamSubscription? _notificationSubscription;

  LaundryOrderBloc1(this._remoteDataSource) : super(LaundryOrderInitial1()) {
    on<ConnectToLaundryOrderHub1>(_onConnectToHub);
    on<DisconnectFromLaundryOrderHub1>(_onDisconnectFromHub);
    on<ReceiveLaundryOrderNotification1>(_onReceiveNotification);
    _setupNotificationListener();
  }

  void _setupNotificationListener() {
    _notificationSubscription?.cancel();

    _notificationSubscription = _remoteDataSource.notificationStream.listen(
          (orderNotification) {
        add(ReceiveLaundryOrderNotification1(orderNotification));
      },
      onError: (error) {
        print('Error receiving notification: $error');
      },
    );
  }


  Future<void> _onConnectToHub(
      ConnectToLaundryOrderHub1 event,
      Emitter<LaundryOrderState1> emit,
      ) async {
    try {
      emit(LaundryOrderHubConnecting1());
      final hasConnection = await _remoteDataSource.hasNetworkConnection();
      if (!hasConnection) {
        emit(LaundryOrderError1('No network connection'));
        return;
      }
      await _remoteDataSource.connectToHub();
      _setupNotificationListener();
      emit(LaundryOrderHubConnected1());
    } catch (e) {
      emit(LaundryOrderError1('Failed to connect to hub: ${e.toString()}'));
    }
  }


  Future<void> _onDisconnectFromHub(
      DisconnectFromLaundryOrderHub1 event,
      Emitter<LaundryOrderState1> emit
      ) async {
    try {
      await _remoteDataSource.disconnectFromHub();
      emit(LaundryOrderHubDisconnected1());
    } catch (e) {
      emit(LaundryOrderError1('Failed to disconnect from hub: ${e.toString()}'));
    }
  }

  void _onReceiveNotification(
      ReceiveLaundryOrderNotification1 event,
      Emitter<LaundryOrderState1> emit
      ) {
    emit(LaundryOrderNotificationReceived1(event.orderNotification));
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    _remoteDataSource.dispose();
    return super.close();
  }
}