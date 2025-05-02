import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/user_repository.dart';
import 'package:home_clean/domain/repositories/wallet_repository.dart';
import 'package:home_clean/domain/use_cases/user/check_user_info_use_case.dart';
import 'package:home_clean/domain/use_cases/user/get_users_by_shared_wallet_use_case.dart';
import 'package:home_clean/presentation/blocs/user/user_event.dart';
import 'package:home_clean/presentation/blocs/user/user_state.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../domain/use_cases/user/get_user_by_phone_number_use_case.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersBySharedWalletUseCase getUsersBySharedWalletUseCase;
  final GetUserByPhoneNumberUseCase getUserByPhoneNumberUseCase;
  final CheckUserInfoUseCase checkUserInfoUseCase;
  final UserRepository userRepository;

  UserBloc(this.getUsersBySharedWalletUseCase, this.getUserByPhoneNumberUseCase,
      this.checkUserInfoUseCase, this.userRepository)
      : super(UserInitial()) {
    on<GetUsersBySharedWalletEvent>(_getUsersBySharedWallet);
    on<GetUserByPhoneNumberEvent>(_getUserByPhoneNumber);
    on<CheckUserInfoEvent>(_checkUserInfo);
    on<GetUserEvent>(_getUser);
  }

  Future<void> _getUsersBySharedWallet(
      GetUsersBySharedWalletEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserWalletLoading());

      final response = await userRepository.getUsersBySharedWallet(
        event.walletId,
        event.page,
        event.size,
      );
      emit(UserWalletLoaded(response));
    } catch (e) {
      emit(UserWalletError(e.toString()));
    }
  }

  Future<void> _getUserByPhoneNumber(
      GetUserByPhoneNumberEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final response = await userRepository.getUserByPhone(
        event.phone,
      );
      emit(UserLoadedByPhone(response));
    } on ApiException catch (e) {
      emit(UserErrorByPhone(e.description ?? "Có lỗi xảy ra"));
    }
  }

  Future<void> _checkUserInfo(
      CheckUserInfoEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final response = await userRepository.checkInfo(
        event.phoneNumber,
        event.email,
        event.username,
      );
      emit(CheckUserInfoSuccess(response));
    }on ApiException catch (e) {
      emit(UserError(e.description ?? "Có lỗi xảy ra"));
    }
  }

  Future<void> _getUser(
      GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final response = await userRepository.getUser(event.userId);
    emit(GetUserSuccess(response));
  }
}
