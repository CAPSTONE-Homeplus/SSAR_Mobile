import '../../core/constant/api_constant.dart';import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/mappers/option_mapper.dart';
import 'package:home_clean/data/models/option/option_model.dart';
import 'package:home_clean/domain/entities/option/option.dart';

import '../../../domain/repositories/option_repository.dart';
import '../../core/constant/constants.dart';

class OptionRepositoryImpl implements OptionRepository {
  @override
  Future<BaseResponse<Option>> getOptionsByServiceId(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await homeCleanRequest
          .get('${ApiConstant.services}/$serviceId/options', queryParameters: {
        'id': serviceId,
        'search': search ?? '',
        'orderBy': orderBy ?? '',
        'page': page ?? Constant.defaultPage,
        'size': size ?? Constant.defaultSize
      });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Option> optionList = data
            .map((item) => OptionMapper.toEntity(OptionModel.fromJson(item)))
            .toList();

        return BaseResponse<Option>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: optionList,
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
