import '../../entities/order/order_tracking.dart';
import '../../repositories/order_tracking_repository.dart';

class StreamOrderTrackingUseCase {
  final OrderTrackingRepository repository;

  StreamOrderTrackingUseCase(this.repository);

  Stream<OrderTracking> call() {
    return repository.orderTrackingStream;
  }
}