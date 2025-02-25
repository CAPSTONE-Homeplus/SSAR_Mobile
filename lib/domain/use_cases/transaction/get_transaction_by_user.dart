import 'package:dartz/dartz.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../core/exception/failure.dart';
import '../../entities/transaction/transaction.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionByUserUseCase {
  final TransactionRepository _transactionRepository;

  GetTransactionByUserUseCase(this._transactionRepository);

  Future<Either<Failure, BaseResponse<Transaction>>> call({
    String? search,
    String? orderBy,
    int? page,
    int? size
  }) async {
    try {
      final result = await _transactionRepository.getTransactionByUser(
          search,
          orderBy,
          page,
          size
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Lỗi API không xác định!'));
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}