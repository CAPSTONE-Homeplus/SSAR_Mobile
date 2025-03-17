import '../../../core/base/base_model.dart';
import '../../../core/exception/exception_handler.dart';
import '../../entities/payment_method/payment_method.dart';
import '../../repositories/payment_method_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/exception/failure.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository _paymentMethodRepository;

  GetPaymentMethodsUseCase(this._paymentMethodRepository);

  Future<Either<Failure, BaseResponse<PaymentMethod>>> execute(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      final result = await _paymentMethodRepository.getPaymentMethods(
          search, orderBy, page, size);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
