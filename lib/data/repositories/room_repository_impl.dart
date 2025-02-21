import 'package:home_clean/data/mappers/room_mapper.dart';

import '../../core/api_constant.dart';
import '../../core/base_model.dart';
import '../../core/exception_handler.dart';
import '../../core/request.dart';
import '../../domain/entities/room/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../models/room/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  @override
  Future<BaseResponse<Room>> getRooms(String? search,
      String? orderBy,
      int? page,
      int? size,) async{
    try {
      final response = await homeCleanRequest.get(
          ApiConstant.rooms,
          queryParameters: {
            'search': search,
            'orderby': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Room> rooms = data
            .map((item) => RoomMapper.toEntity(
            RoomModel.fromJson(item)))
            .toList();

        return BaseResponse<Room>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: rooms,
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