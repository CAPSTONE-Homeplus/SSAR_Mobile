import 'package:home_clean/domain/entities/option/option.dart';

import '../../../core/base_model.dart';
import '../../repositories/option_repository.dart';

class GetOptionsUsecase {
  final OptionRepository _optionRepository;

  GetOptionsUsecase(this._optionRepository);

  Future<BaseResponse<Option>> execute(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _optionRepository.getOptionsByServiceId(
      serviceId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
