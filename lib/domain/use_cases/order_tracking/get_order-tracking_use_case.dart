import 'package:dartz/dartz.dart';

import '../../../core/exception/failure.dart';
import '../../entities/order/order_tracking.dart';
import '../../repositories/order_tracking_repository.dart';

class GetOrderTrackingByIdUseCase {
  final OrderTrackingRepository repository;

  GetOrderTrackingByIdUseCase(this.repository);

  Future<Either<Failure, OrderTracking>> call(String orderId) async {
    return await repository.getOrderTrackingById(orderId);
  }
}