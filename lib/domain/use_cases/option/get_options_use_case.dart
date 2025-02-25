import 'package:home_clean/domain/entities/option/option.dart';

import '../../../core/base/base_model.dart';
import '../../repositories/option_repository.dart';

class GetOptionsUseCase {
  final OptionRepository _optionRepository;

  GetOptionsUseCase(this._optionRepository);

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
