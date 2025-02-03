import 'package:home_clean/data/models/service/service_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';

class ServiceMapper {
  static ServiceModel toModel(Service service) {
    return ServiceModel(
        id: service.id,
        name: service.name,
        description: service.description,
        status: service.status,
        createdAt: service.createdAt,
        updatedAt: service.updatedAt,
        prorityLevel: service.prorityLevel,
        price: service.price,
        discount: service.discount,
        duration: service.duration,
        maxCapacity: service.maxCapacity,
        serviceCode: service.serviceCode,
        isFeatured: service.isFeatured,
        isAvailable: service.isAvailable,
        createdBy: service.createdBy,
        updatedBy: service.updatedBy,
        code: service.code,
        serviceCategoryId: service.serviceCategoryId);
  }

  static Service toEntity(ServiceModel model) {
    return Service(
        id: model.id,
        name: model.name,
        description: model.description,
        status: model.status,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        prorityLevel: model.prorityLevel,
        price: model.price,
        discount: model.discount,
        duration: model.duration,
        maxCapacity: model.maxCapacity,
        serviceCode: model.serviceCode,
        isFeatured: model.isFeatured,
        isAvailable: model.isAvailable,
        createdBy: model.createdBy,
        updatedBy: model.updatedBy,
        code: model.code,
        serviceCategoryId: model.serviceCategoryId);
  }
}
