import 'package:bloc/bloc.dart';
import '../../../domain/use_cases/transaction/save_transaction_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransactionUseCase saveTransactionUseCase;

  TransactionBloc(this.saveTransactionUseCase) : super(TransactionInitial()) {
    on<SaveTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await saveTransactionUseCase(SaveTransactionParams(transaction: event.transaction));

      result.fold(
            (failure) => emit(TransactionFailure(failure.message)),
            (transaction) => emit(TransactionSuccess(transaction)),
      );
    });
  }
}
