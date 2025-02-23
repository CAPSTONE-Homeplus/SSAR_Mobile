import 'package:home_clean/core/base/base_model.dart';

import '../entities/payment_method/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<BaseResponse<PaymentMethod>> getPaymentMethods(String? search, String? orderBy, int? page, int? size);
}