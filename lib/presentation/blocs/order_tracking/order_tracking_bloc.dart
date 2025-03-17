import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/order/order_tracking.dart';
import '../../../domain/use_cases/order_tracking/connect_to_order_tracking_hub_use_case.dart';
import '../../../domain/use_cases/order_tracking/disconnect_from_order_tracking_hub_use_case.dart';
import '../../../domain/use_cases/order_tracking/get_all_order_trackings_use_case.dart';
import '../../../domain/use_cases/order_tracking/get_order-tracking_use_case.dart';
import '../../../domain/use_cases/order_tracking/stream_order_tracking_use_case.dart';
import 'order_tracking_event.dart';
import 'order_tracking_state.dart';

class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  final ConnectToOrderTrackingHubUseCase connectToHub;
  final DisconnectFromOrderTrackingHubUseCase disconnectFromHub;
  final GetLocalOrderTrackingsUseCase getLocalTrackings;
  final GetOrderTrackingByIdUseCase getTrackingById;
  final StreamOrderTrackingUseCase streamTracking;
  StreamSubscription<OrderTracking>? _trackingSubscription;

  OrderTrackingBloc({
    required this.connectToHub,
    required this.disconnectFromHub,
    required this.getLocalTrackings,
    required this.getTrackingById,
    required this.streamTracking,
  }) : super(OrderTrackingInitial()) {
    on<ConnectToHubEvent>(_onConnectToHub);
    on<DisconnectFromHubEvent>(_onDisconnectFromHub);
    on<LoadLocalTrackingsEvent>(_onLoadLocalTrackings);
    on<GetOrderTrackingByIdEvent>(_onGetOrderTrackingById);
    on<NewTrackingReceivedEvent>(_onNewTrackingReceived);

    // Subscribe to tracking updates
    _subscribeToTrackingUpdates();
  }

  void _subscribeToTrackingUpdates() {
    _trackingSubscription = streamTracking().listen((tracking) {
      add(NewTrackingReceivedEvent(tracking));
    });
  }

  Future<void> _onConnectToHub(
      ConnectToHubEvent event,
      Emitter<OrderTrackingState> emit,
      ) async {
    emit(OrderTrackingLoading());

    final result = await connectToHub();

    result.fold(
          (failure) => emit(HubConnectionFailed(failure.message)),
          (_) => emit(HubConnected()),
    );
  }

  Future<void> _onDisconnectFromHub(
      DisconnectFromHubEvent event,
      Emitter<OrderTrackingState> emit,
      ) async {
    emit(OrderTrackingLoading());

    final result = await disconnectFromHub();

    result.fold(
          (failure) => emit(OrderTrackingError(failure.message)),
          (_) => emit(HubDisconnected()),
    );
  }

  Future<void> _onLoadLocalTrackings(
      LoadLocalTrackingsEvent event,
      Emitter<OrderTrackingState> emit,
      ) async {
    emit(OrderTrackingLoading());

    final result = await getLocalTrackings();

    result.fold(
          (failure) => emit(OrderTrackingError(failure.message)),
          (trackings) => emit(TrackingsLoaded(trackings)),
    );
  }

  Future<void> _onGetOrderTrackingById(
      GetOrderTrackingByIdEvent event,
      Emitter<OrderTrackingState> emit,
      ) async {
    emit(OrderTrackingLoading());

    final result = await getTrackingById(event.orderId);

    result.fold(
          (failure) => emit(OrderTrackingError(failure.message)),
          (tracking) => emit(OrderTrackingLoaded(tracking)),
    );
  }

  void _onNewTrackingReceived(
      NewTrackingReceivedEvent event,
      Emitter<OrderTrackingState> emit,
      ) {
    emit(OrderTrackingUpdated(event.orderTracking));
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}