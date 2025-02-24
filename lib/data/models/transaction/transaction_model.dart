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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      walletId: json['walletId'],
      userId: json['userId'],
      paymentMethodId: json['paymentMethodId'],
      amount: json['amount'],
      type: json['type'],
      paymentUrl: json['paymentUrl'],
      note: json['note'],
      transactionDate: json['transactionDate'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      code: json['code'],
      categoryId: json['categoryId'],
      orderId: json['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'amount': amount,
      'type': type,
      'paymentUrl': paymentUrl,
      'note': note,
      'transactionDate': transactionDate,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'code': code,
      'categoryId': categoryId,
      'orderId': orderId,
    };
  }
}