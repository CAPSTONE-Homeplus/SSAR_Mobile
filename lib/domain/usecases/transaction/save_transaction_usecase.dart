import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
import 'package:home_clean/domain/usecases/failure.dart';
import '../../entities/transaction/create_transaction.dart';
import '../base_usecase.dart';

class SaveTransactionUsecase implements UseCase<Transaction, SaveTransactionParams> {
  final TransactionRepository repository;

  SaveTransactionUsecase(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(SaveTransactionParams params) async {
    try {
      final result = await repository.saveTransaction(params.transaction);
      return Right(result);
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