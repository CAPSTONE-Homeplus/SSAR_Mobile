import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/base/base_usecase.dart';
import '../../entities/transaction/create_transaction.dart';
import '../../entities/transaction/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/exception/failure.dart';

class ProcessTransactionUseCase implements UseCase<Transaction, ProcessTransactionParams> {
  final TransactionRepository repository;

  ProcessTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(ProcessTransactionParams params) async {
    try {
      final result = await repository.processTransactionWithOrder(params.transaction);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class ProcessTransactionParams extends Equatable {
  final CreateTransaction transaction;

  const ProcessTransactionParams({required this.transaction});

  @override
  List<Object> get props => [transaction];
}