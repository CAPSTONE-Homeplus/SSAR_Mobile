import 'package:dartz/dartz.dart';

import '../../../core/base/base_model.dart';
import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/laundry_item_type/laundry_item_type.dart';
import '../../repositories/laundry_service_type_repository.dart';

class GetLaundryItemTypeByServiceUseCase {
  final LaundryServiceTypeRepository _laundryItemTypeRepository;

  GetLaundryItemTypeByServiceUseCase(this._laundryItemTypeRepository);

  Future<Either<Failure, BaseResponse<LaundryItemType>>> execute(String serviceTypeId) async {
    try {
      final response = await _laundryItemTypeRepository.getLaundryItemTypeByService(serviceTypeId);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}