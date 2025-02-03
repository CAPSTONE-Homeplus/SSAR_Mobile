import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/repositories/service_category/service_category_repository.dart';
import 'package:home_clean/domain/entities/service_category/service_category.dart';

class GetServiceCategoriesUsecase {
  final ServiceCategoryRepository _serviceCategoryRepository;

  GetServiceCategoriesUsecase(this._serviceCategoryRepository);

  Future<BaseResponse<ServiceCategory>> execute(
    String search,
    String orderBy,
    int page,
    int size,
  ) async {
    return await _serviceCategoryRepository.getServiceCategories(
      search,
      orderBy,
      page,
      size,
    );
  }
}
