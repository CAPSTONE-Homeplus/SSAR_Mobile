import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/time_slot_mapper.dart';
import 'package:home_clean/data/models/time_slot/time_slot_model.dart';
import 'package:home_clean/data/repositories/time_slot/time_slot_repository.dart';
import 'package:home_clean/domain/entities/time_slot/time_slot.dart';

class TimeSlotRepositoryImpl implements TimeSlotRepository {
  @override
  Future<BaseResponse<TimeSlot>> getTimeSlots(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response =
          await homeCleanRequest.get('${ApiConstant.TIME_SLOTS}', queryParameters: {
        'search': search,
        'orderBy': orderBy,
        'page': page,
        'size': size,
      });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<TimeSlot> timeSlotList = data
            .map(
                (item) => TimeSlotMapper.toEntity(TimeSlotModel.fromJson(item)))
            .toList();

        return BaseResponse<TimeSlot>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: timeSlotList,
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
