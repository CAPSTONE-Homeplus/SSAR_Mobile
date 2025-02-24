import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/exception_handler.dart';

import '../../../core/base/base_model.dart';
import '../../../core/exception/failure.dart';
import '../../entities/payment_method/payment_method.dart';
import '../../repositories/payment_method_repository.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository _paymentMethodRepository;

  GetPaymentMethodsUseCase(this._paymentMethodRepository);

  Future<Either<String, BaseResponse<PaymentMethod>>> execute(
      String? search, String? orderBy, int? page, int? size) async {
    try {
      final result = await _paymentMethodRepository.getPaymentMethods(
          search, orderBy, page, size);
      return Right(result);
    } on ApiException catch (e) {
      print('API Exception: ${e.description}');
      return Left(e.description ?? 'Đã có lỗi xảy ra!');
    }
  }
}
