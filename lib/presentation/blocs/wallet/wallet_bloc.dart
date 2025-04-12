import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/wallet_repository.dart';
import 'package:home_clean/domain/use_cases/wallet/change_owner_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/create_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/delete_user_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/get_wallet_by_user.dart';
import 'package:home_clean/domain/use_cases/wallet/invite_member_wallet_use_case.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';

import '../../../core/constant/constants.dart';
import '../../../core/exception/exception_handler.dart';
import '../../../domain/use_cases/wallet/get_contribution_statistic_use_case.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletByUserUseCase getWalletByUser;
  final CreateWalletUseCase createWalletUseCase;
  final WalletRepository walletRepository;
  final ChangeOwnerUseCase changeOwnerUseCase;
  final DeleteUserWalletUseCase deleteUserUseCase;
  final GetContributionStatisticUseCase getContributionStatisticUseCase;

  WalletBloc({required this.getWalletByUser,
    required this.createWalletUseCase,
    required this.walletRepository,
    required this.changeOwnerUseCase,
    required this.deleteUserUseCase,
    required this.getContributionStatisticUseCase}) : super(WalletInitial()) {
    on<GetWallet>(_onGetWallet);
    on<CreateWallet>(_onCreateWallet);
    on<InviteMember>(_onInviteMember);
    on<DeleteWallet>(_onDeleteWallet);
    on<GetContributionStatistics>(_onGetContributionStatistic);
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
    try {
      emit(WalletLoading());
      final response = await walletRepository.inviteMember(
          event.walletId, event.userId);
      emit(WalletInviteMemberSuccess(result: response));
    } on ApiException catch (e) {
      emit(WalletError(message: e.description ?? "Có lỗi xảy ra"));
    }
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

  Future<void> _onGetContributionStatistic(
    GetContributionStatistics event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    final response = await getContributionStatisticUseCase.execute(event.walletId, event.days);
    response.fold(
          (failure) => emit(WalletError(message: failure.message)),
          (result) => emit(WalletContributionStatisticsLoaded(contributionStatistics: result)),
    );
  }

}

class PersonalWalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletByUserUseCase getWalletByUser;

  PersonalWalletBloc({required this.getWalletByUser}) : super(WalletInitial()) {
    on<GetPersonalWallet>(_onGetPersonalWallet);
  }

  Future<void> _onGetPersonalWallet(
      GetPersonalWallet event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoading());
    try {
      final response = await getWalletByUser.execute(
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      final privateWallets = response.items.where((w) => w.type == personalWalletString).toList();
      emit(PersonalWalletLoaded(privateWallets));
    } catch (e) {
      emit(WalletError(message: 'Failed to fetch wallets: ${e.toString()}'));
    }
  }
}

class SharedWalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletByUserUseCase getWalletByUser;

  SharedWalletBloc({required this.getWalletByUser}) : super(WalletInitial()) {
    on<GetSharedWallet>(_onGetSharedWallet);
  }

  Future<void> _onGetSharedWallet(
      GetSharedWallet event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoading());
    try {
      final response = await getWalletByUser.execute(
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      final sharedWallets = response.items.where((w) => w.type == sharedWalletString).toList();
      emit(SharedWalletLoaded(sharedWallets));
    } catch (e) {
      emit(WalletError(message: 'Failed to fetch wallets: ${e.toString()}'));
    }
  }
}



/// Change Owner
class ChangeOwnerBloc extends Bloc<ChangeOwnerEvent, WalletState> {
  final WalletRepository walletRepository;

  ChangeOwnerBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<ChangeOwner>(_onChangeOwner);
  }

  Future<void> _onChangeOwner(
      ChangeOwner event,
      Emitter<WalletState> emit,
      ) async {
    try {
      emit(WalletChangeOwnerLoading());
      final response = await walletRepository.changeOwner(event.walletId, event.userId);
      emit(WalletChangeOwnerSuccess(wallet: response));
    } on ApiException catch (e) {
      emit(WalletChangeOwnerError(message: e.description ?? "Có lỗi xảy ra"));
    }
  }
}


/// Disoluition
class DissolutionBloc extends Bloc<DissolutionWalletEvent, WalletState> {
  final WalletRepository walletRepository;

  DissolutionBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<DissolutionWallet>(_onDisoluition);
  }

  Future<void> _onDisoluition(
      DissolutionWallet event,
      Emitter<WalletState> emit,
      ) async {
    try {
      emit(WalletDissolutionLoading());
      final response = await walletRepository.deleteSharedWalletByAdmin(event.walletId);
      emit(WalletDissolutionSuccess(result: response));
    } on ApiException catch (e) {
      emit(WalletDissolutionError(message: e.description ?? "Có lỗi xảy ra"));
    }
  }
}

class TransferBloc extends Bloc<TransferPointToSharedWallet, TransferPointToSharedWalletState> {
  final WalletRepository walletRepository;

  TransferBloc({required this.walletRepository}) : super(TransferPointToSharedWalletInitial()) {
    on<TransferToSharedWallet>(_onTransferToSharedWallet);
  }

  Future<void> _onTransferToSharedWallet(
      TransferToSharedWallet event,
      Emitter<TransferPointToSharedWalletState> emit,
      ) async {
    try {
      emit(TransferPointToSharedWalletLoading());
      final response = await walletRepository.transferToSharedWallet(event.sharedWalletId, event.personalWalletId, event.amount);
      emit(TransferPointToSharedWalletSuccess(result: response));
    } on ApiException catch (e) {
      emit(TransferPointToSharedWalletError(message: e.description ?? "Có lỗi xảy ra"));
    }
  }
}