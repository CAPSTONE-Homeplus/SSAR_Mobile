class CreateTransactionModel {
  String? walletId;
  String? userId;
  String? paymentMethodId;
  String? amount;
  String? note;
  String? orderId;
  int? serviceType;

  CreateTransactionModel({
    this.walletId,
    this.userId,
    this.paymentMethodId,
    this.amount,
    this.note,
    this.orderId,
    this.serviceType,
  });

  factory CreateTransactionModel.fromJson(Map<String, dynamic> json) {
    return CreateTransactionModel(
      walletId: json['walletId'],
      userId: json['userId'],
      paymentMethodId: json['paymentMethodId'],
      amount: json['amount'],
      note: json['note'],
      orderId: json['orderId'],
      serviceType: json['serviceType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'userId': userId,
      'paymentMethodId': paymentMethodId,
      'amount': amount,
      'note': note,
      'orderId': orderId,
      'serviceType': serviceType,
    };
  }
}