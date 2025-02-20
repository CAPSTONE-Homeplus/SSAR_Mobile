import 'package:home_clean/data/models/room/room_model.dart';
import 'package:home_clean/domain/entities/room/room.dart';

class RoomMapper {
  static Room toEntity (RoomModel roomModel) {
    return Room(
      id: roomModel.id ?? '',
      name: roomModel.name ?? '',
      status: roomModel.status ?? '',
      size: roomModel.size ?? 0,
      furnitureIncluded: roomModel.furnitureIncluded ?? false,
      createdAt: roomModel.createdAt ?? '',
      updatedAt: roomModel.updatedAt ?? '',
      squareMeters: roomModel.squareMeters ?? '',
      houseId: roomModel.houseId ?? '',
      roomTypeId: roomModel.roomTypeId ?? '',
      code: roomModel.code ?? '',
    );
  }

  static RoomModel toModel (Room room) {
    return RoomModel(
      id: room.id,
      name: room.name,
      status: room.status,
      size: room.size,
      furnitureIncluded: room.furnitureIncluded,
      createdAt: room.createdAt,
      updatedAt: room.updatedAt,
      squareMeters: room.squareMeters,
      houseId: room.houseId,
      roomTypeId: room.roomTypeId,
      code: room.code,
    );
  }
}