import '../../entities/order/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderFromLocal {
  final OrderRepository repository;

  GetOrderFromLocal(this.repository);

  Future<Orders?> call() async {
    return await repository.getOrderFromLocal();
  }
}