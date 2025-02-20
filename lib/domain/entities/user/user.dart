import 'package:equatable/equatable.dart';

class User extends Equatable {
  String? id;
  String? fullName;
  String? status;
  String? roomId;
  String? extraField;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? role;

  User({
    this.id,
    this.fullName,
    this.status,
    this.roomId,
    this.extraField,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.role,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        status,
        roomId,
        extraField,
        createdAt,
        updatedAt,
        username,
        role,
      ];
}
