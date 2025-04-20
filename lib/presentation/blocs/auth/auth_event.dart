import '../../../domain/entities/user/user.dart';

abstract class AuthEvent {}

final class LoginAccount extends AuthEvent {
  final String username;
  final String password;

  LoginAccount({required this.username, required this.password});
}

class GetUserFromLocal extends AuthEvent {}

class RegisterAccount extends AuthEvent {
  final String fullName;
  final String username;
  final String password;
  final String buildingCode;
  final String houseCode;
  final String phoneNumber;
  final String email;
  final String citizenCode;

  RegisterAccount(
      {required this.fullName,
      required this.username,
      required this.password,
      required this.buildingCode,
      required this.houseCode,
      required this.phoneNumber,
      required this.email,
      required this.citizenCode});
}

class RefreshTokenEvent extends AuthEvent {}
