import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/order/cancellation_request.dart';

import '../entities/order/create_order.dart';
import '../entities/order/order.dart';
import '../../data/models/order/create_order_model.dart';

abstract class OrderRepository {
  // API
  Future<Orders> createOrder(CreateOrder createOrder);
  Future<BaseResponse<Orders>> getOrdersByUser(String? search, String? orderBy, int? page, int? size);
  Future<Orders> getOrder(String orderId);
  Future<bool> cancelOrder(String orderId, CancellationRequest cancellationRequest);
}