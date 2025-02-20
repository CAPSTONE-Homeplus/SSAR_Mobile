import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String status;
  final int size;
  final bool furnitureIncluded;
  final String createdAt;
  final String updatedAt;
  final String squareMeters;
  final String houseId;
  final String roomTypeId;
  final String code;

  Room({
    required this.id,
    required this.name,
    required this.status,
    required this.size,
    required this.furnitureIncluded,
    required this.createdAt,
    required this.updatedAt,
    required this.squareMeters,
    required this.houseId,
    required this.roomTypeId,
    required this.code,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        size,
        furnitureIncluded,
        createdAt,
        updatedAt,
        squareMeters,
        houseId,
        roomTypeId,
        code,
      ];
}