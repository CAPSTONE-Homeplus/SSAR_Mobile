import '../../../core/base_model.dart';
import '../../../data/repositories/order/order_repository.dart';
import '../../entities/order/order.dart';
import '../../entities/order/create_order.dart';

class CreateOrders {
  final OrderRepository repository;

  CreateOrders(this.repository);

  Future<Order> call(CreateOrder createOrder) async {
    return await repository.createOrder(createOrder);
  }
}