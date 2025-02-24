import 'package:bloc/bloc.dart';
import '../../../domain/use_cases/transaction/get_transaction_by_user.dart';
import '../../../domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart';
import '../../../domain/use_cases/transaction/save_transaction_usecase.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransactionUseCase saveTransactionUseCase;
  final GetTransactionByUserUseCase getTransactionByUserUseCase;
  final GetTransactionByWalletUseCase getTransactionByWalletUseCase;

  TransactionBloc(
      this.saveTransactionUseCase,
      this.getTransactionByUserUseCase,
      this.getTransactionByWalletUseCase,
      ) : super(TransactionInitial()) {

    on<SaveTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await saveTransactionUseCase(SaveTransactionParams(transaction: event.transaction));
      result.fold(
            (failure) => emit(TransactionFailure(failure.message)),
            (transaction) => emit(TransactionSuccess(transaction)),
      );
    });

    on<GetTransactionByUserEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await getTransactionByUserUseCase.call(
          event.search, event.orderBy, event.page, event.size
      );

      result.fold(
            (error) => emit(TransactionFailure(error)),
            (user) => emit(TransactionsLoaded(user)),
      );
    });


    on<GetTransactionByWalletEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await getTransactionByWalletUseCase(event.walletId ?? '', event.search, event.orderBy, event.page, event.size);
      result.fold(
            (error) => emit(TransactionFailure(error)),
            (user) => emit(TransactionsLoaded(user)),
      );
    });
  }
}
