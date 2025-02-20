import '../../../core/base_model.dart';
import '../../entities/order/order.dart';
import '../../entities/order/create_order.dart';
import '../../repositories/order_repository.dart';

class CreateOrders {
  final OrderRepository repository;

  CreateOrders(this.repository);

  Future<Order> call(CreateOrder createOrder) async {
    return await repository.createOrder(createOrder);
  }
}