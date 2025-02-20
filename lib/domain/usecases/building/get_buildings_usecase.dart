import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/entities/building/building.dart';

import '../../../core/base_model.dart';
import '../../entities/room/room.dart';
import '../../repositories/building_repository.dart';
import '../base_usecase.dart';
import '../failure.dart';

class GetBuildingsUsecase implements UseCase<BaseResponse<Building>, GetBuildingsParams> {
  final BuildingRepository buildingRepository;

  GetBuildingsUsecase(this.buildingRepository);

  @override
  Future<Either<Failure, BaseResponse<Building>>> call(GetBuildingsParams params) async {
    try {
      final result = await buildingRepository.getBuildings(
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


class GetBuildingsParams {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetBuildingsParams({
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}