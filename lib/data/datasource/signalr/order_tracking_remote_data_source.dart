import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../../domain/entities/order/order_tracking.dart';
import '../../service/notification_service.dart';
import '../local/auth_local_datasource.dart';
import '../local/order_tracking_data_source.dart';

class OrderTrackingRemoteDataSource {
  late HubConnection _orderTrackingHubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final OrderTrackingLocalDataSource orderTrackingLocalDataSource;

  final StreamController<OrderTracking> _orderTrackingNotificationController =
  StreamController<OrderTracking>.broadcast();

  final StreamController<SendOrderToStaff>
  _cleaningOrderNotificationController =
  StreamController<SendOrderToStaff>.broadcast();

  Stream<OrderTracking> get notificationStream =>
      _orderTrackingNotificationController.stream;

  Stream<SendOrderToStaff> get notificationOrderStream =>
      _cleaningOrderNotificationController.stream;

  OrderTrackingRemoteDataSource({
    required this.authLocalDataSource,
    required this.orderTrackingLocalDataSource,
  });

  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> connectToHub() async {
    await _initOrderTrackingHub();
    await _startSignalRConnection(_orderTrackingHubConnection, 'OrderTracking');
    await _startSignalRConnection(_orderTrackingHubConnection, 'SendOrderToStaff');
  }

  Future<void> _initOrderTrackingHub() async {
    _orderTrackingHubConnection = HubConnectionBuilder()
        .withUrl(
      'https://homeclean.vinhomesresident.com/homeCleanHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    _orderTrackingHubConnection.on('ReceiveNotificationToAll',
            (arguments) => _handleOrderTrackingNotification(arguments, 'All'));
    _orderTrackingHubConnection.on('ReceiveNotificationToUser',
            (arguments) => _handleOrderTrackingNotification(arguments, 'User'));
    _orderTrackingHubConnection.on('ReceiveNotificationToGroup',
            (arguments) => _handleOrderTrackingNotification(arguments, 'Group'));
  }

  Future<void> _handleOrderTrackingNotification(
      Object? arguments, String source) async {
    if (arguments == null) return;

    try {
      Map<String, dynamic> jsonData;

      if (arguments is String) {
        jsonData = json.decode(arguments);
      } else if (arguments is List && arguments.isNotEmpty) {
        var firstItem = arguments.first;
        if (firstItem is Map<String, dynamic>) {
          jsonData = firstItem;
        } else if (firstItem is String) {
          jsonData = json.decode(firstItem);
        } else {
          return;
        }
      } else if (arguments is Map) {
        jsonData = Map<String, dynamic>.from(arguments);
      } else {
        return;
      }

      if (jsonData.containsKey('Type') && jsonData.containsKey('Data')) {
        final type = jsonData['Type'];
        final data = jsonData['Data'];

        if (type == 'OrderTracking' && data is Map<String, dynamic>) {
          final orderTracking = OrderTracking.fromJsonSignalR(data);
          await orderTrackingLocalDataSource.saveOrderTracking(orderTracking);
          _orderTrackingNotificationController.add(orderTracking);
        }

        if (type == 'SendOrderToStaff' && data is Map<String, dynamic>) {
          final sendOrderToStaff = SendOrderToStaff.fromJson(data);
          _cleaningOrderNotificationController.add(sendOrderToStaff);

          NotificationService.showNotification(
            title: "Theo dõi đơn hàng",
            body:
            "Đơn hàng ${sendOrderToStaff.code} đã được cập nhật thành trạng thái ${sendOrderToStaff.status}",
          );
        }
      }
    } catch (e, stackTrace) {
      // Consider logging this error in a proper logging system
    }
  }

  Future<void> _startSignalRConnection(
      HubConnection connection, String sourceName) async {
    if (connection.state == HubConnectionState.Connected ||
        connection.state == HubConnectionState.Connecting) {
      return;
    }

    try {
      await connection.start();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      await _startSignalRConnection(connection, sourceName);
    }
  }

  Future<void> disconnectFromHub() async {
    if (_orderTrackingHubConnection.state == HubConnectionState.Connected) {
      await _orderTrackingHubConnection.stop();
    }
  }

  Future<String> _getAccessToken() async {
    String? currentToken =
    await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  void dispose() {
    _orderTrackingNotificationController.close();
    _cleaningOrderNotificationController.close();
  }
}

class SendOrderToStaff {
  final String id;
  final String? code;
  final String? note;
  final double? totalAmount;
  final String? status;

  SendOrderToStaff({
    required this.id,
    this.code,
    this.note,
    this.totalAmount,
    this.status,
  });

  factory SendOrderToStaff.fromJson(Map<String, dynamic> json) {
    return SendOrderToStaff(
      id: json['Id'] as String,
      code: json['Code'],
      note: json['Note'],
      totalAmount: (json['TotalAmount'] as num?)?.toDouble(),
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Code': code,
      'Note': note,
      'TotalAmount': totalAmount,
      'Status': status,
    };
  }
}