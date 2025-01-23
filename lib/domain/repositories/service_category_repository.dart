import 'package:home_clean/domain/entities/service.dart';
import 'package:home_clean/domain/entities/service_category.dart';

import '../../core/base_model.dart';

abstract class ServiceCategoryRepository {
  Future<BaseResponse<ServiceCategory>> getServiceCategories({
    String search,
    String orderBy,
    int page,
    int size,
  });

  Future<BaseResponse<Service>> getServiceByServiceCategory({
    required String serviceCategoryId,
    String search,
    String orderBy,
    int page,
    int size,
  });
}
