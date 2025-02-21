part of 'auth_bloc.dart';

abstract class AuthEvent {
}

final class LoginAccount extends AuthEvent {
  final String username;
  final String password;

  LoginAccount({required this.username, required this.password});
}

class GetUserFromLocal extends AuthEvent {
  final Auth auth;

  GetUserFromLocal({required this.auth});

  List<Object?> get props => [auth];
}

class RegisterAccount extends AuthEvent {
  final String fullName;
  final String username;
  final String password;
  final String buildingCode;
  final String houseCode;

  RegisterAccount({required this.fullName, required this.username, required this.password, required this.buildingCode, required this.houseCode});
}
