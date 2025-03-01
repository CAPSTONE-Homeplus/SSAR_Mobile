import 'package:equatable/equatable.dart';

class CreateUser extends Equatable {
  String? fullName;
  String? username;
  String? password;
  String? buildingCode;
  String? houseCode;
  String? phoneNumber;
  String? email;

  CreateUser({
    this.fullName,
    this.username,
    this.password,
    this.buildingCode,
    this.houseCode,
    this.phoneNumber,
    this.email,
    });

  @override
  List<Object?> get props => [fullName, username, password, buildingCode, houseCode, phoneNumber, email];
}