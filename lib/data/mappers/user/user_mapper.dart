import 'package:home_clean/data/models/user/user_model.dart';

import '../../../domain/entities/user/user.dart';

class UserMapper {
  static User toEntity(UserModel userModel) {
    return User(
      id: userModel.id ?? '',
      fullName: userModel.fullName ?? '',
      status: userModel.status ?? '',
      roomId: userModel.roomId ?? '',
      extraField: userModel.extraField ?? '',
      createdAt: userModel.createdAt ?? '',
      updatedAt: userModel.updatedAt ?? '',
      username: userModel.username ?? '',
      role: userModel.role ?? '',
    );
  }

  static UserModel toModel(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      status: user.status,
      roomId: user.roomId,
      extraField: user.extraField,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      username: user.username,
      role: user.role,
    );
  }
}