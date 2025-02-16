import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/option_mapper.dart';
import 'package:home_clean/data/models/option/option_model.dart';
import 'package:home_clean/data/repositories/option/option_repository.dart';
import 'package:home_clean/domain/entities/option/option.dart';

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
          .get('${ApiConstant.SERVICES}/$serviceId/options', queryParameters: {
        'id': serviceId,
        'search': search,
        'orderBy': orderBy,
        'page': page,
        'size': size,
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
