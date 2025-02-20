import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/usecases/wallet/get_wallet_by_user.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';

import '../../../core/constant.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletByUser getWalletByUser;

  WalletBloc({required this.getWalletByUser}) : super(WalletInitial()) {
    on<GetWallet>(_onGetWallet);
  }

  Future<void> _onGetWallet(
    GetWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final response = await getWalletByUser.execute(
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(WalletLoaded(wallets: response.items));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }
}