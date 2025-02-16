import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/data/repositories/auth/authentication_repository.dart';

import '../../../data/models/authen/create_authen_model.dart';
import '../../../data/models/authen/login_model.dart';
import '../../../domain/usecases/auth/clear_user_from_local_usecase.dart';
import '../../../domain/usecases/auth/get_user_from_local_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/save_user_to_local_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase loginUseCase;
  final SaveUserToLocalUseCase saveUserToLocalUseCase;
  final GetUserFromLocalUseCase getUserFromLocalUseCase;
  final ClearUserFromLocalUseCase clearUserFromLocalUseCase;

  AuthenticationBloc({
    required this.loginUseCase, required this.saveUserToLocalUseCase,
    required this.getUserFromLocalUseCase, required this.clearUserFromLocalUseCase})
      : super(AuthenticationInitial()) {
    on<LoginAccount>(_onLoginAccount);
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

  Future<void> saveUserToLocal(String userName) async {
    await saveUserToLocalUseCase.call(userName);
  }

  Future<String?> getUserFromLocal() async {
    return await getUserFromLocalUseCase.call();
  }

  Future<void> clearUserFromLocal() async {
    await clearUserFromLocalUseCase.call();
  }
}
