import 'package:dartz/dartz.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/building/building.dart';
import '../../repositories/building_repository.dart';

class GetBuildingUseCase {
  final BuildingRepository _buildingRepository;

  GetBuildingUseCase(this._buildingRepository);

  Future<Either<Failure, Building>> execute(String buildingId) async {
    try {
      final result = await _buildingRepository.getBuildingById(buildingId);
      if (result == null) {
        return Left(ApiFailure('Không tìm thấy tòa nhà!'));
      }
      return Right(result);
    } on ApiException catch (e) {
    return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
    return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}