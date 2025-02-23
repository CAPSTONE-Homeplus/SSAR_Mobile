import 'package:home_clean/domain/entities/transaction/transaction.dart';

import '../entities/transaction/create_transaction.dart';

abstract class TransactionRepository {
  Future<Transaction> saveTransaction(CreateTransaction transaction);
  Future<Transaction> processTransactionWithOrder(CreateTransaction transaction);
}