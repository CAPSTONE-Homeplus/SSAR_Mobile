import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/mappers/laundry_service_type_mapper.dart';
import 'package:home_clean/domain/repositories/laundry_service_type_repository.dart';

import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../../domain/entities/laundry_item_type/laundry_item_type.dart';
import '../../domain/entities/laundry_service_type/laundry_service_type.dart';
import '../mappers/laundry_item_type/laundry_item_type_mapper.dart';

class LaundryServiceTypeRepositoryImpl implements LaundryServiceTypeRepository {
  @override
  Future<BaseResponse<LaundryServiceType>> getServiceTypes() async {
    try {
      final response = await vinLaundryRequest.get(
          ApiConstant.laundryServiceTypes);

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<LaundryServiceType> services = data
            .map((item) =>
            LaundryServiceTypeMapper.fromJson(item))
            .toList();

        return BaseResponse<LaundryServiceType>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: services,
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
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<BaseResponse<LaundryItemType>> getLaundryItemTypeByService(String serviceTypeId) async {
    try {
      final response = await vinLaundryRequest.get(
          '${ApiConstant.laundryServiceTypes}/$serviceTypeId/item-types');

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<LaundryItemType> laundry = data
            .map((item) =>
            LaundryItemTypeMapper.fromMap(item))
            .toList();

        return BaseResponse<LaundryItemType>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: laundry,
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
      throw ExceptionHandler.handleException(e);
    }
  }
}