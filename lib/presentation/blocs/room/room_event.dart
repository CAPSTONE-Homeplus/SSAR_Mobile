import 'package:equatable/equatable.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class GetRoomsEvent extends RoomEvent {
  final String search;
  final String orderBy;
  final int page;
  final int size;

  GetRoomsEvent({
    required this.search,
    required this.orderBy,
    required this.page,
    required this.size,
  });

  @override
  List<Object> get props => [search, orderBy, page, size];
}