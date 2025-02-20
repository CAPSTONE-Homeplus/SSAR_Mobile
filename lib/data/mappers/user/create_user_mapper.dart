import 'package:home_clean/domain/entities/user/create_user.dart';

import '../../models/user/create_user_model.dart';

class CreateUserMapper {
  static CreateUser toEntity(CreateUserModel model) {
    return CreateUser(
      username: model.username ?? '',
      password: model.password ?? '',
      fullName: model.fullName ?? '',
      roomCode: model.roomCode ?? '',
    );
  }

  static CreateUserModel toModel(CreateUser entity) {
    return CreateUserModel(
      username: entity.username,
      password: entity.password,
      fullName: entity.fullName,
      roomCode: entity.roomCode,
    );
  }
}