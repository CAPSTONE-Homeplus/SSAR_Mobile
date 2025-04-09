import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/datasource/local/service_local_data_source.dart';
import 'package:home_clean/data/mappers/service_mapper.dart';
import 'package:home_clean/data/models/service/service_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';

import '../../../domain/repositories/service_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/helper/network_helper.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl();

  @override
  Future<BaseResponse<Service>> getServices(
      String? search, String? orderBy, int? page, int? size) async {
    try {

        final response = await homeCleanRequest.get(ApiConstant.services, queryParameters: {
          'search': search ?? '',
          'orderBy': orderBy ?? '',
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
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
            traceId: response.data?['traceId'],
            code: response.data?['code'],
            message: response.data?['message'] ?? 'Lỗi từ máy chủ',
            description: response.data?['description'],
            timestamp: response.data?['timestamp'],
          );
        }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
