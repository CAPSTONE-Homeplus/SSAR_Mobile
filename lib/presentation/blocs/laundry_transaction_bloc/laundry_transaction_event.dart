import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/transaction/create_transaction.dart';

abstract class LaundryTransactionEvent extends Equatable {
  const LaundryTransactionEvent();

  @override
  List<Object?> get props => [];
}

class SaveLaundryTransactionEvent extends LaundryTransactionEvent {
  final CreateTransaction transaction;

  const SaveLaundryTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}