import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/repositories/extra_service/extra_service_repository.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

class GetExtraServiceUsecase {
  final ExtraServiceRepository _extraServiceRepository;

  GetExtraServiceUsecase(this._extraServiceRepository);

  Future<BaseResponse<ExtraService>> execute(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _extraServiceRepository.getExtraServices(
      serviceId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
