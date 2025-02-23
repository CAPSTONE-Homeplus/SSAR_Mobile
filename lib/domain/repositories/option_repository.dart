import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/option/option.dart';

abstract class OptionRepository {
  Future<BaseResponse<Option>> getOptionsByServiceId(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
