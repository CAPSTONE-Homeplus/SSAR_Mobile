import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/data/repositories/sub_activity/sub_activity_repository.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

class GetSubActivitiesUsecase {
  final SubActivityRepository _subActivityRepository;

  GetSubActivitiesUsecase(this._subActivityRepository);

  Future<BaseResponse<SubActivity>> execute(
    String serviceActivityId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _subActivityRepository.getSubActivities(
      serviceActivityId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
