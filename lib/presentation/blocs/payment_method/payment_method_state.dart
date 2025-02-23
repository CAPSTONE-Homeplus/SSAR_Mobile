import 'package:equatable/equatable.dart';

import '../../../core/base/base_model.dart';
import '../../../domain/entities/payment_method/payment_method.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();
}

class PaymentMethodInitial extends PaymentMethodState {
  @override
  List<Object> get props => [];
}

class PaymentMethodLoading extends PaymentMethodState {
  @override
  List<Object> get props => [];
}

class PaymentMethodLoaded extends PaymentMethodState {
  final BaseResponse<PaymentMethod> response;

  PaymentMethodLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  PaymentMethodError(this.message);

  @override
  List<Object> get props => [message];
}
