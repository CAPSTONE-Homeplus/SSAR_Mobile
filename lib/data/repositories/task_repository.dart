import 'package:home_clean/core/request/request.dart';

import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/constant/constants.dart';
import '../../core/exception/exception_handler.dart';
import '../../domain/entities/task/task.dart';

abstract class TaskRepository {
  Future<BaseResponse<Task>> getOrderTasks(
      String orderId, {
        int? page,
        int? size,
      });
}


class TaskRepositoryImpl implements TaskRepository {

  @override
  Future<BaseResponse<Task>> getOrderTasks(
      String orderId, {
        int? page,
        int? size,
      }) async {
    try {
      final response = await vinLaundryRequest.get(
        '${ApiConstant.orders}/$orderId/tasks',
        queryParameters: {
          'id': orderId,
          'page': page ?? Constant.defaultPage,
          'size': size ?? Constant.defaultSize,
        },
      );

      if (response.statusCode == 200 && response.data != null) {

        List<dynamic> data = response.data['items'] ?? [];
        List<Task> tasks = data
            .map((item) => Task.fromJson(item))
            .toList();

        return BaseResponse<Task>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: tasks,
        );
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Server Error',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}