import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/domain/entities/order/create_order.dart';

import 'package:home_clean/domain/entities/order/order.dart';

import '../../../domain/repositories/order_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../mappers/order/order_mapper.dart';
import '../mappers/user/user_mapper.dart';
import '../models/order/order_model.dart';

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
        if (createOrder.timeSlot.id != null && createOrder.timeSlot.id.toString().isNotEmpty)
          'timeSlotId': createOrder.timeSlot.id.toString(),
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

  @override
  Future<BaseResponse<Orders>> getOrdersByUser(String? search, String? orderBy, int? page, int? size) async {
    try{
      final user = UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final response = await homeCleanRequest.get(
        '${ApiConstant.orders}/by-user',
        queryParameters: {
          'userId': user.id,
          'search': search ?? '',
          'orderBy': orderBy ?? '',
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Orders> orders = data
            .map((item) => OrderMapper.toEntity(
            OrderModel.fromJson(item)))
            .toList();

        return BaseResponse<Orders>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: orders,
        );
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
