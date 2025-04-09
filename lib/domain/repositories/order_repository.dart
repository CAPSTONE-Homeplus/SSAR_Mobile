import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/order/cancellation_request.dart';

import '../entities/order/create_order.dart';
import '../entities/order/order.dart';
import '../../data/models/order/create_order_model.dart';
import '../entities/rating_request/rating_request.dart';
import '../entities/service_in_house_type/house_type.dart';
import '../entities/staff/staff.dart';

abstract class OrderRepository {
  // API
  Future<Orders> createOrder(CreateOrder createOrder);
  Future<BaseResponse<Orders>> getOrdersByUser(String? search, String? orderBy, int? page, int? size);
  Future<Orders> getOrder(String orderId);
  Future<bool> cancelOrder(String orderId, CancellationRequest cancellationRequest);
  Future<Staff> getStaffById(String orderId);
  Future<bool> ratingOrder(RatingRequest ratingRequest);
  Future<ServiceInHouseType> getPriceByHouseType(String houseId, String serviceId);
}