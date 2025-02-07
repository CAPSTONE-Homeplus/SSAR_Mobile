import '../../../data/repositories/order/order_repository.dart';
import '../../entities/order/create_order.dart';

class SaveOrderToLocal {
  final OrderRepository repository;

  SaveOrderToLocal(this.repository);

  Future<void> call(CreateOrder createOrder) async {
    await repository.saveOrderToLocal(createOrder);
  }
}