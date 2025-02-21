import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/service_category_mapper.dart';
import 'package:home_clean/data/mappers/service_mapper.dart';
import 'package:home_clean/domain/entities/service/service.dart';

import '../../../core/base_model.dart';
import '../../../core/exception_handler.dart';
import '../../../domain/entities/service_category/service_category.dart';
import '../../../domain/repositories/service_category_repository.dart';
import '../models/service/service_model.dart';
import '../models/service_category/service_category_model.dart';

class ServiceCategoryRepositoryImpl implements ServiceCategoryRepository {
  @override
  Future<BaseResponse<ServiceCategory>> getServiceCategories(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await homeCleanRequest
          .get(ApiConstant.serviceCategories, queryParameters: {
        'search': search,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<ServiceCategory> serviceCategoryList = data
            .map((item) => ServiceCategoryMapper.toEntity(
                ServiceCategoryModel.fromJson(item)))
            .toList();

        return BaseResponse<ServiceCategory>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: serviceCategoryList,
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
  Future<BaseResponse<Service>> getServiceByServiceCategory(
    String serviceCategoryId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.serviceCategories}/$serviceCategoryId/services',
          queryParameters: {
            'id': serviceCategoryId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Service> serviceList = data
            .map((item) => ServiceMapper.toEntity(ServiceModel.fromJson(item)))
            .toList();

        return BaseResponse<Service>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: serviceList,
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
