import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/auth/auth_event.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../data/models/auth/login_model.dart';
import '../../../domain/entities/user/create_user.dart';
import '../../../domain/use_cases/auth/clear_user_from_local_usecase.dart';
import '../../../domain/use_cases/auth/get_user_from_local_usecase.dart';
import '../../../domain/use_cases/auth/login_usecase.dart';
import '../../../domain/use_cases/auth/user_register_usecase.dart';
import 'auth_state.dart';


class AuthBloc
    extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  // final SaveUserToLocalUseCase saveUserToLocalUseCase;
  final GetUserFromLocalUseCase getUserFromLocalUseCase;
  final ClearUserFromLocalUseCase clearUserFromLocalUseCase;
  final UserRegisterUseCase userRegisterUseCase;

  AuthBloc({
    required this.loginUseCase, required this.clearUserFromLocalUseCase,
    required this.userRegisterUseCase, required this.getUserFromLocalUseCase,})
      : super(AuthenticationInitial()) {
    on<LoginAccount>(_onLoginAccount);
    on<GetUserFromLocal>(_getUserFromLocal);
    on<RegisterAccount>(_onRegisterAccount);
  }

  Future<void> _onLoginAccount(
      LoginAccount event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    try {
      final result = await loginUseCase.call(
        LoginModel(
          username: event.username,
          password: event.password,
        ),
      );

      result.fold(
            (error) => emit(AuthenticationFailed(error: error)),
            (isSuccess) {
          if (isSuccess) {
            emit(AuthenticationSuccess());
          } else {
            emit(AuthenticationFailed(error: "Tên đăng nhập hoặc mật khẩu không đúng!"));
          }
        },
      );
    } on ApiException catch (e) {
      emit(AuthenticationFailed(error: e.description ?? "Đã có lỗi xảy ra!"));
    }
  }

  // Future<void> saveUserToLocal(AuthenModel authModel) async {
  //   await saveUserToLocalUseCase.call(authModel);
  // }

  Future<void> _getUserFromLocal(
      GetUserFromLocal event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    final result = await getUserFromLocalUseCase.call();
    result.fold(
          (error) {
        emit(AuthenticationFailed(error: error.message));
      },
          (user) {
        emit(AuthenticationFromLocal(user: user));
      },
    );
  }

  Future<void> clearUserFromLocal() async {
    await clearUserFromLocalUseCase.call();
  }

  Future<void> _onRegisterAccount(
      RegisterAccount event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    final result = await userRegisterUseCase.call(
      CreateUser(
        fullName: event.fullName,
        username: event.username,
        password: event.password,
        buildingCode: event.buildingCode,
        houseCode: event.houseCode,
      ),
    );

    result.fold(
          (error) {
        emit(RegisterFailed(error: error));
      },
          (user) {
        emit(RegisterSuccess());
      },
    );
  }


}
