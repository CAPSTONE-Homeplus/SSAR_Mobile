import 'package:home_clean/core/base/base_model.dart';

import '../entities/order/create_order.dart';
import '../entities/order/order.dart';
import '../../data/models/order/create_order_model.dart';

abstract class OrderRepository {
  // API
  Future<Orders> createOrder(CreateOrder createOrder);

  // Local DB
  Future<void> saveOrderToLocal(CreateOrder createOrder);
  Future<Orders?> getOrderFromLocal();
  Future<void> deleteOrderFromLocal();
}