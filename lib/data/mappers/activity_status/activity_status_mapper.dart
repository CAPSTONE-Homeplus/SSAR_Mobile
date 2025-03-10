
import '../../../domain/entities/activity_status/activity_status.dart';
import '../../models/activity_status/activity_status_model.dart';

class ActivityStatusMapper {
  /// Chuyển từ `ActivityStatusModel` sang `ActivityStatusEntity`
  static ActivityStatus toEntity(ActivityStatusModel model) {
    return ActivityStatus(
      activityId: model.activityId,
      status: model.status,
    );
  }

  /// Chuyển từ `ActivityStatusEntity` sang `ActivityStatusModel`
  static ActivityStatusModel toModel(ActivityStatus entity) {
    return ActivityStatusModel(
      activityId: entity.activityId,
      status: entity.status,
    );
  }

  /// Chuyển danh sách `ActivityStatusModel` sang danh sách `ActivityStatusEntity`
  static List<ActivityStatus> listToEntity(List<ActivityStatusModel> models) {
    return models.map(toEntity).toList();
  }

  /// Chuyển danh sách `ActivityStatusEntity` sang danh sách `ActivityStatusModel`
  static List<ActivityStatusModel> listToModel(List<ActivityStatus> entities) {
    return entities.map(toModel).toList();
  }
}

