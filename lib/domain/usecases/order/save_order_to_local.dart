import '../../entities/order/create_order.dart';
import '../../repositories/order_repository.dart';

class SaveOrderToLocal {
  final OrderRepository repository;

  SaveOrderToLocal(this.repository);

  Future<void> call(CreateOrder createOrder) async {
    await repository.saveOrderToLocal(createOrder);
  }
}