import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/service_activity/service_activity.dart';


abstract class ServiceActivityRepository {
  Future<BaseResponse<ServiceActivity>> getServiceActivitiesByServiceId(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
