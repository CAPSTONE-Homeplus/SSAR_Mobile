import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../repositories/equipment_supply_repository.dart';

class GetEquipmentSuppliesUseCase {
  final EquipmentSupplyRepository _equipmentRepository;

  GetEquipmentSuppliesUseCase(this._equipmentRepository);

  Future<Either<Failure, BaseResponse<EquipmentSupply>>> execute(
      String serviceId,
      String? search,
      String? orderBy,
      int? page,
      int? size,
      ) async {
    try {
      final result = await _equipmentRepository.getEquipmentSupplies(
        serviceId,
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
