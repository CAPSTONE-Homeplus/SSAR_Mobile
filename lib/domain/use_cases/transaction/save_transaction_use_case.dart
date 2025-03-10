import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
import 'package:home_clean/core/exception/failure.dart';
import '../../../core/base/base_usecase.dart';
import '../../../core/exception/exception_handler.dart';
import '../../entities/transaction/create_transaction.dart';

class SaveTransactionUseCase implements UseCase<Transaction, SaveTransactionParams> {
  final TransactionRepository repository;

  SaveTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(SaveTransactionParams params) async {
    try {
      final result = await repository.saveTransaction(params.transaction);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.description ?? 'Đã có lỗi xảy ra!'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SaveTransactionParams extends Equatable {
  final CreateTransaction transaction;

  const SaveTransactionParams({required this.transaction});

  @override
  List<Object> get props => [transaction];
}