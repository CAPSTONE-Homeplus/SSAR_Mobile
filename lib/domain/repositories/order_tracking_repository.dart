
import 'package:dartz/dartz.dart';

import '../../core/exception/failure.dart';
import '../entities/order/order_tracking.dart';

abstract class OrderTrackingRepository {
  Stream<OrderTracking> get orderTrackingStream;
  Future<Either<Failure, bool>> connectToOrderTrackingHub();
  Future<Either<Failure, bool>> disconnectFromOrderTrackingHub();
  Future<Either<Failure, List<OrderTracking>>> getLocalOrderTrackings();
  Future<Either<Failure, OrderTracking>> getOrderTrackingById(String orderId);
}