import '../../domain/entities/service_category.dart';
import '../models/service_category/service_category_model.dart';

class ServiceCategoryMapper {
  static ServiceCategoryModel toModel(ServiceCategory entity) {
    return ServiceCategoryModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      createAt: entity.createAt,
      updatedAt: entity.updatedAt,
      code: entity.code,
    );
  }

  static ServiceCategory toEntity(ServiceCategoryModel model) {
    return ServiceCategory(
      id: model.id,
      name: model.name,
      status: model.status,
      createAt: model.createAt,
      updatedAt: model.updatedAt,
      code: model.code,
    );
  }
}
