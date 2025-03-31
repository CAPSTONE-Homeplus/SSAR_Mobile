import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/laundry_service_type/laundry_service_type.dart';
import '../../repositories/laundry_service_type_repository.dart';

class GetLaundryServiceTypesUseCase {
  final LaundryServiceTypeRepository _laundryServiceTypeRepository;

  GetLaundryServiceTypesUseCase(this._laundryServiceTypeRepository);

  Future<Either<Failure, BaseResponse<LaundryServiceType>>> execute() async {
    try {
      final response = await _laundryServiceTypeRepository.getServiceTypes();
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}