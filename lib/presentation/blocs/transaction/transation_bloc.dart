import 'package:bloc/bloc.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';
import '../../../core/exception/exception_handler.dart';
import '../../../domain/use_cases/transaction/get_transaction_by_user.dart';
import '../../../domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart';
import '../../../domain/use_cases/transaction/save_transaction_use_case.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SaveTransactionUseCase saveTransactionUseCase;
  final GetTransactionByUserUseCase getTransactionByUserUseCase;
  final GetTransactionByWalletUseCase getTransactionByWalletUseCase;
  final TransactionRepository transactionRepository;


  TransactionBloc(
      this.saveTransactionUseCase,
      this.getTransactionByUserUseCase,
      this.getTransactionByWalletUseCase,
      this.transactionRepository,
      ) : super(TransactionInitial()) {
    /// Nạp điểm
    on<SaveTopUpTransactionEvent>((event, emit) async {
      emit(TopUpTransactionLoading());
      try {
        final response = await transactionRepository.saveTransaction(event.transaction);
        emit(TopUpTransactionSuccess(response));
      } on ApiException catch (e) {
        emit(TopUpTransactionFailure(e.description ?? "Có lỗi xảy ra khi nạp điểm"));
      }
    });

    /// Thanh toán giặt
    on<SaveLaundryTransactionEvent>((event, emit) async {
      emit(LaundryTransactionLoading());
      try {
        final response = await transactionRepository.saveTransaction(event.transaction);
        emit(LaundryTransactionSuccess(response));
      } on ApiException catch (e) {
        emit(LaundryTransactionFailure(e.description ?? "Có lỗi xảy ra khi thanh toán giặt"));
      }
    });

    /// Thanh toán dọn dẹp
    on<SaveCleaningTransactionEvent>((event, emit) async {
      emit(CleaningTransactionLoading());
      try {
        final response = await transactionRepository.saveTransaction(event.transaction);
        emit(CleaningTransactionSuccess(response));
      } on ApiException catch (e) {
        emit(CleaningTransactionFailure(e.description ?? "Có lỗi xảy ra khi thanh toán dọn dẹp"));
      }
    });


    on<GetTransactionByUserEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await getTransactionByUserUseCase.call(
        search: event.search, orderBy: event.orderBy, page: event.page, size: event.size
      );

      result.fold(
            (failure) => emit(TransactionFailure(failure.message)),
            (user) => emit(TransactionsLoaded(user)),
      );
    });


    on<GetTransactionByWalletEvent>((event, emit) async {
      emit(TransactionLoading());
      Future.delayed(const Duration(milliseconds: 2000));
      final result = await getTransactionByWalletUseCase.execute(event.walletId ?? '', event.search, event.orderBy, event.page, event.size);
      result.fold(
            (failure) => emit(TransactionFailure(failure.message)),
            (user) => emit(TransactionsLoaded(user)),
      );
    });
  }
}
