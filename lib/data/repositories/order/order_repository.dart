import 'package:home_clean/core/base_model.dart';

import '../../../domain/entities/order/create_order.dart';
import '../../../domain/entities/order/order.dart';
import '../../models/order/create_order_model.dart';

abstract class OrderRepository {
  // API
  Future<Order> createOrder(CreateOrder createOrder);

  // Local DB
  Future<void> saveOrderToLocal(CreateOrder createOrder);
  Future<Order?> getOrderFromLocal();
  Future<void> deleteOrderFromLocal();
}