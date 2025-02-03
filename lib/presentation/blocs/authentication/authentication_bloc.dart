import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_clean/data/repositories/auth/authentication_repository.dart';

import '../../../data/models/authen/create_authen_model.dart';
import '../../../data/models/authen/login_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<StartAuthen>(_onStartAuthen);
    on<RegisterAccount>(_onRegisterAccount);
    on<LoginAccount>(_onLoginAccount);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Future<void> _onStartAuthen(
      StartAuthen event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInitial());
  }

  Future<void> _onRegisterAccount(
      RegisterAccount event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInProcess());
    try {
      final result = await authenticationRepository.registerAccount(
        CreateAuthenModel(
          userName: event.userName,
          password: event.password,
          email: event.email,
          roleName: event.roleName,
          phoneNumber: event.phoneNumber,
        ),
      );

      if (result != null) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFailed(
            error: 'Không thể đăng ký, vui lòng thử lại.'));
      }
    } catch (e) {
      emit(AuthenticationFailed(error: e.toString()));
    }
  }

  Future<void> _onLoginAccount(
      LoginAccount event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInProcess());
    try {
      final isSuccess = await authenticationRepository.login(
        LoginModel(
          emailOrUsername: event.emailOrUsername,
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
}
