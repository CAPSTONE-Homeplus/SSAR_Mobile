import 'package:home_clean/core/base_model.dart';

import '../entities/service_activity.dart';

abstract class ServiceActivityRepository {
  Future<BaseResponse<ServiceActivity>> getServiceActivitiesByServiceId({
    required String serviceId,
    String search,
    String orderBy,
    int page,
    int size,
  });
}
