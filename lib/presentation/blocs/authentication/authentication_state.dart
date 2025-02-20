part of 'authentication_bloc.dart';

abstract class AuthenticationState {
}

class AuthenticationInitial extends AuthenticationState {
}

class AuthenticationLoading extends AuthenticationState {
}

class AuthenticationSuccess extends AuthenticationState {
}

class AuthenticationFailed extends AuthenticationState {
  final String error;

  AuthenticationFailed({required this.error});
}

class AuthenticationFromLocal extends AuthenticationState {
  final Authen authen;

  AuthenticationFromLocal({required this.authen});

}

class RegisterSuccess extends AuthenticationState {
}

class RegisterFailed extends AuthenticationState {
  final String error;

  RegisterFailed({required this.error});
}