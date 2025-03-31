import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/mappers/additional_service/additional_service_mapper.dart';

import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../domain/entities/additional_service/additional_service_model.dart';

class AdditionalServiceRepository {
  Future<BaseResponse<AdditionalService>> getAdditionService(String? search, String? orderBy, int? page, int? size) async{
    try {
      final response = await vinLaundryRequest.get(
          ApiConstant.additionalServices,
          queryParameters: {
            'search': search ?? '',
            'orderBy': orderBy ?? '',
            'page': page ?? Constant.defaultPage,
            'size': size ?? Constant.defaultSize
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<AdditionalService> additionalServices = data
            .map((item) => AdditionalServiceMapper.fromJson(item))
            .toList();


        return BaseResponse<AdditionalService>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: additionalServices,
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