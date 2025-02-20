import 'package:equatable/equatable.dart';

class CreateUser extends Equatable {
  String? fullName;
  String? username;
  String? password;
  String? roomCode;

  CreateUser({
    this.fullName,
    this.username,
    this.password,
    this.roomCode,
  });

  @override
  List<Object?> get props => [
    fullName,
    username,
    password,
    roomCode,
  ];
}