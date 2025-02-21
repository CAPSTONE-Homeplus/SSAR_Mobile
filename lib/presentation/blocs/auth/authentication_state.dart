part of 'auth_bloc.dart';

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
  final Auth auth;

  AuthenticationFromLocal({required this.auth});

}

class RegisterSuccess extends AuthState {
}

class RegisterFailed extends AuthState {
  final String error;

  RegisterFailed({required this.error});
}