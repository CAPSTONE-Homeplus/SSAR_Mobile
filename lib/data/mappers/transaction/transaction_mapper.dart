import 'package:home_clean/data/models/transaction/transaction_model.dart';

import '../../../domain/entities/transaction/transaction.dart';

class TransactionMapper {
  static Transaction toEntity(TransactionModel transactionModel) {
    return Transaction(
      id: transactionModel.id,
      walletId: transactionModel.walletId,
      userId: transactionModel.userId,
      paymentMethodId: transactionModel.paymentMethodId,
      amount: transactionModel.amount,
      type: transactionModel.type,
      paymentUrl: transactionModel.paymentUrl,
      note: transactionModel.note,
      transactionDate: transactionModel.transactionDate,
      status: transactionModel.status,
      createdAt: transactionModel.createdAt,
      updatedAt: transactionModel.updatedAt,
      code: transactionModel.code,
      categoryId: transactionModel.categoryId,
      orderId: transactionModel.orderId,
    );
  }

  static TransactionModel toModel(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      walletId: transaction.walletId,
      userId: transaction.userId,
      paymentMethodId: transaction.paymentMethodId,
      amount: transaction.amount,
      type: transaction.type,
      paymentUrl: transaction.paymentUrl,
      note: transaction.note,
      transactionDate: transaction.transactionDate,
      status: transaction.status,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      code: transaction.code,
      categoryId: transaction.categoryId,
      orderId: transaction.orderId,
    );
  }
}

