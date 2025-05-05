import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/local/order_tracking_data_source.dart';
import '../../../data/datasource/signalr/order_tracking_remote_data_source.dart';
import '../../../domain/entities/order/order_tracking.dart';
import 'order_tracking_event.dart';
import 'order_tracking_state.dart';

class OrderTrackingBloc1 extends Bloc<OrderTrackingEvent1, OrderTrackingState1> {
  final OrderTrackingRemoteDataSource _remoteDataSource;
  final OrderTrackingLocalDataSource _localDataSource;
  StreamSubscription<OrderTracking>? _orderTrackingSubscription;
  StreamSubscription<SendOrderToStaff>? _sendOrderToStaffSubscription;

  OrderTrackingBloc1({
    required OrderTrackingRemoteDataSource remoteDataSource,
    required OrderTrackingLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        super(const OrderTrackingState1()) {
    on<ConnectToOrderTrackingHub>(_onConnectToOrderTrackingHub);
    on<DisconnectFromOrderTrackingHub>(_onDisconnectFromOrderTrackingHub);
    on<OrderTrackingReceived>(_onOrderTrackingReceived);
    on<LoadOrderTrackings>(_onLoadOrderTrackings);
    on<OrderDetailReceived>(_onOrderDetailReceived);


    _registerOrderTrackingListener();
  }

  void _registerOrderTrackingListener() {
    _orderTrackingSubscription?.cancel();
    _sendOrderToStaffSubscription?.cancel();

    _orderTrackingSubscription = _remoteDataSource.notificationStream.listen(
          (orderTracking) => add(OrderTrackingReceived(orderTracking)),
    );

    _sendOrderToStaffSubscription = _remoteDataSource.notificationOrderStream.listen(
          (sendOrderToStaff) => add(OrderDetailReceived(sendOrderToStaff)),
    );
  }

  Future<void> _onConnectToOrderTrackingHub(
      ConnectToOrderTrackingHub event,
      Emitter<OrderTrackingState1> emit,
      ) async {
    if (state.hubStatus == OrderTrackingHubStatus.connected ||
        state.hubStatus == OrderTrackingHubStatus.connecting) {
      return;
    }

    emit(state.copyWith(hubStatus: OrderTrackingHubStatus.connecting));

    try {
      final hasNetwork = await _remoteDataSource.hasNetworkConnection();
      if (!hasNetwork) {
        emit(state.copyWith(
          hubStatus: OrderTrackingHubStatus.error,
          errorMessage: 'Không có kết nối mạng. Vui lòng kiểm tra kết nối của bạn.',
        ));
        return;
      }

      await _remoteDataSource.connectToHub();
      emit(state.copyWith(hubStatus: OrderTrackingHubStatus.connected));

      add(LoadOrderTrackings());
    } catch (e) {
      emit(state.copyWith(
        hubStatus: OrderTrackingHubStatus.error,
        errorMessage: 'Không thể kết nối đến máy chủ theo dõi đơn hàng: ${e.toString()}',
      ));
    }
  }

  Future<void> _onDisconnectFromOrderTrackingHub(
      DisconnectFromOrderTrackingHub event,
      Emitter<OrderTrackingState1> emit,
      ) async {
    if (state.hubStatus != OrderTrackingHubStatus.connected) {
      return;
    }

    try {
      await _remoteDataSource.disconnectFromHub();
      emit(state.copyWith(hubStatus: OrderTrackingHubStatus.disconnected));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi khi ngắt kết nối: ${e.toString()}'));
    }
  }

  Future<void> _onOrderTrackingReceived(
      OrderTrackingReceived event,
      Emitter<OrderTrackingState1> emit,
      ) async {
    final orderTracking = event.orderTracking;
    final existingIndex = state.orderTrackings.indexWhere((o) => o.orderId == orderTracking.orderId);
    List<OrderTracking> updatedTrackings = List.from(state.orderTrackings);

    if (existingIndex >= 0) {
      updatedTrackings[existingIndex] = orderTracking;
    } else {
      updatedTrackings.insert(0, orderTracking);
    }

    emit(state.copyWith(orderTrackings: updatedTrackings));
  }

  Future<void> _onLoadOrderTrackings(
      LoadOrderTrackings event,
      Emitter<OrderTrackingState1> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final savedTrackings = await _localDataSource.getAllOrderTrackings();
      emit(state.copyWith(orderTrackings: savedTrackings, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Không thể tải dữ liệu theo dõi đơn hàng: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  Future<void> _onOrderDetailReceived(
      OrderDetailReceived event,
      Emitter<OrderTrackingState1> emit,
      ) async {
    final existingIndex = state.sendOrderToStaffs.indexWhere(
            (o) => o.id == event.sendOrderToStaff.id
    );

    List<SendOrderToStaff> updatedSendOrderToStaffs =
    List.from(state.sendOrderToStaffs);

    if (existingIndex >= 0) {
      updatedSendOrderToStaffs[existingIndex] = event.sendOrderToStaff;
    } else {
      updatedSendOrderToStaffs.insert(0, event.sendOrderToStaff);
    }

    emit(state.copyWith(
        sendOrderToStaffs: updatedSendOrderToStaffs
    ));
  }

  @override
  Future<void> close() {
    _orderTrackingSubscription?.cancel();
    _sendOrderToStaffSubscription?.cancel();
    _remoteDataSource.dispose();
    return super.close();
  }
}
