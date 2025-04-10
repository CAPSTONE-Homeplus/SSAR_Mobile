import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/user_local_datasource.dart';
import 'package:home_clean/data/models/order/order_laundry_detail_model.dart';
import 'package:home_clean/data/models/order/order_laundry_model.dart';
import 'package:home_clean/domain/entities/order/create_order.dart';
import 'package:home_clean/domain/entities/order/order.dart';
import 'package:home_clean/domain/entities/order/order_laundry.dart';
import 'package:home_clean/domain/entities/order/order_laundry_detail.dart';

import '../../../domain/repositories/order_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../domain/entities/order/cancellation_request.dart';
import '../../domain/entities/rating_request/rating_request.dart';
import '../../domain/entities/service_in_house_type/house_type.dart';
import '../../domain/entities/staff/staff.dart';
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
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final requestData = {
        "address": createOrder.address,
        "notes": createOrder.notes.toString(),
        "emergencyRequest": createOrder.emergencyRequest,
        if (createOrder.timeSlot.id != null &&
            createOrder.timeSlot.id.toString().isNotEmpty)
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
        return OrderMapper.toEntity(
            OrderMapper.fromMapToOrderModel(response.data));
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
  Future<BaseResponse<Orders>> getOrdersByUser(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
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
            .map((item) => OrderMapper.toEntity(OrderModel.fromJson(item)))
            .toList();

        // Sắp xếp đơn hàng
        orders.sort((a, b) {
          if (b.createdAt == null || a.createdAt == null) return 0;
          return b.createdAt!.compareTo(a.createdAt!);
        });

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

  @override
  Future<BaseResponse<OrderLaundry>> getOrdersByLaundryUser(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final response = await vinLaundryRequest.get(
        '/users/${user.id}/orders',
        queryParameters: {
          'search': search ?? '',
          'orderBy': orderBy ?? '',
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? [];

        final orders =
            data.map((e) => OrderLaundryModel.fromJson(e).toEntity()).toList();

        return BaseResponse<OrderLaundry>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: orders,
        );
      } else {
        throw Exception("API lỗi: ${response.data['message']}");
      }
    } catch (e) {
      print(e.toString());
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<OrderLaundryDetail> getLaundryOrderDetail(String orderId) async {
    try {
      final response = await homeCleanRequest.get('/api/v1/orders/$orderId');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final model = OrderLaundryDetailModel.fromJson(response.data);
        return model.toEntity();
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
      print('Lỗi khi lấy chi tiết đơn giặt: $e');
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<Orders> getOrder(String orderId) async {
    try {
      final response = await homeCleanRequest.get(
        '${ApiConstant.orders}/$orderId',
        queryParameters: {
          'id': orderId,
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        return OrderMapper.toEntity(
            OrderMapper.fromMapToOrderModel(response.data));
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
  Future<bool> cancelOrder(
      String orderId, CancellationRequest cancellationRequest) async {
    try {
      final user =
          UserMapper.toModel(await userLocalDatasource.getUser() ?? {});
      final response = await homeCleanRequest.post(
        '${ApiConstant.orders}/$orderId/cancel',
        queryParameters: {
          'id': orderId,
        },
        data: {
          'cancellationReason': cancellationRequest.cancellationReason,
          'refundMethod': cancellationRequest.refundMethod,
          'cancelledBy': user.id,
        },
      );
      if (response.data == true && response.statusCode == 200) {
        return true;
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
  Future<Staff> getStaffById(String staffId) async {
    try {
      final response = await homeCleanRequest.get(
        '${ApiConstant.staff}/$staffId',
      );

      if (response.statusCode == 200) {
        return Staff.fromJson(response.data);
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
  Future<bool> ratingOrder(RatingRequest rating) async {
    try {
      final response = await homeCleanRequest.post(
        ApiConstant.feedbacks,
        data: rating.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
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
  Future<ServiceInHouseType> getPriceByHouseType(
      String houseId, String serviceId) async {
    try {
      final response = await homeCleanRequest.get(
        '${ApiConstant.serviceHouseTypes}/by-house-and-service',
        queryParameters: {
          'houseId': houseId,
          'serviceId': serviceId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ServiceInHouseType.fromJson(response.data);
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
