import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/core/exception/exception_handler.dart';
import 'package:home_clean/core/request/request.dart';
import 'package:home_clean/data/mappers/sub_activity_mapper.dart';
import 'package:home_clean/data/models/sub_activity/sub_activity_model.dart';
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart';

import '../../../domain/repositories/sub_activity_repository.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';

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
      final response = await homeCleanRequest.get(
          '${ApiConstant.serviceActivities}/$activityId/service-sub-activities',
          queryParameters: {
            'id': activityId,
            'search': search ?? '',
            'orderBy': orderBy ?? '',
            'page': page ?? Constant.defaultPage,
            'size': size ?? Constant.defaultSize
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
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
