import 'package:dartz/dartz.dart';

import '../../../core/exception/failure.dart';
import '../../repositories/order_tracking_repository.dart';

class ConnectToOrderTrackingHubUseCase {
  final OrderTrackingRepository repository;

  ConnectToOrderTrackingHubUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.connectToOrderTrackingHub();
  }
}