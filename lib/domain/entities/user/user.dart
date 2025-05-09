import 'package:equatable/equatable.dart';

class User extends Equatable {
  String? id;
  String? fullName;
  String? status;
  String? houseId;
  String? extraField;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? role;
  String? email;
  String? phoneNumber;

  User({
    this.id,
    this.fullName,
    this.status,
    this.houseId,
    this.extraField,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.role,
    this.email,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    status,
    houseId,
    extraField,
    createdAt,
    updatedAt,
    username,
    role,
    email,
    phoneNumber,
  ];
}
