
import '../../../domain/entities/user/user.dart';

abstract class AuthEvent {
}

final class LoginAccount extends AuthEvent {
  final String username;
  final String password;

  LoginAccount({required this.username, required this.password});
}

class GetUserFromLocal extends AuthEvent {
  final User user;

  GetUserFromLocal({required this.user});

  List<Object?> get props => [user];
}

class RegisterAccount extends AuthEvent {
  final String fullName;
  final String username;
  final String password;
  final String buildingCode;
  final String houseCode;

  RegisterAccount({required this.fullName, required this.username, required this.password, required this.buildingCode, required this.houseCode});
}
