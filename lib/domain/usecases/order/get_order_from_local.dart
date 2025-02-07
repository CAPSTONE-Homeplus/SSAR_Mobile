import '../../../data/repositories/order/order_repository.dart';
import '../../entities/order/order.dart';

class GetOrderFromLocal {
  final OrderRepository repository;

  GetOrderFromLocal(this.repository);

  Future<Order?> call() async {
    return await repository.getOrderFromLocal();
  }
}