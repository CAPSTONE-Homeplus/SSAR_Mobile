import 'package:dartz/dartz.dart';

import '../../../core/exception/failure.dart';
import '../../entities/order/order_tracking.dart';
import '../../repositories/order_tracking_repository.dart';

class GetLocalOrderTrackingsUseCase {
  final OrderTrackingRepository repository;

  GetLocalOrderTrackingsUseCase(this.repository);

  Future<Either<Failure, List<OrderTracking>>> call() async {
    return await repository.getLocalOrderTrackings();
  }
}
