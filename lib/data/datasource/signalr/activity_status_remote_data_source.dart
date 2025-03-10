import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_clean/core/format/formater.dart';
import 'package:home_clean/data/datasource/local/activity_status_local_data_source.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import 'package:home_clean/data/mappers/activity_status/activity_status_mapper.dart';
import 'package:home_clean/domain/entities/activity_status/activity_status.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../../core/base/base_signalR_response.dart';
import '../../../domain/entities/activity_status/order_activity_status.dart';
import '../../mappers/activity_status/order_activity_status_mapper.dart';
import '../../models/activity_status/activity_status_model.dart';
import '../../models/activity_status/order_activity_status_model.dart';

class ActivityStatusRemoteDataSource {
  late HubConnection homeCleanHubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final ActivityStatusLocalDataSource _localDataSource = ActivityStatusLocalDataSource();

  final StreamController<List<ActivityStatus>> _streamController = StreamController.broadcast();

  Stream<List<ActivityStatus>> get activityStream => _streamController.stream;

  ActivityStatusRemoteDataSource({
    required this.authLocalDataSource,
  });

  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> connectToHub() async {
    await _initHomeCleanHub();
    await _startSignalRConnection(homeCleanHubConnection, 'HomeClean');
  }

  Future<void> _initHomeCleanHub() async {
    homeCleanHubConnection = HubConnectionBuilder()
        .withUrl(
      'https://homeclean.onrender.com/homecleanhub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    homeCleanHubConnection.on('ReceiveNotificationToAll', (arguments) => _handleActivityStatus(arguments, 'HomeClean'));
    homeCleanHubConnection.on('ReceiveNotificationToUser', (arguments) => _handleActivityStatus(arguments, 'HomeClean'));
    homeCleanHubConnection.on('ReceiveNotificationToGroup', (arguments) => _handleActivityStatus(arguments, 'HomeClean'));
  }

  void _handleActivityStatus(Object? arguments, String source) async {
    try {
      if (arguments == null) {
        print('⚠️ Không thể xử lý thông báo từ $source: dữ liệu null');
        return;
      }

      // Chuyển đổi arguments thành List<dynamic>
      final List<dynamic>? rawList = (arguments is String)
          ? json.decode(arguments)
          : (arguments is List ? arguments : null);

      if (rawList == null || rawList.isEmpty) {
        print('⚠️ Không thể xử lý thông báo từ $source: dữ liệu không hợp lệ hoặc danh sách rỗng');
        return;
      }

      // Chuyển đổi danh sách dữ liệu thành danh sách OrderActivityStatus
      final orderActivityStatusList = rawList
          .map((item) {
        final parsedItem = (item is String) ? json.decode(item) : item;
        if (parsedItem is! Map<String, dynamic>) return null;

        final baseResponse = BaseSignalrResponse<OrderActivityStatusModel>.fromJson(
          parsedItem,
              (data) => OrderActivityStatusModel(
            orderId: data['OrderId']?.toString() ?? '',
            activityStatuses: (data['ActivityStatuses'] as List<dynamic>?)
                ?.map((statusItem) => ActivityStatusModel(
              activityId: statusItem['ActivityId']?.toString() ?? '',
              status: statusItem['Status']?.toString() ?? '',
            ))
                .toList() ??
                [],
          ),
        );

        return (baseResponse.type == 'ActivityStatusInOrder' &&
            baseResponse.data.orderId.isNotEmpty &&
            baseResponse.data.activityStatuses.isNotEmpty)
            ? OrderActivityStatusMapper.toEntity(baseResponse.data)
            : null;
      })
          .whereType<OrderActivityStatus>() // Lọc bỏ giá trị null
          .toList();

      if (orderActivityStatusList.isEmpty) {
        print('⚠️ Không có dữ liệu hợp lệ để xử lý từ $source');
        return;
      }

      // Gom tất cả activityStatuses trước khi lưu vào DB
      final allActivityStatuses = orderActivityStatusList.expand((e) => e.activityStatuses).toList();
      await _localDataSource.addActivityStatuses(allActivityStatuses);

      // Lấy danh sách cập nhật từ local và phát qua stream
      final updatedList = await _localDataSource.getActivityStatus();
      _streamController.add(updatedList.map(ActivityStatusMapper.toEntity).toList());

      print('✅ Dữ liệu trạng thái hoạt động đã được cập nhật thành công từ $source');
    } catch (e) {
      print('❌ Lỗi xử lý thông báo từ $source: $e');
    }
  }



  Future<void> _startSignalRConnection(HubConnection connection, String sourceName) async {
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
      await Future.delayed(Duration(seconds: 5));
      await _startSignalRConnection(connection, sourceName);
    }
  }

  Future<void> disconnectFromHub() async {
    if (homeCleanHubConnection.state == HubConnectionState.Connecting) {
      await Future.delayed(Duration(seconds: 2));
    }

    if (homeCleanHubConnection.state == HubConnectionState.Connected) {
      await homeCleanHubConnection.stop();
      print('🔌 Đã ngắt kết nối từ HomeClean hub');
    }
    _streamController.close();
  }

  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

  Future<List<ActivityStatus>> fetchNotifications() async {
    await Future.delayed(Duration(seconds: 1));
    return await getActivityStatuses();
  }

  Future<List<ActivityStatus>> getActivityStatuses() async {
    return (await _localDataSource.getActivityStatus())
        .map((e) => ActivityStatusMapper.toEntity(e))
        .toList();
  }
}
