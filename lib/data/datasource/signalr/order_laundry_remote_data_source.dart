import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../../domain/entities/order/order_tracking.dart';
import '../local/auth_local_datasource.dart';
import '../local/order_tracking_data_source.dart';

class OrderLaundryRemoteDataSource {
  late HubConnection _laundryOrderHubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final StreamController<LaundryOrderToUser> _laundryOrderToUserNotificationController =
  StreamController<LaundryOrderToUser>.broadcast();

  /// Stream of order tracking notificationus
  Stream<LaundryOrderToUser> get notificationStream =>
      _laundryOrderToUserNotificationController.stream;

  OrderLaundryRemoteDataSource({
    required this.authLocalDataSource,
  });

  /// Check if there's an active network connection
  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Connect to the order tracking SignalR hub
  Future<void> connectToHub() async {
    await _initLaundryOrderHub();
    await _startSignalRConnection(_laundryOrderHubConnection, 'LaundryOrderToUser');
  }

  /// Initialize the SignalR hub for order tracking
  Future<void> _initLaundryOrderHub() async {
    _laundryOrderHubConnection = HubConnectionBuilder()
        .withUrl(
      'https://vinlaundry.vinhomesresident.com/vinLaundryHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    // Set up listeners for different notification types
    _laundryOrderHubConnection.on('ReceiveNotificationToAll',
            (arguments) => _handleOrderLaundryNotification(arguments, 'All'));
    _laundryOrderHubConnection.on('ReceiveNotificationToUser',
            (arguments) => _handleOrderLaundryNotification(arguments, 'User'));
    _laundryOrderHubConnection.on('ReceiveNotificationToGroup',
            (arguments) => _handleOrderLaundryNotification(arguments, 'Group'));
  }

  Future<void> _handleOrderLaundryNotification(Object? arguments, String source) async {
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
        if (type == 'LaundryOrderToUser') {
          final data = jsonData['Data'];
          if (data is Map<String, dynamic>) {
            final LaundryOrderToUser laundryOrderToUser = LaundryOrderToUser.fromJson(data);
            print('📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${laundryOrderToUser}');
            _laundryOrderToUserNotificationController.add(laundryOrderToUser);
          } else {
            print('⚠️ Dữ liệu Data không phải Map<String, dynamic>: ${data.runtimeType}');
          }
        } else {
          print('⚠️ Type không phải LaundryOrderToUser: $type');
        }
      } else {
        // Trường hợp không có wrapper, thử parse trực tiếp
        final LaundryOrderToUser laundryOrderToUser = LaundryOrderToUser.fromJson(jsonData);
        print('📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${laundryOrderToUser}');

        _laundryOrderToUserNotificationController.add(laundryOrderToUser);
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
    if (_laundryOrderHubConnection.state == HubConnectionState.Connected) {
      await _laundryOrderHubConnection.stop();
      print('🔌 Đã ngắt kết nối từ LaundryOrderToUser hub');
    }
  }

  /// Retrieve the access token for authentication
  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  /// Close the notification stream
  void dispose() {
    _laundryOrderToUserNotificationController.close();
  }
}


class LaundryOrderToUser {
  final String? id;
  final String? orderCode;
  final String? name;
  final double? totalAmount;
  final DateTime? orderDate;
  final String? status;

  const LaundryOrderToUser({
    this.id,
    this.orderCode,
    this.name,
    this.totalAmount,
    this.orderDate,
    this.status,
  });

  // Factory constructor for creating an instance from a map
  factory LaundryOrderToUser.fromJson(Map<String, dynamic> json) {
    return LaundryOrderToUser(
      id: json['Id'] as String?,
      orderCode: json['OrderCode'] as String?,
      name: json['Name'] as String?,
      totalAmount: json['TotalAmount'] is num
          ? (json['TotalAmount'] as num?)?.toDouble()
          : null,
      orderDate: json['OrderDate'] != null
          ? DateTime.tryParse(json['OrderDate'].toString())
          : null,
      status: json['Status'] as String?,
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'OrderCode': orderCode,
      'Name': name,
      'TotalAmount': totalAmount,
      'OrderDate': orderDate?.toIso8601String(),
      'Status': status,
    };
  }

  // Copy method for easy modification
  LaundryOrderToUser copyWith({
    String? id,
    String? orderCode,
    String? name,
    double? totalAmount,
    DateTime? orderDate,
    String? status,
  }) {
    return LaundryOrderToUser(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LaundryOrderToUser &&
        other.id == id &&
        other.orderCode == orderCode &&
        other.name == name &&
        other.totalAmount == totalAmount &&
        other.orderDate == orderDate &&
        other.status == status;
  }


  // ToString for debugging
  @override
  String toString() {
    return 'LaundryOrderToUser(id: $id, orderCode: $orderCode, name: $name, '
        'totalAmount: $totalAmount, orderDate: $orderDate, status: $status)';
  }
}