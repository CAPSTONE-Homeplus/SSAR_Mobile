import 'package:equatable/equatable.dart';

class TransactionModel {
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

  TransactionModel({
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_id'] = walletId;
    data['user_id'] = userId;
    data['payment_method_id'] = paymentMethodId;
    data['amount'] = amount;
    data['type'] = type;
    data['payment_url'] = paymentUrl;
    data['note'] = note;
    data['transaction_date'] = transactionDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['code'] = code;
    data['category_id'] = categoryId;
    data['order_id'] = orderId;
    return data;
  }

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletId = json['wallet_id'];
    userId = json['user_id'];
    paymentMethodId = json['payment_method_id'];
    amount = json['amount'];
    type = json['type'];
    paymentUrl = json['payment_url'];
    note = json['note'];
    transactionDate = json['transaction_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    code = json['code'];
    categoryId = json['category_id'];
    orderId = json['order_id'];
  }
}