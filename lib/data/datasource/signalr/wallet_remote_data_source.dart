import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:home_clean/core/format/formater.dart';
import 'package:home_clean/data/datasource/local/auth_local_datasource.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

import '../../mappers/wallet/invite_wallet_mapper.dart';
import '../../models/notification/notification_model.dart';
import '../../service/notification_service.dart';

class WalletRemoteDataSource {
  late HubConnection vinWalletHubConnection;
  final AuthLocalDataSource authLocalDataSource;
  final StreamController<NotificationModel> _walletNotificationController = StreamController<NotificationModel>.broadcast();

  Stream<NotificationModel> get notificationStream => _walletNotificationController.stream;

  WalletRemoteDataSource({
    required this.authLocalDataSource,
  });

  Future<bool> hasNetworkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> connectToHub() async {
    await _initVinWalletHub();
    await _startSignalRConnection(vinWalletHubConnection, 'VinWallet');
  }

  Future<void> _initVinWalletHub() async {
    vinWalletHubConnection = HubConnectionBuilder()
        .withUrl(
      'https://vinwallet.vinhomesresident.com/vinWalletHub',
      options: HttpConnectionOptions(
        accessTokenFactory: () async => await _getAccessToken(),
      ),
    )
        .withAutomaticReconnect()
        .build();

    vinWalletHubConnection.on('ReceiveNotificationToAll', (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
    vinWalletHubConnection.on('ReceiveNotificationToUser', (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
    vinWalletHubConnection.on('ReceiveNotificationToGroup', (arguments) => _handleInviteWalletNotification(arguments, 'VinWallet'));
  }

  void _handleInviteWalletNotification(Object? arguments, String source) {
    final normalizedData = InviteWalletMapper.normalizeInviteWalletData(arguments);

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
    NotificationService.showNotification(title: "Ví", body: message);
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
    if (vinWalletHubConnection.state == HubConnectionState.Connected) {
      await vinWalletHubConnection.stop();
      print('🔌 Đã ngắt kết nối từ VinWallet hub');
    }
  }

  Future<String> _getAccessToken() async {
    String? currentToken = await authLocalDataSource.getAccessTokenFromStorage();
    return currentToken ?? '';
  }

}