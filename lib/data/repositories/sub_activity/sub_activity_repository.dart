import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

abstract class SubActivityRepository {
  Future<BaseResponse<SubActivity>> getSubActivities(
    String activityId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
