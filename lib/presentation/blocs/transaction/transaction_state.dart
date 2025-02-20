import 'package:equatable/equatable.dart';
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

class TransactionFailure extends TransactionState {
  final String error;

  const TransactionFailure(this.error);

  @override
  List<Object> get props => [error];
}
