import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/repositories/service_category/service_category_repository.dart';
import 'package:home_clean/domain/entities/service/service.dart';

class GetServiceByServiceCategoryUsecase {
  final ServiceCategoryRepository _serviceCategoryRepository;

  GetServiceByServiceCategoryUsecase(this._serviceCategoryRepository);

  Future<BaseResponse<Service>> execute(
    String serviceCategoryId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _serviceCategoryRepository.getServiceByServiceCategory(
      serviceCategoryId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
