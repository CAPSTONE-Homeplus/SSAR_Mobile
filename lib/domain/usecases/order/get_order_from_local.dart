import '../../entities/order/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderFromLocal {
  final OrderRepository repository;

  GetOrderFromLocal(this.repository);

  Future<Order?> call() async {
    return await repository.getOrderFromLocal();
  }
}