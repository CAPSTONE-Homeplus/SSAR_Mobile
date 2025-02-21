import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/datasource/service_local_data_source.dart';
import 'package:home_clean/data/mappers/service_mapper.dart';
import 'package:home_clean/data/models/service/service_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';

import '../../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;
  ServiceRepositoryImpl({required this.localDataSource});
  @override
  Future<BaseResponse<Service>> getServices(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      final response =
          await homeCleanRequest.get(ApiConstant.services, queryParameters: {
        'search': search,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];
        localDataSource.saveService(response.data);
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

  @override
  Future<void> clearSelectedServiceIds() {
    // TODO: implement clearSelectedServiceIds
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> getSelectedServiceIds() {
    // TODO: implement getSelectedServiceIds
    throw UnimplementedError();
  }

  @override
  Future<void> saveSelectedServiceIds(List<String> ids) {
    // TODO: implement saveSelectedServiceIds
    throw UnimplementedError();
  }

}
