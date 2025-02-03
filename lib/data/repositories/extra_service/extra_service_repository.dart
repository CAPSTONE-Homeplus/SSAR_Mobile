import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

abstract class ExtraServiceRepository {
  Future<BaseResponse<ExtraService>> getExtraServices(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
