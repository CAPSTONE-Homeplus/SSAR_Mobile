
import 'package:dartz/dartz.dart';

import '../../../core/exception/failure.dart';
import '../../repositories/order_tracking_repository.dart';

class DisconnectFromOrderTrackingHubUseCase {
  final OrderTrackingRepository repository;

  DisconnectFromOrderTrackingHubUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.disconnectFromOrderTrackingHub();
  }
}