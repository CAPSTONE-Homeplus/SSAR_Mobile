import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final Transaction transaction;

  const TransactionSuccess(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionsLoaded extends TransactionState {
  final BaseResponse<Transaction> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionFailure extends TransactionState {
  final String error;

  const TransactionFailure(this.error);

  @override
  List<Object> get props => [error];
}

/////

class TopUpTransactionLoading extends TransactionState {}

class TopUpTransactionSuccess extends TransactionState {
  final Transaction transaction;

  const TopUpTransactionSuccess(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TopUpTransactionFailure extends TransactionState {
  final String error;

  const TopUpTransactionFailure(this.error);

  @override
  List<Object> get props => [error];
}
