
import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/exception/failure.dart';
import '../../core/request/request.dart';
import '../../domain/entities/order/order_tracking.dart';
import '../../domain/repositories/order_tracking_repository.dart';
import '../datasource/local/order_tracking_data_source.dart';
import '../datasource/signalr/order_tracking_remote_data_source.dart';

class OrderTrackingRepositoryImpl implements OrderTrackingRepository {
  final OrderTrackingRemoteDataSource remoteDataSource;
  final OrderTrackingLocalDataSource localDataSource;
  final StreamController<OrderTracking> _orderTrackingController =
  StreamController<OrderTracking>.broadcast();

  OrderTrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  }) {
    remoteDataSource.notificationStream.listen((orderTracking) {
      _orderTrackingController.add(orderTracking);
    });
  }

  @override
  Stream<OrderTracking> get orderTrackingStream => _orderTrackingController.stream;

  @override
  Future<Either<Failure, bool>> connectToOrderTrackingHub() async {
    try {
      final hasNetwork = await remoteDataSource.hasNetworkConnection();

      if (!hasNetwork) {
        return Left(NetworkFailure("Không có kết nối mạng"));
      }

      await remoteDataSource.connectToHub();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure("Lỗi kết nối đến máy chủ: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> disconnectFromOrderTrackingHub() async {
    try {
      await remoteDataSource.disconnectFromHub();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure("Lỗi kết nối đến máy chủ: ${e.toString()}"));
    }
  }


  @override
  Future<Either<Failure, List<OrderTracking>>> getLocalOrderTrackings() async {
    try {
      final orderTrackings = await localDataSource.getAllOrderTrackings();
      return Right(orderTrackings);
    } catch (e) {
      return Left(CacheFailure("Lỗi lấy dữ liệu từ cache: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, OrderTracking>> getOrderTrackingById(String orderId) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.orders}/$orderId/tracking',
          queryParameters: {
            'id': orderId,
          });

      if (response.statusCode == 200 && response.data != null) {
        return Right(OrderTracking.fromJson(response.data));
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  void dispose() {
    _orderTrackingController.close();
    remoteDataSource.dispose();
  }
}