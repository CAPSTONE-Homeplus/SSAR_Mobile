import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/house_repository.dart';
import '../../entities/house/house.dart';

class GetHouseByBuildingUseCase {
  final HouseRepository _houseRepository;

  GetHouseByBuildingUseCase(this._houseRepository);

  Future<Either<Failure, BaseResponse<House>>> execute(String buildingId, String? search
      , String? orderBy, int? page, int? size) async {
    try{
      final response =  await _houseRepository.getHouseByBuilding(buildingId, search,
          orderBy, page, size);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}