import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/entities/building/building.dart';

import '../../../core/base/base_model.dart';
import '../../../core/base/base_usecase.dart';
import '../../../core/exception/exception_handler.dart';
import '../../entities/room/room.dart';
import '../../repositories/building_repository.dart';
import '../../../core/exception/failure.dart';

class GetBuildingsUseCase {
  final BuildingRepository buildingRepository;

  GetBuildingsUseCase(this.buildingRepository);

  Future<Either<Failure, BaseResponse<Building>>> execute(GetBuildingsParams params) async {
    try {
      final result = await buildingRepository.getBuildings(
        params.search,
        params.orderBy,
        params.page,
        params.size,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
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