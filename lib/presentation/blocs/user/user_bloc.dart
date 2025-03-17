import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/user/check_user_info_use_case.dart';
import 'package:home_clean/domain/use_cases/user/get_users_by_shared_wallet_use_case.dart';
import 'package:home_clean/presentation/blocs/user/user_event.dart';
import 'package:home_clean/presentation/blocs/user/user_state.dart';

import '../../../domain/use_cases/user/get_user_by_phone_number_use_case.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersBySharedWalletUseCase getUsersBySharedWalletUseCase;
  final GetUserByPhoneNumberUseCase getUserByPhoneNumberUseCase;
  final CheckUserInfoUseCase checkUserInfoUseCase;

  UserBloc(this.getUsersBySharedWalletUseCase, this.getUserByPhoneNumberUseCase, this.checkUserInfoUseCase) : super(UserInitial()){
    on<GetUsersBySharedWalletEvent>(_getUsersBySharedWallet);
    on<GetUserByPhoneNumberEvent>(_getUserByPhoneNumber);
    on<CheckUserInfoEvent>(_checkUserInfo);
  }


  Future<void> _getUsersBySharedWallet(GetUsersBySharedWalletEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final response = await getUsersBySharedWalletUseCase.execute(
      event.walletId,
      event.search,
      event.orderBy,
      event.page,
      event.size,
    );
    response.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _getUserByPhoneNumber(GetUserByPhoneNumberEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final response = await getUserByPhoneNumberUseCase.execute(event.phone);
    response.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoadedByPhone(user)),
    );
  }

  Future<void> _checkUserInfo(CheckUserInfoEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final response = await checkUserInfoUseCase.execute(event.phoneNumber, event.email, event.username);
    response.fold(
      (failure) => emit(UserError(failure.message)),
      (isClear) => emit(CheckUserInfoSuccess(isClear)),
    );
  }
}