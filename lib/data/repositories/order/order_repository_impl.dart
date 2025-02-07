import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/models/order/create_order_model.dart';
import 'package:home_clean/domain/entities/order/create_order.dart';

import 'package:home_clean/domain/entities/order/order.dart';

import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {

  @override
  Future<Order> createOrder(CreateOrder createOrder) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOrderFromLocal() {
    // TODO: implement deleteOrderFromLocal
    throw UnimplementedError();
  }

  @override
  Future<Order?> getOrderFromLocal() {
    // TODO: implement getOrderFromLocal
    throw UnimplementedError();
  }

  @override
  Future<void> saveOrderToLocal(CreateOrder createOrder) {
    // TODO: implement saveOrderToLocal
    throw UnimplementedError();
  }
}
