
import 'package:dartz/dartz.dart';

import '../../core/exception/failure.dart';
import '../../data/datasource/signalr/order_tracking_remote_data_source.dart';
import '../entities/order/order_tracking.dart';

abstract class OrderTrackingRepository {
  Stream<OrderTracking> get orderTrackingStream;
  Stream<SendOrderToStaff> get sendOrderToStaffStream;
  Future<Either<Failure, bool>> connectToOrderTrackingHub();
  Future<Either<Failure, bool>> disconnectFromOrderTrackingHub();
  Future<Either<Failure, List<OrderTracking>>> getLocalOrderTrackings();
  Future<Either<Failure, OrderTracking>> getOrderTrackingById(String orderId);
  void dispose();
}