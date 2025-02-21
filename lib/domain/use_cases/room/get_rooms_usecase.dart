import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base_model.dart';

import '../../entities/room/room.dart';
import '../../repositories/room_repository.dart';
import '../base_usecase.dart';
import '../failure.dart';

class GetRoomsUseCase implements UseCase<BaseResponse<Room>, GetRoomsParams> {
  final RoomRepository roomRepository;

  GetRoomsUseCase(this.roomRepository);

  @override
  Future<Either<Failure, BaseResponse<Room>>> call(GetRoomsParams params) async {
    try {
      final result = await roomRepository.getRooms(
        params.search,
        params.orderBy,
        params.page,
        params.size,
      );

      return Right(result);
        } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class GetRoomsParams {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetRoomsParams({
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
