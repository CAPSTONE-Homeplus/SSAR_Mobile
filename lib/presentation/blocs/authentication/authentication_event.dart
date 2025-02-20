part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
}

final class LoginAccount extends AuthenticationEvent {
  final String username;
  final String password;

  LoginAccount({required this.username, required this.password});
}

class GetUserFromLocal extends AuthenticationEvent {
  final Authen authen;

  GetUserFromLocal({required this.authen});

  @override
  List<Object?> get props => [authen];
}

class RegisterAccount extends AuthenticationEvent {
  final String fullName;
  final String username;
  final String password;
  final String roomCode;

  RegisterAccount({required this.fullName, required this.username, required this.password, required this.roomCode});
}
