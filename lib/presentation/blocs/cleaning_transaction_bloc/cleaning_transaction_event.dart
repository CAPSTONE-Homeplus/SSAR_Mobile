import '../../../domain/entities/transaction/create_transaction.dart';

abstract class CleaningTransactionEvent {}

class SaveCleaningTransactionEvent extends CleaningTransactionEvent {
  final CreateTransaction transaction;
  SaveCleaningTransactionEvent(this.transaction);
}