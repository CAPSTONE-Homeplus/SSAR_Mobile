import 'package:home_clean/data/models/payment_method/payment_method_model.dart';

import '../../domain/entities/payment_method/payment_method.dart';

class PaymentMapper {
  static PaymentMethod toEntity(PaymentMethodModel paymentMethodModel){
    return PaymentMethod(
      id: paymentMethodModel.id,
      name: paymentMethodModel.name,
      description: paymentMethodModel.description,
      createdAt: paymentMethodModel.createdAt,
      updatedAt: paymentMethodModel.updatedAt,
      status: paymentMethodModel.status,
    );
  }

  static PaymentMethodModel toModel(PaymentMethod paymentMethod){
    return PaymentMethodModel(
      id: paymentMethod.id,
      name: paymentMethod.name,
      description: paymentMethod.description,
      createdAt: paymentMethod.createdAt,
      updatedAt: paymentMethod.updatedAt,
      status: paymentMethod.status,
    );
  }
}