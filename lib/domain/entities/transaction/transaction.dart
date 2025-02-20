import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  String? id;
  String? walletId;
  String? userId;
  String? paymentMethodId;
  String? amount;
  String? type;
  String? paymentUrl;
  String? note;
  String? transactionDate;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? code;
  String? categoryId;
  String? orderId;

  Transaction({
    this.id,
    this.walletId,
    this.userId,
    this.paymentMethodId,
    this.amount,
    this.type,
    this.paymentUrl,
    this.note,
    this.transactionDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.categoryId,
    this.orderId,
  });

  List<Object?> get props => [
    id,
    walletId,
    userId,
    paymentMethodId,
    amount,
    type,
    paymentUrl,
    note,
    transactionDate,
    status,
    createdAt,
    updatedAt,
    code,
    categoryId,
    orderId,
  ];
}