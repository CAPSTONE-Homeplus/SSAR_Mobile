import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_clean/core/format/formater.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/order/order_tracking.dart';
import '../../mappers/wallet/invite_wallet_mapper.dart';
import '../../models/notification/notification_model.dart';

class AppSignalrService {
  // Hub connections
  late HubConnection _vinWalletHubConnection;
  late HubConnection _orderTrackingHubConnection;
  late HubConnection _laundryOrderHubConnection;

  // Dependencies
  final AuthLocalDataSource _authLocalDataSource;

  // Stream controllers
  final StreamController<NotificationModel> _walletNotificationController =
      StreamController<NotificationModel>.broadcast();
  final StreamController<OrderTracking> _orderTrackingNotificationController =
      StreamController<OrderTracking>.broadcast();
  final StreamController<LaundryOrderToUser>
      _laundryOrderToUserNotificationController =
      StreamController<LaundryOrderToUser>.broadcast();

  // Public streams
  Stream<NotificationModel> get walletNotificationStream =>
      _walletNotificationController.stream;

  Stream<OrderTracking> get orderTrackingNotificationStream =>
      _orderTrackingNotificationController.stream;

  Stream<LaundryOrderToUser> get laundryOrderNotificationStream =>
      _laundryOrderToUserNotificationController.stream;

  // Singleton pattern
  static AppSignalrService? _instance;

  static AppSignalrService get instance => _instance!;

  static Future<AppSignalrService> init({
    required AuthLocalDataSource authLocalDataSource,
  }) async {
    if (_instance == null) {
      _instance = AppSignalrService._internal(
        authLocalDataSource: authLocalDataSource,
      );
      await _instance!.connectToAllHubs();
    }
    return _instance!;
  }

  AppSignalrService._internal({
    required AuthLocalDataSource authLocalDataSource,
  }) : _authLocalDataSource = authLocalDataSource;

  Future<void> connectToAllHubs() async {
    if (!await hasNetworkConnection()) {
      print('❌ Không có kết nối mạng, không thể kết nối với các hub');
      return;
    }

    try {
      await _initVinWalletHub();
      await _initOrderTrackingHub();
      await _initLaundryOrderHub();

      await Future.wait([
        _startSignalRConnection(_vinWalletHubConnection, 'VinWallet'),
        _startSignalRConnection(_orderTrackingHubConnection, 'OrderTracking'),
        _startSignalRConnection(_laundryOrderHubConnection, 'LaundryOrder'),
      ]);

      print('✅ Đã kết nối tất cả các hub SignalR thành công');
    } catch (e) {
      print('❌ Lỗi khi kết nối với các hub SignalR: $e');
    }
  }

  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // VinWallet Hub
  Future<void> _initVinWalletHub() async {
    _vinWalletHubConnection = HubConnectionBuilder()
        .withUrl(
          'https://vinwallet.vinhomesresident.com/vinWalletHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await _getAccessToken(),
          ),
        )
        .withAutomaticReconnect()
        .build();

    _vinWalletHubConnection.on('ReceiveNotificationToAll',
        (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
    _vinWalletHubConnection.on('ReceiveNotificationToUser',
        (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
    _vinWalletHubConnection.on('ReceiveNotificationToGroup',
        (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
  }

  void _handleInviteWalletNotification(Object? arguments, String source) {
    final normalizedData =
        InviteWalletMapper.normalizeInviteWalletData(arguments);

    if (normalizedData == null) {
      print('⚠️ Không thể xử lý thông báo từ $source: dữ liệu không hợp lệ');
      return;
    }

    String message = Formater.formatInviteWalletMessage(normalizedData);
    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: 'Giao dịch ví mời',
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      type: 'InviteWallet',
      payload: normalizedData,
    );

    print('📢 Nhận thông báo từ $source: $message');
    _walletNotificationController.add(notification);
  }

  // OrderTracking Hub
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
    if (arguments == null) {
      print('⚠️ Không nhận được dữ liệu theo dõi đơn hàng từ $source');
      return;
    }

    print('📝 Dữ liệu theo dõi đơn hàng thô nhận được: $arguments');

    try {
      Map<String, dynamic> jsonData = await _normalizeSignalRData(arguments);

      // Kiểm tra cấu trúc wrapper (có Type và Data không)
      if (jsonData.containsKey('Type') && jsonData.containsKey('Data')) {
        final type = jsonData['Type'];
        if (type == 'OrderTracking') {
          final data = jsonData['Data'];
          if (data is Map<String, dynamic>) {
            final OrderTracking orderTracking =
                OrderTracking.fromJsonSignalR(data);
            print(
                '📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${orderTracking.orderId}');
            _orderTrackingNotificationController.add(orderTracking);
          }
        }
      } else {
        // Trường hợp không có wrapper, thử parse trực tiếp
        final OrderTracking orderTracking = OrderTracking.fromJson(jsonData);
        print(
            '📢 Nhận thông báo theo dõi đơn hàng từ $source: Đơn hàng ${orderTracking.orderId}');
        _orderTrackingNotificationController.add(orderTracking);
      }
    } catch (e, stackTrace) {
      print('❌ Lỗi xử lý thông báo theo dõi đơn hàng: $e');
      print('❌ Stack trace: $stackTrace');
    }
  }

  // LaundryOrder Hub
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

    _laundryOrderHubConnection.on('ReceiveNotificationToAll',
        (arguments) => _handleOrderLaundryNotification(arguments, 'All'));
    _laundryOrderHubConnection.on('ReceiveNotificationToUser',
        (arguments) => _handleOrderLaundryNotification(arguments, 'User'));
    _laundryOrderHubConnection.on('ReceiveNotificationToGroup',
        (arguments) => _handleOrderLaundryNotification(arguments, 'Group'));
  }

  Future<void> _handleOrderLaundryNotification(
      Object? arguments, String source) async {
    if (arguments == null) {
      print('⚠️ Không nhận được dữ liệu đơn giặt sấy từ $source');
      return;
    }

    print('📝 Dữ liệu đơn giặt sấy thô nhận được: $arguments');

    try {
      Map<String, dynamic> jsonData = await _normalizeSignalRData(arguments);

      // Kiểm tra cấu trúc wrapper (có Type và Data không)
      if (jsonData.containsKey('Type') && jsonData.containsKey('Data')) {
        final type = jsonData['Type'];
        if (type == 'LaundryOrderToUser') {
          final data = jsonData['Data'];
          if (data is Map<String, dynamic>) {
            final laundryOrderToUser = LaundryOrderToUser.fromJson(data);
            print(
                '📢 Nhận thông báo đơn giặt sấy từ $source: ${laundryOrderToUser.orderCode}');

            _laundryOrderToUserNotificationController.add(laundryOrderToUser);
          }
        }
      } else {
        final laundryOrderToUser = LaundryOrderToUser.fromJson(jsonData);
        print(
            '📢 Nhận thông báo đơn giặt sấy từ $source: ${laundryOrderToUser.orderCode}');
        _laundryOrderToUserNotificationController.add(laundryOrderToUser);
      }
    } catch (e, stackTrace) {
      print('❌ Lỗi xử lý thông báo đơn giặt sấy: $e');
      print('❌ Stack trace: $stackTrace');
    }
  }

  // Common helper methods
  Future<Map<String, dynamic>> _normalizeSignalRData(Object? arguments) async {
    Map<String, dynamic> jsonData;

    // Trường hợp 1: Dữ liệu là chuỗi JSON
    if (arguments is String) {
      try {
        jsonData = json.decode(arguments);
      } catch (e) {
        print('❌ Lỗi khi parse chuỗi JSON: $e');
        throw Exception('Không thể parse chuỗi JSON');
      }
    }
    // Trường hợp 2: Dữ liệu là List
    else if (arguments is List && arguments.isNotEmpty) {
      var firstItem = arguments.first;
      if (firstItem is Map<String, dynamic>) {
        jsonData = firstItem;
      } else if (firstItem is String) {
        try {
          jsonData = json.decode(firstItem);
        } catch (e) {
          print('❌ Lỗi khi parse phần tử List: $e');
          throw Exception('Không thể parse phần tử List');
        }
      } else {
        throw Exception('Phần tử đầu tiên không phải Map hoặc String');
      }
    }
    // Trường hợp 3: Dữ liệu là Map
    else if (arguments is Map) {
      try {
        jsonData = Map<String, dynamic>.from(arguments);
      } catch (e) {
        print('❌ Lỗi khi chuyển đổi Map: $e');
        throw Exception('Không thể chuyển đổi Map');
      }
    }
    // Trường hợp khác không xử lý được
    else {
      throw Exception('Dữ liệu không phải String, List, hoặc Map');
    }

    return jsonData;
  }

  Future<void> _startSignalRConnection(
      HubConnection connection, String sourceName) async {
    if (connection.state == HubConnectionState.Connected ||
        connection.state == HubConnectionState.Connecting) {
      print(
          '🔄 SignalR $sourceName đã kết nối hoặc đang kết nối, không cần kết nối lại.');
      return;
    }

    try {
      await connection.start();
      print('✅ Kết nối SignalR $sourceName thành công');
    } catch (e) {
      print('❌ Lỗi kết nối SignalR $sourceName: $e');
      await Future.delayed(const Duration(seconds: 5));
      await _startSignalRConnection(connection, sourceName);
    }
  }

  Future<String> _getAccessToken() async {
    String? currentToken =
        await _authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  // Disconnect from all hubs
  Future<void> disconnectFromAllHubs() async {
    try {
      if (_vinWalletHubConnection.state == HubConnectionState.Connected) {
        await _vinWalletHubConnection.stop();
        print('🔌 Đã ngắt kết nối từ VinWallet hub');
      }

      if (_orderTrackingHubConnection.state == HubConnectionState.Connected) {
        await _orderTrackingHubConnection.stop();
        print('🔌 Đã ngắt kết nối từ OrderTracking hub');
      }

      if (_laundryOrderHubConnection.state == HubConnectionState.Connected) {
        await _laundryOrderHubConnection.stop();
        print('🔌 Đã ngắt kết nối từ LaundryOrder hub');
      }

      print('✅ Đã ngắt kết nối tất cả các hub SignalR thành công');
    } catch (e) {
      print('❌ Lỗi khi ngắt kết nối với các hub SignalR: $e');
    }
  }

  // Dispose all resources
  void dispose() {
    disconnectFromAllHubs();
    _walletNotificationController.close();
    _orderTrackingNotificationController.close();
    _laundryOrderToUserNotificationController.close();
    print('🧹 Đã giải phóng tất cả tài nguyên của AppSignalrService');
  }
}

// LaundryOrderToUser entity
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

  @override
  int get hashCode {
    return id.hashCode ^
        orderCode.hashCode ^
        name.hashCode ^
        totalAmount.hashCode ^
        orderDate.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'LaundryOrderToUser(id: $id, orderCode: $orderCode, name: $name, '
        'totalAmount: $totalAmount, orderDate: $orderDate, status: $status)';
  }
}
