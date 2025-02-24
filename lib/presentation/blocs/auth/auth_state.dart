
import '../../../domain/entities/user/user.dart';

abstract class AuthState {
}

class AuthenticationInitial extends AuthState {
}

class AuthenticationLoading extends AuthState {
}

class AuthenticationSuccess extends AuthState {
}

class AuthenticationFailed extends AuthState {
  final String error;

  AuthenticationFailed({required this.error});
}

class AuthenticationFromLocal extends AuthState {
  final User user;

  AuthenticationFromLocal({required this.user});

}

class RegisterSuccess extends AuthState {
}

class RegisterFailed extends AuthState {
  final String error;

  RegisterFailed({required this.error});
}