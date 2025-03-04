import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/auth/auth_event.dart';

import '../../../core/exception/exception_handler.dart';
import '../../../data/models/auth/login_model.dart';
import '../../../domain/entities/user/create_user.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/use_cases/auth/get_user_from_local_usecase.dart';
import '../../../domain/use_cases/auth/login_usecase.dart';
import '../../../domain/use_cases/auth/user_register_usecase.dart';
import 'auth_state.dart';


class AuthBloc
    extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetUserFromLocalUseCase getUserFromLocalUseCase;
  final UserRegisterUseCase userRegisterUseCase;
  User? _user;

  User? getUser() => _user;

  AuthBloc({
    required this.loginUseCase,
    required this.userRegisterUseCase, required this.getUserFromLocalUseCase,})
      : super(AuthenticationInitial()) {
    on<LoginAccount>(_onLoginAccount);
    on<GetUserFromLocal>(_getUserFromLocal);
    on<RegisterAccount>(_onRegisterAccount);
  }

  Future<void> _onLoginAccount(
      LoginAccount event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());

    final result = await loginUseCase.call(
      LoginModel(
        username: event.username,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthenticationFailed(error: failure.message)),
          (isSuccess) {
        if (isSuccess) {
          emit(AuthenticationSuccess());
        } else {
          emit(AuthenticationFailed(error: "Tên đăng nhập hoặc mật khẩu không đúng!"));
        }
      },
    );
  }

  Future<void> _getUserFromLocal(
      GetUserFromLocal event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());
    final result = await getUserFromLocalUseCase.call();
    result.fold(
          (error) {
        emit(AuthenticationFailed(error: error.message));
      },
          (user) {
        _user = user;
        emit(AuthenticationFromLocal(user: user));
      },
    );
  }

  Future<void> _onRegisterAccount(
      RegisterAccount event, Emitter<AuthState> emit) async {
    emit(AuthenticationLoading());

    final result = await userRegisterUseCase.execute(
      CreateUser(
        fullName: event.fullName,
        username: event.username,
        password: event.password,
        buildingCode: event.buildingCode,
        houseCode: event.houseCode,
      ),
    );

    result.fold(
          (failure) => emit(RegisterFailed(error: failure.message)),
          (_) => emit(RegisterSuccess()),
    );
  }

}
