import 'package:home_clean/core/base_model.dart';

import '../entities/service.dart';

abstract class ServiceRepository {
  Future<BaseResponse<Service>> getServices(
      String search, String orderBy, int page, int size);
}
