import 'package:equatable/equatable.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();
}


class GetPaymentMethodsEvent extends PaymentMethodEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetPaymentMethodsEvent({this.search, this.orderBy, this.page, this.size});

  @override
  List<Object?> get props => [search, orderBy, page, size];
}