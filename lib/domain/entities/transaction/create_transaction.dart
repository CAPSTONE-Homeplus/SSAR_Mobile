import 'package:equatable/equatable.dart';

class CreateTransaction extends Equatable {
  String? walletId;
  String? userId;
  String? paymentMethodId;
  String? amount;
  String? note;
  String? orderId;
  int? serviceType;

  CreateTransaction({
    this.walletId,
    this.userId,
    this.paymentMethodId,
    this.amount,
    this.note,
    this.orderId,
    this.serviceType,
  });

  List<Object?> get props => [
    walletId,
    userId,
    paymentMethodId,
    amount,
    note,
    orderId,
    serviceType,
  ];

}