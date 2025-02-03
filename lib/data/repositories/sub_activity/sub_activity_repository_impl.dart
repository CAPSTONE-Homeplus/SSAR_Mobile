import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/sub_activity_mapper.dart';
import 'package:home_clean/data/models/sub_activity/sub_activity_model.dart';
import 'package:home_clean/data/repositories/sub_activity/sub_activity_repository.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

class SubActivityRepositoryImpl implements SubActivityRepository {
  @override
  Future<BaseResponse<SubActivity>> getSubActivities(
    String activityId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await request.get(
          '${ApiConstant.SERVICE_ACTIVITIES}/$activityId/service-sub-activities',
          queryParameters: {
            'id': activityId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<SubActivity> subActivityList = data
            .map((item) =>
                SubActivityMapper.toEntity(SubActivityModel.fromJson(item)))
            .toList();

        return BaseResponse<SubActivity>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: subActivityList,
        );
      } else {
        throw ApiException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage ?? 'Lỗi không xác định',
          errorStatus: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
