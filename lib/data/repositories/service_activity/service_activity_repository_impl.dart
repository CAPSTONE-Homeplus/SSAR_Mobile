import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/service_activity_mapper.dart';
import 'package:home_clean/data/models/service_activity/service_activity_model.dart';
import 'package:home_clean/data/repositories/service_activity/service_activity_repository.dart';
import 'package:home_clean/domain/entities/service_activity/service_activity.dart';

class ServiceActivityRepositoryImpl implements ServiceActivityRepository {
  @override
  Future<BaseResponse<ServiceActivity>> getServiceActivitiesByServiceId(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.SERVICES}/$serviceId/service-activities',
          queryParameters: {
            'id': serviceId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<ServiceActivity> serviceActivityList = data
            .map((item) => ServiceActivityMapper.toEntity(
                ServiceActivityModel.fromJson(item)))
            .toList();

        return BaseResponse<ServiceActivity>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: serviceActivityList,
        );
      } else {
        throw ApiException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage ?? 'Lỗi không xác định',
          errorStatus: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
