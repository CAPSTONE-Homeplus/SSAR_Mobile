import 'package:home_clean/domain/entities/transaction/transaction.dart';

import '../../core/base/base_model.dart';
import '../entities/transaction/create_transaction.dart';

abstract class TransactionRepository {
  Future<Transaction> saveTransaction(CreateTransaction transaction);
  Future<BaseResponse<Transaction>> getTransactionByUser(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );

  Future<BaseResponse<Transaction>>  getTransactionByUserWallet(
      String walletId,
      String? search,
      String? orderBy,
      int? page,
      int? size,);

  Future<BaseResponse<Transaction>> getTransactionByWallet(String walletId,
      String? search,
      String? orderBy,
      int? page,
      int? size);

}