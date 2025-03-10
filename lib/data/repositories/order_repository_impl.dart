import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/domain/entities/order/create_order.dart';

import 'package:home_clean/domain/entities/order/order.dart';

import '../../../domain/repositories/order_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../mappers/order/order_mapper.dart';
import '../mappers/user/user_mapper.dart';

class OrderRepositoryImpl implements OrderRepository {

  final UserLocalDatasource userLocalDatasource;

  OrderRepositoryImpl({
    required this.userLocalDatasource,
  });

  @override
  Future<Orders> createOrder(CreateOrder createOrder) async {
    try {
      final user = UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final requestData = {
        "address": createOrder.address,
        "notes": createOrder.notes.toString(),
        "emergencyRequest": createOrder.emergencyRequest,
        "timeSlotId": createOrder.timeSlot.id.toString(),
        "serviceId": createOrder.service.id.toString(),
        "userId": user.id.toString(),
        "houseTypeId": createOrder.houseTypeId.toString(),
        "optionIds": (createOrder.option).map((e) => e.id).toList(),
        "extraServiceIds": (createOrder.extraService).map((e) => e.id).toList(),
      };

      final response = await homeCleanRequest.post(
        ApiConstant.orders,
        data: requestData,
      );

      if (response.statusCode == 201 && response.data is Map<String, dynamic>) {
        return OrderMapper.toEntity(OrderMapper.fromMapToOrderModel(response.data));
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      print(e.toString());

      throw ExceptionHandler.handleException(e);
    }
  }
}
