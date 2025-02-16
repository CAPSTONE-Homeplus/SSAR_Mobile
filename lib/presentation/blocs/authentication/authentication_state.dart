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
