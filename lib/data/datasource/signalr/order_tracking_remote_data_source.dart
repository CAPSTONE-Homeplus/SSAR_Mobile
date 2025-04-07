import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../../domain/entities/order/order_tracking.dart';
import '../local/auth_local_datasource.dart';
import '../local/order_tracking_data_source.dart';

class OrderTrackingRemoteDataSource {
  late HubConnection _orderTrackingHubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final OrderTrackingLocalDataSource orderTrackingLocalDataSource;
  final StreamController<OrderTracking> _orderTrackingNotificationController =
  StreamController<OrderTracking>.broadcast();

  /// Stream of order tracking notifications
  Stream<OrderTracking> get notificationStream =>
      _orderTrackingNotificationController.stream;

  OrderTrackingRemoteDataSource({
    required this.authLocalDataSource,
    required this.orderTrackingLocalDataSource,
  });

  /// Check if there's an active network connection
  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Connect to the order tracking SignalR hub
  Future<void> connectToHub() async {
    await _initOrderTrackingHub();
    await _startSignalRConnection(_orderTrackingHubConnection, 'OrderTracking');
  }

  /// Initialize the SignalR hub for order tracking
  Future<void> _initOrderTrackingHub() async {
    _orderTrackingHubConnection = HubConnectionBuilder()
        .withUrl(
      'https://homeclean-2z89.onrender.com/homeCleanHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    // Set up listeners for different notification types
    _orderTrackingHubConnection.on('ReceiveNotificationToAll',
            (arguments) => _handleOrderTrackingNotification(arguments, 'All'));
    _orderTrackingHubConnection.on('ReceiveNotificationToUser',
            (arguments) => _handleOrderTrackingNotification(arguments, 'User'));
    _orderTrackingHubConnection.on('ReceiveNotificationToGroup',
            (arguments) => _handleOrderTrackingNotification(arguments, 'Group'));
  }

  Future<void> _handleOrderTrackingNotification(Object? arguments, String source) async {
    if (arguments == null) {
      print('⚠️ Không nhận được dữ liệu theo dõi đơn hàng từ $source');
      return;
    }

    print('📝 Dữ liệu thô nhận được (${arguments.runtimeType}): $arguments');

    try {
      Map<String, dynamic> jsonData;

      // Trường hợp 1: Dữ liệu là chuỗi JSON
      if (arguments is String) {
        print('🔄 Dữ liệu nhận được là String, đang parse từ JSON');
        try {
          jsonData = json.decode(arguments);
        } catch (e) {
          print('❌ Lỗi khi parse chuỗi JSON: $e');
          return;
        }
      }
      // Trường hợp 2: Dữ liệu là List
      else if (arguments is List && arguments.isNotEmpty) {
        print('🔄 Dữ liệu nhận được là List, lấy phần tử đầu tiên');
        var firstItem = arguments.first;
        if (firstItem is Map<String, dynamic>) {
          jsonData = firstItem;
        } else if (firstItem is String) {
          try {
            jsonData = json.decode(firstItem);
          } catch (e) {
            print('❌ Lỗi khi parse phần tử List: $e');
            return;
          }
        } else {
          print('⚠️ Phần tử đầu tiên không phải Map hoặc String: ${firstItem.runtimeType}');
          return;
        }
      }
      // Trường hợp 3: Dữ liệu là Map
      else if (arguments is Map) {
        try {
          jsonData = Map<String, dynamic>.from(arguments);
        } catch (e) {
          print('❌ Lỗi khi chuyển đổi Map: $e');
          return;
        }
      }
      // Trường hợp khác không xử lý được
      else {
        print('⚠️ Dữ liệu không phải String, List, hoặc Map: ${arguments.runtimeType}');
        return;
      }

      print('🔍 Dữ liệu sau khi chuyển đổi: $jsonData');

      // Kiểm tra cấu trúc wrapper (có Type và Data không)
      if (jsonData.containsKey('Type') && jsonData.containsKey('Data')) {
        final type = jsonData['Type'];
        if (type == 'OrderTracking') {
          final data = jsonData['Data'];
          if (data is Map<String, dynamic>) {
            final OrderTracking orderTracking = OrderTracking.fromJsonSignalR(data);
            print('📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${orderTracking.orderId}');

            await orderTrackingLocalDataSource.saveOrderTracking(orderTracking);
            _orderTrackingNotificationController.add(orderTracking);
          } else {
            print('⚠️ Dữ liệu Data không phải Map<String, dynamic>: ${data.runtimeType}');
          }
        } else {
          print('⚠️ Type không phải OrderTracking: $type');
        }
      } else {
        // Trường hợp không có wrapper, thử parse trực tiếp
        final OrderTracking orderTracking = OrderTracking.fromJson(jsonData);
        print('📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${orderTracking.orderId}');

        await orderTrackingLocalDataSource.saveOrderTracking(orderTracking);
        _orderTrackingNotificationController.add(orderTracking);
      }
    } catch (e, stackTrace) {
      print('❌ Lỗi xử lý thông báo theo dõi đơn hàng: $e');
      print('❌ Stack trace: $stackTrace');
      print('❌ Chi tiết dữ liệu lỗi: $arguments');
    }
  }

  /// Start the SignalR connection with retry logic
  Future<void> _startSignalRConnection(
      HubConnection connection,
      String sourceName
      ) async {
    // Check if already connected or connecting
    if (connection.state == HubConnectionState.Connected ||
        connection.state == HubConnectionState.Connecting) {
      print('🔄 SignalR $sourceName đã kết nối hoặc đang kết nối, không cần kết nối lại.');
      return;
    }

    try {
      await connection.start();
      print('✅ Kết nối SignalR $sourceName thành công');
    } catch (e) {
      print('❌ Lỗi kết nối SignalR $sourceName: $e');

      // Wait and retry
      await Future.delayed(const Duration(seconds: 5));
      await _startSignalRConnection(connection, sourceName);
    }
  }

  /// Disconnect from the order tracking hub
  Future<void> disconnectFromHub() async {
    if (_orderTrackingHubConnection.state == HubConnectionState.Connected) {
      await _orderTrackingHubConnection.stop();
      print('🔌 Đã ngắt kết nối từ OrderTracking hub');
    }
  }

  /// Retrieve the access token for authentication
  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  /// Close the notification stream
  void dispose() {
    _orderTrackingNotificationController.close();
  }
}