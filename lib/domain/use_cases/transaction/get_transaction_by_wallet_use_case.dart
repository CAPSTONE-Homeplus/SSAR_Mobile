import 'package:dartz/dartz.dart';

import '../../../core/base/base_model.dart';
import '../../../core/exception/exception_handler.dart';
import '../../entities/transaction/transaction.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionByWalletUseCase {
  final TransactionRepository _transactionRepository;

  GetTransactionByWalletUseCase(this._transactionRepository);

  Future<Either<String, BaseResponse<Transaction>>> call(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try {
      final result = await _transactionRepository.getTransactionByUserWallet(walletId, search, orderBy, page, size);
      return Right(result);
    } on ApiException catch (e) {
      print('API Exception: ${e.description}');
      return Left(e.description ?? 'Đã có lỗi xảy ra!');
    }
  }
}