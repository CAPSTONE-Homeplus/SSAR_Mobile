import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/room/room_event.dart';
import 'package:home_clean/presentation/blocs/room/room_state.dart';

import '../../../domain/usecases/room/get_rooms_usecase.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRoomsUseCase getRoomsUseCase;

  RoomBloc(this.getRoomsUseCase) : super(RoomInitial()) {
    on<GetRoomsEvent>(_onGetRooms);
  }

  Future<void> _onGetRooms(
      GetRoomsEvent event,
      Emitter<RoomState> emit,
      ) async {
    emit(RoomLoading());
    try {
      final response = await getRoomsUseCase(GetRoomsParams(
        search: event.search,
        orderBy: event.orderBy,
        page: event.page,
        size: event.size,
      ));

      response.fold(
            (failure) {
          emit(RoomError(failure.toString()));
          },
            (baseResponse) {
          if (baseResponse.items.isEmpty) {
            emit(RoomEmpty());
          } else {
            emit(RoomLoaded(rooms: baseResponse.items, size: baseResponse.size, page: baseResponse.page, total: baseResponse.total, totalPages: baseResponse.totalPages));
          }
        },
      );
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }

}
