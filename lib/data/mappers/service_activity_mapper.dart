import 'package:home_clean/data/models/service_activity/service_activity_model.dart';
import 'package:home_clean/domain/entities/service_activity.dart';

class ServiceActivityMapper {
  static ServiceActivityModel toModel(ServiceActivity entity) {
    return ServiceActivityModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      prorityLevel: entity.prorityLevel,
      estimatedTimePerTask: entity.estimatedTimePerTask,
      safetyMeasures: entity.safetyMeasures,
      serviceId: entity.serviceId,
    );
  }

  static ServiceActivity toEntity(ServiceActivityModel model) {
    return ServiceActivity(
      id: model.id,
      name: model.name,
      code: model.code,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      prorityLevel: model.prorityLevel,
      estimatedTimePerTask: model.estimatedTimePerTask,
      safetyMeasures: model.safetyMeasures,
      serviceId: model.serviceId,
    );
  }
}
