import 'package:home_clean/data/models/sub_activity/sub_activity_model.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

class SubActivityMapper {
  static SubActivity toEntity(SubActivityModel model) {
    return SubActivity(
      id: model.id,
      name: model.name,
      code: model.code,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      serviceActivityId: model.serviceActivityId,
    );
  }

  static SubActivityModel toModel(SubActivity entity) {
    return SubActivityModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      serviceActivityId: entity.serviceActivityId,
    );
  }
}
