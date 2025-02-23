import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/room/room.dart';

abstract class RoomRepository {
  Future<BaseResponse<Room>> getRooms(String? search, String? orderBy, int? page, int? size);
  // Future<BaseResponse<Room>> getRoom(String roomId, String? search, String? orderBy, int? page, int? size);
}