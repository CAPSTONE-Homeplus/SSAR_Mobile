import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/repositories/service_activity/service_activity_repository.dart';
import 'package:home_clean/domain/entities/service_activity/service_activity.dart';

class GetServiceActivitiesByServiceUsecase {
  final ServiceActivityRepository _serviceActivityRepository;

  GetServiceActivitiesByServiceUsecase(this._serviceActivityRepository);

  Future<BaseResponse<ServiceActivity>> execute(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _serviceActivityRepository.getServiceActivitiesByServiceId(
      serviceId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
