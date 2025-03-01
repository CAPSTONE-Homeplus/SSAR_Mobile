import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/failure.dart';

import '../../../core/exception/exception_handler.dart';
import '../../repositories/house_repository.dart';
import '../../entities/house/house.dart';

class GetHouseUseCase {
  final HouseRepository _houseRepository;

  GetHouseUseCase(this._houseRepository);

  Future<Either<Failure, House>> execute(String houseId) async {
    try{
      final response =  await _houseRepository.getHouseById(houseId);
      return Right(response!);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}