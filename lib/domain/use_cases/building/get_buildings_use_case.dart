import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/entities/building/building.dart';

import '../../../core/base/base_model.dart';
import '../../../core/exception/exception_handler.dart';
import '../../repositories/building_repository.dart';
import '../../../core/exception/failure.dart';

class GetBuildingsUseCase {
  final BuildingRepository buildingRepository;

  GetBuildingsUseCase(this.buildingRepository);

  Future<Either<Failure, BaseResponse<Building>>> execute(String? search,
   String? orderBy,
   int? page,
   int? size) async {
    try {
      final result = await buildingRepository.getBuildings(
        search,
        orderBy,
        page,
        size,
      );

      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
