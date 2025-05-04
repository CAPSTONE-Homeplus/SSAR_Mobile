import 'package:equatable/equatable.dart';

class CreateUser extends Equatable {
  String? id;
  String? fullName;
  String? username;
  String? password;
  String? buildingCode;
  String? houseCode;
  String? phoneNumber;
  String? email;
  String? citizenCode;

  CreateUser({
    this.id,
    this.fullName,
    this.username,
    this.password,
    this.buildingCode,
    this.houseCode,
    this.phoneNumber,
    this.email,
    this.citizenCode,
    });

  @override
  List<Object?> get props => [id, fullName, username, password, buildingCode, houseCode, phoneNumber, email, citizenCode];
}