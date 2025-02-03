import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/extra_service_mapper.dart';
import 'package:home_clean/data/models/extra_service/extra_service_model.dart';
import 'package:home_clean/data/repositories/extra_service/extra_service_repository.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

class ExtraServiceRepositoryImpl implements ExtraServiceRepository {
  @override
  Future<BaseResponse<ExtraService>> getExtraServices(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await request.get(
          '${ApiConstant.SERVICES}/$serviceId/extra-services',
          queryParameters: {
            'id': serviceId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<ExtraService> extraServiceList = data
            .map((item) =>
                ExtraServiceMapper.toEntity(ExtraServiceModel.fromJson(item)))
            .toList();

        return BaseResponse<ExtraService>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: extraServiceList,
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
