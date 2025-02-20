import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class SaveTransactionEvent extends TransactionEvent {
  final CreateTransaction transaction;

  const SaveTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
