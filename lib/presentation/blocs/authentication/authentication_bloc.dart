import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/data/models/authen/authen_model.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';

import '../../../data/models/user/create_user_model.dart';
import '../../../data/models/authen/login_model.dart';
import '../../../domain/entities/auth/authen.dart';
import '../../../domain/entities/user/create_user.dart';
import '../../../domain/usecases/auth/clear_user_from_local_usecase.dart';
import '../../../domain/usecases/auth/get_user_from_local_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/save_user_to_local_usecase.dart';
import '../../../domain/usecases/auth/user_register_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase loginUseCase;
  // final SaveUserToLocalUseCase saveUserToLocalUseCase;
  // final GetUserFromLocalUseCase getUserFromLocalUseCase;
  final ClearUserFromLocalUseCase clearUserFromLocalUseCase;
  final UserRegisterUseCase userRegisterUseCase;

  AuthenticationBloc({
    required this.loginUseCase, required this.clearUserFromLocalUseCase, required this.userRegisterUseCase})
      : super(AuthenticationInitial()) {
    on<LoginAccount>(_onLoginAccount);
    // on<GetUserFromLocal>(_getUserFromLocal);
    on<RegisterAccount>(_onRegisterAccount);
  }

  Future<void> _onLoginAccount(
      LoginAccount event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final isSuccess = await loginUseCase.call(
        LoginModel(
          username: event.username,
          password: event.password,
        ),
      );

      if (isSuccess) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFailed(
            error: 'Tên đăng nhập hoặc mật khẩu không đúng!'));
      }
    } catch (e) {
      emit(AuthenticationFailed(
          error: 'Đã có lỗi xảy ra, vui lòng thử lại: $e'));
    }
  }

  // Future<void> saveUserToLocal(AuthenModel authModel) async {
  //   await saveUserToLocalUseCase.call(authModel);
  // }

  // Future<void> _getUserFromLocal(GetUserFromLocal event, Emitter<AuthenticationState> emit) async {
  //   emit(AuthenticationLoading());
  //   try {
  //     final authen = await getUserFromLocalUseCase.call();
  //     if (authen != null) {
  //       emit(AuthenticationFromLocal(authen: authen));
  //     } else {
  //       emit(AuthenticationFailed(error: 'Không tìm thấy người dùng!'));
  //     }
  //   } catch (e) {
  //     emit(AuthenticationFailed(error: 'Đã có lỗi xảy ra, vui lòng thử lại: $e'));
  //   }
  // }

  Future<void> clearUserFromLocal() async {
    await clearUserFromLocalUseCase.call();
  }

  Future<void> _onRegisterAccount(
      RegisterAccount event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final isSuccess = await userRegisterUseCase.call(
        CreateUser(
          fullName: event.fullName,
          username: event.username,
          password: event.password,
          roomCode: event.roomCode,
        ),
      );

      if (isSuccess is AuthenModel) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailed(
            error: 'Đã có lỗi xảy ra, vui lòng thử lại!'));
      }
    } catch (e) {
      emit(RegisterFailed(
          error: 'Đã có lỗi xảy ra, vui lòng thử lại: $e'));
    }
  }
}
