import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/extra_service_repository.dart';

class GetExtraServiceUseCase {
  final ExtraServiceRepository _extraServiceRepository;

  GetExtraServiceUseCase(this._extraServiceRepository);

  Future<Either<Failure, BaseResponse<ExtraService>>> execute(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try{
      final response = await _extraServiceRepository.getExtraServices(
        serviceId,
        search,
        orderBy,
        page,
        size,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
