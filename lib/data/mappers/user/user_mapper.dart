import 'package:home_clean/data/models/user/user_model.dart';

import '../../../domain/entities/user/user.dart';

class UserMapper {
  static User toEntity(UserModel userModel) {
    return User(
      id: userModel.id ?? '',
      fullName: userModel.fullName ?? '',
      status: userModel.status ?? '',
      houseId: userModel.houseId,
      extraField: userModel.extraField,
      createdAt: userModel.createdAt ?? '',
      updatedAt: userModel.updatedAt ?? '',
      username: userModel.username ?? '',
      role: userModel.role ?? '',
    );
  }

  static UserModel toModel(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      status: json['status'],
      houseId: json['houseId'],
      extraField: json['extraField'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      username: json['username'],
      role: json['role'],
    );
  }

  static UserModel toModelFromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      status: user.status,
      houseId: user.houseId,
      extraField: user.extraField,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      username: user.username,
      role: user.role,
    );
  }

}