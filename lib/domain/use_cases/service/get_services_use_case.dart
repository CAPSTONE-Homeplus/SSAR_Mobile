import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/service/service.dart' as my_service;

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/service_repository.dart';

class GetServicesUseCase {
  final ServiceRepository _serviceRepository;

  GetServicesUseCase(this._serviceRepository);

  Future<Either<Failure, BaseResponse<my_service.Service>>> execute({
    String? search,
    String? orderBy,
    int? page,
    int? size,
  }) async {
    try {
      final response = await _serviceRepository.getServices(
        search,
        orderBy,
        page,
        size,
      );
      return Right(response);
    } on ApiException catch (e, stackTrace) {
      log('Lỗi API: ${e.description}', error: e, stackTrace: stackTrace);
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e, stackTrace) {
      log('Lỗi hệ thống: $e', error: e, stackTrace: stackTrace);
      return Left(ServerFailure('Lỗi hệ thống'));
    }
  }
}
