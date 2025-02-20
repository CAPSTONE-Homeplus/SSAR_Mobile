import 'package:equatable/equatable.dart';

import '../../../domain/entities/room/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;
  final int size;
  final int page;
  final int total;
  final int totalPages;

  RoomLoaded({
    required this.rooms,
    required this.size,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object> get props => [rooms, size, page, total, totalPages];
}

class RoomError extends RoomState {
  final String message;

  RoomError(this.message);

  @override
  List<Object> get props => [message];
}

class RoomEmpty extends RoomState {}