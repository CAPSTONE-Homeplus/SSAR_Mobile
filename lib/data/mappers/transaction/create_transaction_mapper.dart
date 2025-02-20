import '../../../domain/entities/transaction/create_transaction.dart';
import '../../models/transaction/create_transaction_model.dart';

class CreateTransactionMapper {
  static CreateTransaction toEntity (CreateTransactionModel model) {
    return CreateTransaction(
        walletId: model.walletId,
        userId: model.userId,
        paymentMethodId: model.paymentMethodId,
        amount: model.amount,
        note: model.note,
        orderId: model.orderId,
    );
  }

  static CreateTransactionModel toModel (CreateTransaction entity) {
    return CreateTransactionModel(
        walletId: entity.walletId,
        userId: entity.userId,
        paymentMethodId: entity.paymentMethodId,
        amount: entity.amount,
        note: entity.note,
        orderId: entity.orderId,
    );
  }
}
