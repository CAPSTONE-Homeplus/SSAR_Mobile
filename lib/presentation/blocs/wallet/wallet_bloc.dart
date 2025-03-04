import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/wallet/change_owner_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/create_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/delete_user_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/get_wallet_by_user.dart';
import 'package:home_clean/domain/use_cases/wallet/invite_member_wallet_use_case.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';

import '../../../core/constant/constants.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletByUserUseCase getWalletByUser;
  final CreateWalletUseCase createWalletUseCase;
  final InviteMemberWalletUseCase inviteMemberUseCase;
  final ChangeOwnerUseCase changeOwnerUseCase;
  final DeleteUserWalletUseCase deleteUserUseCase;

  WalletBloc({required this.getWalletByUser,
    required this.createWalletUseCase,
    required this.inviteMemberUseCase,
    required this.changeOwnerUseCase,
    required this.deleteUserUseCase}) : super(WalletInitial()) {
    on<GetWallet>(_onGetWallet);
    on<CreateWallet>(_onCreateWallet);
    on<InviteMember>(_onInviteMember);
    on<ChangeOwner>(_onChangeOwner);
    on<DeleteWallet>(_onDeleteWallet);
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

  Future<void> _onCreateWallet(
    CreateWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final response = await createWalletUseCase.execute();
    response.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (wallet) => emit(WalletCreatedSuccess(wallet: wallet)),
    );
  }


  Future<void> _onInviteMember(
    InviteMember event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final response = await inviteMemberUseCase.execute(event.walletId, event.userId);
    response.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (result) => emit(WalletInviteMemberSuccess(result: result)),
    );
  }

  Future<void> _onChangeOwner(
    ChangeOwner event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final response = await changeOwnerUseCase.execute(event.walletId, event.userId);
    response.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (result) => emit(WalletChangeOwnerSuccess(wallet: result)),
    );
  }

  Future<void> _onDeleteWallet(
    DeleteWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final response = await deleteUserUseCase.execute(event.walletId, event.userId);
    response.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (result) => emit(WalletDeleteSuccess(result: result)),
    );
  }

}