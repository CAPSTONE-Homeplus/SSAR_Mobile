import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/transaction/transaction.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionByWalletUseCase {
  final TransactionRepository transactionRepository;

  GetTransactionByWalletUseCase(this.transactionRepository);

  Future<Either<Failure, BaseResponse<Transaction>>> execute(String walletId, String? search, String? orderBy, int? page, int? size) async {
    try{
      final result = await transactionRepository.getTransactionByWallet(walletId, search, orderBy, page, size);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Đã có lỗi xảy ra!'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}